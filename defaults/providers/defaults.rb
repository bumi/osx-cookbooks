require 'chef/provider'

class Chef::Provider::Defaults < Chef::Provider
  class Option < Struct.new(:domain, :key, :value)
    class Type < Struct.new(:value)
      def to_s
        value.inspect
      end
    end

    class UnknownType < Type
      def self.new(value)
        raise "unknown type: #{value.inspect}"
      end

      def self.to_s
        raise NotImplemented
      end

      def self.from_ruby(value)
        Chef::Log.debug "Guessing defaults type for #{value.inspect}"
        [Boolean, String].each do |type|
          if obj = type.from_ruby(value) rescue nil
            return obj
          end
        end
        raise "unknown object: #{value.inspect}"
      end
    end

    class Boolean < Type
      def self.to_s
        'boolean'
      end

      def self.from_ruby(obj)
        case obj
        when TrueClass
          new('YES')
        when FalseClass, NilClass
          new('NO')
        else
          raise "unknown object: #{obj.inspect}"
        end
      end

      def to_ruby
        case value
        when '1', 'YES'
          true
        when '0', 'NO'
          false
        else
          raise "unknown value: #{value.inspect}"
        end
      end
    end

    class String < Type
      def self.to_s
        'string'
      end

      def self.from_ruby(obj)
        if obj.respond_to?(:to_str)
          new(obj)
        else
          raise "unknown object: #{obj.inspect}"
        end
      end

      def to_ruby
        value
      end
    end

    def type
      @type ||= read_type
    end

    def read_type
      if %x{defaults read-type #{domain} #{key} 2> /dev/null} =~ /Type is (\w+)/
        case $1
        when 'boolean'
          Boolean
        when 'string'
          String
        else
          UnknownType
        end
      else
        UnknownType
      end
    end

    def update_to_date?
      read == value
    end

    def read
      value = %x{defaults read #{domain} #{key} 2> /dev/null}.chomp
      $?.success? ? type.new(value).to_ruby : nil
    end

    def write_command
      value = type.from_ruby(self.value)
      "defaults write #{domain} #{key} -#{value.class} #{value}"
    end
  end

  include Chef::Mixin::Command

  def load_current_resource
    true
  end

  def action_run
    option = Option.new(@new_resource.domain, @new_resource.key, @new_resource.value)
    if option.update_to_date?
      Chef::Log.debug "Skipping #{@new_resource} since the value is already set"
    else
      if run_command(:command => option.write_command, :command_string => @new_resource.to_s)
        @new_resource.updated = true
        Chef::Log.info("Ran #{@new_resource} successfully")
      end
    end
  end
end

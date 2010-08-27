require 'chef/resource'

class Chef::Resource::Defaults < Chef::Resource
  def initialize(domain, key, run_context = nil)
    super("#{domain} #{key}", run_context)

    @domain = domain
    @key = key
    @value = nil

    @resource_name = :defaults
    @action = "run"
    @allowed_actions.push(:run)
  end

  def domain(arg = nil)
    set_or_return(:domain, arg, :kind_of => [String])
  end

  def key(arg = nil)
    set_or_return(:key, arg, :kind_of => [String])
  end

  def value(arg = nil)
    set_or_return(:value, arg, {})
  end
end

require 'chef/provider/service'

class Chef::Provider::Service::Launch < Chef::Provider::Service
  PATHS = [
    "#{ENV['HOME']}/Library/LaunchAgents",
    "/Library/LaunchAgents",
    "/Library/LaunchDaemons",
    "/System/Library/LaunchAgents",
    "/System/Library/LaunchDaemons"
  ]

  def self.detect_path(label)
    PATHS.each do |path|
      file = ::File.join(path, "#{label}.plist")
      return file if ::File.exist?(file)
    end

    ::File.join(PATHS.first, "#{label}.plist")
  end

  attr_reader :init_command, :status_command
  attr_reader :current_resource

  def initialize(new_resource, run_context = nil)
    super
    @init_command   = "launchctl"
    @status_command = "launchctl list"
  end

  def load_current_resource
    @current_resource = Chef::Resource::Service.new(new_resource.name)
    @current_resource.service_name(new_resource.service_name)
    @current_resource
  end

  def label
    new_resource.service_name
  end

  def path
    @path ||= self.class.detect_path(label)
  end

  def needs_sudo?
    path =~ %r{^/System}
  end

  def action_reload
    Chef::Log.debug("#{@new_resource}: attempting to reload")
    if reload_service
      @new_resource.updated = true
      Chef::Log.info("#{@new_resource}: reloaded successfully")
    end
  end

  def enable_service
    run_command(:command => "#{sudo}#{init_command} load -w -F #{path}")
    service_status.enabled
  end

  def disable_service
    run_command(:command => "#{sudo}#{init_command} unload -w -F #{path}")
    service_status.enabled
  end

  def start_service
    run_command(:command => "#{sudo}#{init_command} start #{label}")
    service_status.running
  end

  def stop_service
    run_command(:command => "#{sudo}#{init_command} stop #{label}")
    service_status.running
  end

  def restart_service
    stop_service if current_resource.running
    start_service
  end

  def reload_service
    disable_service if current_resource.enabled
    enable_service
  end

  def service_status
    pid = %x{#{sudo}#{status_command} | grep #{label} | awk '{print $1}'}.chomp

    case pid
    when ''
      current_resource.enabled(false)
      current_resource.running(false)
    when '-'
      current_resource.enabled(true)
      current_resource.running(false)
    else
      current_resource.enabled(true)
      current_resource.running(true)
    end

    current_resource
  end

  private
    def sudo
      if needs_sudo?
        "sudo "
      else
        ""
      end
    end
end

require 'chef/platform'
Chef::Platform.set :platform => :mac_os_x, :resource => :service, :provider => Chef::Provider::Service::Launch

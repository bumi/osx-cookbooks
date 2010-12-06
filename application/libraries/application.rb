require 'chef/resource'
require 'shellwords'

class Chef::Resource::Application < Chef::Resource
  def initialize(name, run_context = nil)
    name = "#{name}.app" if name !~ /\.app$/
    super(name, run_context)

    if run_context
      @user = run_context.node[:application][:user]
    else
      @user = nil
    end

    @resource_name = :application
    @action = "install"
    @allowed_actions.push(:download, :unarchive, :clean, :install)
  end

  def user(arg = nil)
    set_or_return(:user, arg, :kind_of => [String])
  end

  def source(arg = nil)
    set_or_return(:source, arg, :kind_of => [String])
  end
end


require 'chef/provider'

class Chef::Provider::Application < Chef::Provider
  include Chef::Mixin::Command

  def load_current_resource
    @current_resource = Chef::Resource::Application.new(@new_resource.name)
    @current_resource
  end

  def file_cache_path
    Chef::Config[:file_cache_path]
  end

  def cached_path
    ::File.join(file_cache_path, ::File.basename(@new_resource.source))
  end

  def extracted_path
    ::File.join(file_cache_path, ::File.basename(@new_resource.name, '.app'))
  end

  def remote_file_resource
    @remote_file_resource ||= build_remote_file_resource
  end

  def build_remote_file_resource
    resource_source = @new_resource.source

    remote_file cached_path do
      source resource_source
      action :nothing
    end
  end

  def action_download
    remote_file_resource.run_action :create_if_missing
  end

  def archive_resource
    @archive_resource ||= build_archive_resource
  end

  def build_archive_resource
    archive cached_path do
      not_if { ::File.exist?(extracted_path) }
      path extracted_path
    end
  end

  def action_unarchive
    archive_resource.run_action :extract
  end

  def action_clean
    file cached_path do
      action :delete
    end

    directory extracted_path do
      recursive true
      action :delete
    end
  end

  def action_install
    if !::File.exist?("/Applications/#{@new_resource.name}")
      @new_resource.run_action :download
      @new_resource.run_action :unarchive

      source  = ::File.join(extracted_path, @new_resource.name)
      command = "cp -R #{source.shellescape} /Applications"
      run_command(:command => command, :user => @new_resource.user)

      @new_resource.updated_by_last_action true
      Chef::Log.info("Ran #{@new_resource} successfully")

      @new_resource.run_action :clean
    end
  end
end

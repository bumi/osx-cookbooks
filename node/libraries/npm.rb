require 'chef/provider/package'

class Chef::Provider::Package::Npm < ::Chef::Provider::Package
  def initialize(new_resource, run_context)
    super

    @user = run_context.node[:npm][:user]
  end

  def load_current_resource
    @current_resource = Chef::Resource::NpmPackage.new(@new_resource.name)
    @current_resource.package_name(@new_resource.name)

    @current_resource.version(current_installed_version)
    Chef::Log.debug("Current version is #{@current_resource.version}") if @current_resource.version

    @candidate_version = npm_candiate_version

    if !@new_resource.version && !@candidate_version
      raise Chef::Exceptions::Package, "Could not get a candidate version for this package -- #{@new_resource.name} does not seem to be a valid package!"
    end

    Chef::Log.debug("npm candidate version is #{@candidate_version}")

    @current_resource
  end

  def current_installed_version
    status, stdout, stderr = output_of_command("npm ls installed #{@new_resource.package_name}", {:user => @user})
    status == 0 ? version_from_output(stdout) : nil
  end

  def npm_candiate_version
    status, stdout, stderr = output_of_command("npm ls #{@new_resource.package_name}", {:user => @user})
    status == 0 ? version_from_output(stdout) : nil
  end

  def install_package(name, version)
    run_npm_command "npm install#{expand_options(@new_resource.options)} #{name}"
  end

  def upgrade_package(name, version)
    install_package(name, version)
  end

  def remove_package(name, version)
    purge_package(name, version)
  end

  def purge_package(name, version)
    run_npm_command "npm uninstall #{name}"
  end

  def run_npm_command(command)
    run_command(:command => command, :user => @user)
  end

  def version_from_output(output)
    if output =~ /Nothing found/
      nil
    else
      strip_colors(output).split("\n").last.split(/\s|@/)[1]
    end
  end

  def strip_colors(output)
    output.gsub(/\e\[\d*m/, '')
  end
end

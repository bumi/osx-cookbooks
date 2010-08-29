require 'chef/provider/package'

class Chef::Provider::Package::Homebrew < ::Chef::Provider::Package
  def load_current_resource
    @current_resource = Chef::Resource::HomebrewPackage.new(@new_resource.name)
    @current_resource.package_name(@new_resource.name)

    @current_resource.version(current_installed_version)
    Chef::Log.debug("Current version is #{@current_resource.version}") if @current_resource.version

    @candidate_version = homebrew_candiate_version

    if !@new_resource.version && !@candidate_version
      raise Chef::Exceptions::Package, "Could not get a candidate version for this package -- #{@new_resource.name} does not seem to be a valid package!"
    end

    Chef::Log.debug("Homebrew candidate version is #{@candidate_version}")

    @current_resource
  end

  def current_installed_version
    v = %x{brew list #{@new_resource.package_name} --versions}.chomp.split(' ').last
    $?.success? ? v : nil
  end

  def homebrew_candiate_version
    v = %x{brew info #{@new_resource.package_name} | head -n1 | awk '{print $2}'}.chomp
    $?.success? ? v : nil
  end

  def install_package(name, version)
    run_brew_command "brew install #{name}"
  end

  def upgrade_package(name, version)
    install_package(name, version)
  end

  def remove_package(name, version)
    run_brew_command "brew unlink #{name}"
  end

  def purge_package(name, version)
    run_brew_command "brew uninstall #{name}"
  end

  def run_brew_command(command)
    run_command(:command => command)
  end
end

require 'chef/platform'
Chef::Platform.set :platform => :mac_os_x, :resource => :package, :provider => Chef::Provider::Package::Homebrew

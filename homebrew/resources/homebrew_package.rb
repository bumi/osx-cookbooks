require 'chef/resource/package'

class Chef::Resource::HomebrewPackage < ::Chef::Resource::Package
  def initialize(name, run_context = nil)
    super
    @resource_name = :homebrew_package
    @provider      = Chef::Provider::Package::Homebrew
  end
end

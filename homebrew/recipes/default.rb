directory node[:homebrew][:prefix] do
  action :create
  owner node[:homebrew][:user]
end

directory Chef::Config[:file_cache_path]
homebrew_tar = "#{Chef::Config[:file_cache_path]}/mxcl-homebrew.tar.gz"

remote_file homebrew_tar do
  source "http://github.com/mxcl/homebrew/tarball/master"
  owner node[:homebrew][:user]
  action :create_if_missing
end

execute "tar -xzf #{homebrew_tar} -C #{node[:homebrew][:prefix]} --strip 1" do
  user node[:homebrew][:user]
  creates "#{node[:homebrew][:prefix]}/bin/brew"
end

ruby_block "check homebrew" do
  block do
    result = `#{node[:homebrew][:prefix]}/bin/brew --version`
    raise("brew not working: #{result}") unless result.strip.to_f >= 0.7
  end
end

include_recipe "git"

execute "#{node[:homebrew][:prefix]}/bin/brew update" do
  user node[:homebrew][:user]
end

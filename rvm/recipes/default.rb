require 'shellwords'

package "git"

rvm_git = "#{Chef::Config[:file_cache_path]}/rvm"
prefix = node[:rvm][:prefix]

execute "git clone https://github.com/wayneeseguin/rvm.git #{rvm_git}" do
  not_if { File.exist?(rvm_git) || File.exist?("#{prefix}rvm") }
end

execute "#{rvm_git}/scripts/install --prefix #{prefix.shellescape}" do
  user node[:rvm][:user]
  not_if { File.exist?("#{prefix}rvm") }
end

node[:rvm][:rubies].each do |ruby|
  bash "rvm install #{ruby}" do
    code <<-EOS
      export rvm_path=#{node[:rvm][:prefix]}rvm
      source "#{node[:rvm][:prefix]}rvm/scripts/rvm"
      rvm install #{ruby}
    EOS
    not_if <<-EOS
      export rvm_path=#{node[:rvm][:prefix]}rvm
      source "#{node[:rvm][:prefix]}rvm/scripts/rvm"
      rvm list | grep #{ruby}
   EOS
    user node[:rvm][:user]
  end
end

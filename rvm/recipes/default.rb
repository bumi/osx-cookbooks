package "git"

rvm_git = "#{Chef::Config[:file_cache_path]}/rvm"
prefix = node[:rvm][:prefix]

execute "git clone https://github.com/wayneeseguin/rvm.git #{rvm_git}" do
  user node[:homebrew][:user]
  not_if { File.exist?(rvm_git) || File.exist?("#{prefix}rvm") }
end

execute "#{rvm_git}/bin/rvm-install --prefix #{prefix.inspect}" do
  user node[:homebrew][:user]
  not_if { File.exist?("#{prefix}rvm") }
end

package "git"

bash "install rvm" do
  prefix = node[:rvm][:prefix]
  code <<-EOS
    git clone https://github.com/wayneeseguin/rvm.git
    cd ./rvm/
    ./bin/rvm-install --prefix #{prefix}"
  EOS
  user node[:homebrew][:user]
  not_if { File.exist? "#{prefix}rvm" }
end

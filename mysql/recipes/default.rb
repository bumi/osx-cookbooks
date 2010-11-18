include_recipe "homebrew"

package "mysql"

execute "mysql_install_db" do
  user node[:homebrew][:user]
  creates "#{node[:homebrew][:prefix]}/var/mysql"
end

launch_service "com.mysql.mysqld" do
  template_variables :prefix => node[:homebrew][:prefix]
end

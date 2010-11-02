include_recipe "homebrew"

package "mysql"

execute "mysql_install_db" do
  user node[:homebrew][:user]
  creates "/usr/local/var/mysql"
end

launch_service "com.mysql.mysqld" do
  template_variables :user => node[:launch][:user]
end

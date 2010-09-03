include_recipe "homebrew"

package "mysql"

launch_service "com.mysql.mysqld" do
  template_variables :user => node[:launch][:user]
end

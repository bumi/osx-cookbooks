package "mysql"

launch_service "com.mysql.mysqld" do
  template_variables :user => ENV['USER']
end

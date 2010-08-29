DESCRIPTION
===========

Provides launchd service

PROVIDERS
=========

Launch services support `enable`, `disable`, `start`, `stop`, `restart` and `reload`.

`Chef::Provider::Service::Launch` is set to the default service on OS X.

    service "com.apple.Finder" do
      # provider Chef::Provider::Service::Launch
      action :restart
    end

DEFINITIONS
===========

`launch_service` will define a new launch agent template and service in your recipe.

    launch_service "com.mysql.mysqld" do
      template_variables :user => ENV['USER']
    end

    # templates/default/com.mysql.mysqld.plist.erb
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>com.mysql.mysqld</string>
      <key>Program</key>
      <string>/usr/local/bin/mysqld_safe</string>
      <key>RunAtLoad</key>
      <true/>
      <key>UserName</key>
      <string><%= @user %></string>
      <key>WorkingDirectory</key>
      <string>/usr/local/var</string>
    </dict>
    </plist>

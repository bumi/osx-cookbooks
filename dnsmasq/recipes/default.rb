include_recipe "homebrew"

package "dnsmasq"

template "/usr/local/etc/dnsmasq.conf" do
  source "dnsmasq.conf"

  owner node[:homebrew][:user]
  group "staff"
end

launch_service "uk.org.thekelleys.dnsmasq" do
  path "/Library/LaunchDaemons/uk.org.thekelleys.dnsmasq.plist"
  template_variables :user => node[:launch][:user]
end

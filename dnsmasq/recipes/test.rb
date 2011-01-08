include_recipe "dnsmasq"

directory "/etc/resolver" do
  action :create
  owner "root"
  group "wheel"
end

template "/etc/resolver/test" do
  source "test"

  owner "root"
  group "wheel"
  mode 0755
end

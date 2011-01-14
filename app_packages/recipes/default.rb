node[:app_packages].each do |name, url|
  application name do
    source url
  end
end
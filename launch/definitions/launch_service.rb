define :launch_service do
  resource = service params[:name] do
    provider Chef::Provider::Service::Launch
    action :nothing
  end

  params[:template_name] ||= "#{params[:name]}.plist.erb"
  params[:path] ||= Chef::Provider::Service::Launch.detect_path(params[:name])

  template params[:path] do
    source params[:template_name]
    variables params[:template_variables]
    notifies :reload, resource
  end
end

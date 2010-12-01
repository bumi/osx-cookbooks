define :launch_service do
  resource = service params[:name] do
    provider Chef::Provider::Service::Launch
  end

  params[:template_name] ||= "#{params[:name]}.plist.erb"
  params[:path] ||= Chef::Provider::Service::Launch.detect_path(params[:name])

  dirname = File.dirname(params[:path])
  unless Chef::Provider::Service::Launch.path_owned_by_root?(dirname)
    directory dirname do
      owner node[:launch][:user]
      group "staff"
    end
  end

  template params[:path] do
    mode "0644"

    if Chef::Provider::Service::Launch.path_owned_by_root?(params[:path])
      owner "root"
      group "wheel"
    else
      owner node[:launch][:user]
      group "staff"
    end

    source params[:template_name]
    variables params[:template_variables]
    notifies :reload, resource
  end
end

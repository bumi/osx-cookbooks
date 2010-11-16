define :rvm do
  bash "rvm #{params[:name]}" do
    code <<-EOS
      export rvm_path=#{node[:rvm][:prefix]}rvm
      source "#{node[:rvm][:prefix]}rvm/scripts/rvm"
      rvm #{params[:name]}
    EOS
    user node[:rvm][:user]
  end
end

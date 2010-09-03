include_recipe "homebrew"
include_recipe "ruby::ree"

package "rpg"

launch_service "com.github.rpg.sync" do
  template_variables :user => node[:launch][:user]
end

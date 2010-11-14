include_recipe "homebrew"

package "redis"

if node[:redis][:launchd]
  launch_service "io.redis.redis-server"
end

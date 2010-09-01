default.homebrew[:user] = ENV['SUDO_USER'] || ENV['USER']
default.homebrew[:prefix] = "/usr/local"
default.homebrew[:cellar] = "#{homebrew[:prefix]}/Cellar"
default.homebrew[:repository] = "#{homebrew[:prefix]}"
default.homebrew[:library] = "#{homebrew[:prefix]}/Library/Homebrew"

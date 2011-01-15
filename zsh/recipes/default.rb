include_recipe "homebrew"

package "zsh"

script "install oh-my-zsh" do
  interpreter "bash"
  code "curl https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh"
  creates "~/.oh-my-zsh"
end
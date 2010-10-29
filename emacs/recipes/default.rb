include_recipe "homebrew"

package "emacs"

package "ack"

package "aspell" do
  options "--lang=en"
end

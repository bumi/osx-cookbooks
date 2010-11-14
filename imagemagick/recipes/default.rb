include_recipe "homebrew"

package "imagemagick" do
  if node[:imagemagick][:ghostscript]
    options "--with-ghostscript"
  end
end

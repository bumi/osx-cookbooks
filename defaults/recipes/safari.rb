defaults "com.apple.safari", "IncludeDevelopMenu" do
  value node[:apple][:safari][:develop_menu]
end

defaults "com.apple.safari", "AutoFillPasswords" do
  value node[:apple][:safari][:auto_fill_passwords]
end

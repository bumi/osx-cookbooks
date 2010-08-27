ruby_block "check homebrew" do
  block do
    result = `brew --version`
    raise("brew not working: #{result}") unless result.strip.to_f >= 0.7
  end
end

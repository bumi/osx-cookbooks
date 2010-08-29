DESCRIPTION
===========

Configures OS X user defaults

RESOURCES
=========

The `defaults` resource requires writes the `value` to the given `domain` and `key`.

    dock = service "com.apple.Dock.agent"

    defaults "com.apple.dock", "orientation" do
      value "left"

      # Tell Dock to restart if the value has changed
      notifies :restart, dock, :delayed
    end

    defaults "com.apple.dock", "autohide" do
      value true
    end

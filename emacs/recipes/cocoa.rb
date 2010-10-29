include_recipe "emacs"

application "Emacs" do
  source "http://emacsformacosx.com/emacs-builds/Emacs-23.2-universal-10.6.3.dmg"
end

include_recipe "peepopen"

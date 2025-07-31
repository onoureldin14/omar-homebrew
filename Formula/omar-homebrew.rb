class OmarHomebrew < Formula
    desc "Install developer CLI aliases and azdo-done automation"
    homepage "https://github.com/onoureldin14/omar-homebrew"
    version "1.0.0"
  
    def install
      bin.install "install.sh"
      chmod 0755, bin/"install.sh"
      system "bash", "#{bin}/install.sh"
    end
  
    def caveats
      <<~EOS
        ✅ Aliases and functions installed.
  
        To apply them now, run:
          source ~/.zshrc
  
        You can edit or extend them from ~/.dotfiles/
      EOS
    end
  end
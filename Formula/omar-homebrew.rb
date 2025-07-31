class OmarHomebrew < Formula
    desc "Install developer CLI aliases and azdo-done automation"
    homepage "https://github.com/onoureldin14/omar-homebrew"
    url "https://github.com/onoureldin14/omar-homebrew/archive/refs/heads/main.zip"
    version "1.0.0"
    sha256 "ee1a70807a9278b2392b3b13cf87a7b6af6a75e02e85b71529a5d47abfa8a32f" # see note below
  
    def install
      bin.install "install.sh"
      chmod 0755, bin/"install.sh"
      system "bash", "#{bin}/install.sh"
    end
  
    def caveats
      <<~EOS
        ✅ Developer aliases and azdo-done installed.
  
        To apply them now, run:
          source ~/.zshrc
      EOS
    end
  end
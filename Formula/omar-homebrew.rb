class OmarHomebrew < Formula
    desc "Install developer CLI aliases and azdo-done automation"
    homepage "https://github.com/onoureldin14/omar-homebrew"
    url "https://github.com/onoureldin14/omar-homebrew/archive/refs/heads/main.zip"
    version "1.0.0"
    sha256 "b55cccaeb8b773749a81ebcba5d6ed63c5c6b6a3faf21cc7b42bc2817400dd88"
  
    def install
      bin.install "install.sh"
      chmod 0755, bin/"install.sh"
      system "bash", "#{bin}/install.sh"
    end
  
    def caveats
      <<~EOS
        ✅ Developer aliases and azdo-done have been installed.
  
        To apply them now, run:
          source ~/.zshrc
      EOS
    end
  end
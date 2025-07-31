class OmarHomebrew < Formula
    desc "Install developer CLI aliases and azdo-done automation"
    homepage "https://github.com/onoureldin14/omar-homebrew"
    url "https://github.com/onoureldin14/omar-homebrew/archive/refs/heads/main.zip"
    version "1.0.0"
    sha256 "39f773a5be86a5818d8d76ba6c4c346ea84371b61b9fa31a93d6236f873bc18a"
  
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
      EOS
    end
  end
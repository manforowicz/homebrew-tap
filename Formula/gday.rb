class Gday < Formula
  desc "Command line tool to securely send files (without a relay or port forwarding)."
  homepage "https://github.com/manforowicz/gday/"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/manforowicz/gday/releases/download/v0.4.0/gday-aarch64-apple-darwin.tar.gz"
      sha256 "2f6b40127914292839c6bb0f3b4d5dd7536af27b5beaa2de8f41444ed0059a86"
    end
    if Hardware::CPU.intel?
      url "https://github.com/manforowicz/gday/releases/download/v0.4.0/gday-x86_64-apple-darwin.tar.gz"
      sha256 "81cffb16c97d6183ce4504945be56f73f83f34e8f59b98eba0b4338deb04c955"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/manforowicz/gday/releases/download/v0.4.0/gday-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4713b317200232ec39610c0aead2332344b696d6aa32296581f2a30d830db498"
    end
    if Hardware::CPU.intel?
      url "https://github.com/manforowicz/gday/releases/download/v0.4.0/gday-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f1f36c68e22595fdc98125336fb1301cf1cc4796fc5c22261d5da34f4cc64e87"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "gday" if OS.mac? && Hardware::CPU.arm?
    bin.install "gday" if OS.mac? && Hardware::CPU.intel?
    bin.install "gday" if OS.linux? && Hardware::CPU.arm?
    bin.install "gday" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

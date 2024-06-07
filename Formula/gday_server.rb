class GdayServer < Formula
  desc "A server that lets 2 peers exchange their private and public addresses via the gday contact exchange protocol."
  homepage "https://github.com/manforowicz/gday/gday_server/"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/manforowicz/gday/releases/download/v0.1.1/gday_server-aarch64-apple-darwin.tar.xz"
      sha256 "469b75fd36e214ce8ba549f049498ea496d22944b1623e3db192aada6fdb34d2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/manforowicz/gday/releases/download/v0.1.1/gday_server-x86_64-apple-darwin.tar.xz"
      sha256 "aa2dbe57a947f082116ae6825fe84e396b1e0d11bf7f22da9b8e75428f2e02ab"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/manforowicz/gday/releases/download/v0.1.1/gday_server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a21aa9953c81e37da63d945ff0c3ca50c6095f3e6e17fc45789e93c5a0632d7b"
    end
  end
  license "MIT"

  BINARY_ALIASES = {"aarch64-apple-darwin": {}, "x86_64-apple-darwin": {}, "x86_64-pc-windows-gnu": {}, "x86_64-unknown-linux-gnu": {}}

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "gday_server"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "gday_server"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "gday_server"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

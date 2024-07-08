class GdayServer < Formula
  desc "Server that lets 2 peers exchange their socket addresses."
  homepage "https://github.com/manforowicz/gday/tree/main/gday_server"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/manforowicz/gday/releases/download/v0.2.0/gday_server-aarch64-apple-darwin.tar.gz"
      sha256 "618a1866e34e8339db1fd36ddbee677b2492e9f57a95f6740800d7a80decb2b2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/manforowicz/gday/releases/download/v0.2.0/gday_server-x86_64-apple-darwin.tar.gz"
      sha256 "7c3009bbeca5206c97f9884137661a4efbf767d1f01967ee2c62a4a335d19ab1"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/manforowicz/gday/releases/download/v0.2.0/gday_server-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8240201ed17fd41f5ca07fec421c16cbbf5e20d85d0e43b7c9a50d241c11416d"
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

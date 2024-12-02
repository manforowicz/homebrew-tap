class GdayServer < Formula
  desc "Server that lets 2 peers exchange their socket addresses."
  homepage "https://github.com/manforowicz/gday/tree/main/gday_server"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/manforowicz/gday/releases/download/v0.3.0/gday_server-aarch64-apple-darwin.tar.gz"
      sha256 "527df5ac7ffbaf71e13bfca2c85e4214ef81e9d8b3aa28593000990a609ced2f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/manforowicz/gday/releases/download/v0.3.0/gday_server-x86_64-apple-darwin.tar.gz"
      sha256 "9f5202e77e203b40cbf6091f7822702b3ad70c28b8f8c40f187e6f1afb47a0cb"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/manforowicz/gday/releases/download/v0.3.0/gday_server-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "eef9fec1d1b62d239042b74a7b3a130373a4a65432da98034ab8b5e3e40d0ea1"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "gday_server" if OS.mac? && Hardware::CPU.arm?
    bin.install "gday_server" if OS.mac? && Hardware::CPU.intel?
    bin.install "gday_server" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

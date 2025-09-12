class Gday < Formula
  desc "Command line tool to securely send files (without a relay or port forwarding)."
  homepage "https://github.com/manforowicz/gday/"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/manforowicz/gday/releases/download/v0.5.0/gday-aarch64-apple-darwin.tar.gz"
      sha256 "9cdfa87fb1ef3b03cf2db26ed912ef72ff7800334e25000b8994c3c144b4ff21"
    end
    if Hardware::CPU.intel?
      url "https://github.com/manforowicz/gday/releases/download/v0.5.0/gday-x86_64-apple-darwin.tar.gz"
      sha256 "845ae1153bdc89fc4f868661085e74cc8b15b825aa46b3b1d6d76ff2cd4232c5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/manforowicz/gday/releases/download/v0.5.0/gday-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d914a5de59dd69d5973245205cea584bcb14fecdede7f9fdf038e9d0bfa5071a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/manforowicz/gday/releases/download/v0.5.0/gday-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e205e1429d612c89d5f2c8c211d8020e39b31d23478f0f6b48adae0fae44f930"
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

class Gday < Formula
  desc "Command line tool to securely send files (without a relay or port forwarding)."
  homepage "https://github.com/manforowicz/gday/tree/main/gday"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/manforowicz/gday/releases/download/v0.3.0/gday-aarch64-apple-darwin.tar.gz"
      sha256 "a76cb13058702cf3dfbfba84f581bd0a53e476e3ea8c1d0236c98822ca0275c1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/manforowicz/gday/releases/download/v0.3.0/gday-x86_64-apple-darwin.tar.gz"
      sha256 "c50a2f7329988e5dcfb1cf9b74169ec43f5f497d6d223cf992632350683c7d70"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/manforowicz/gday/releases/download/v0.3.0/gday-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "68b426f8e40868c4fd8222c39f076b9819d20d28063201878830330ce0dcefd6"
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
    bin.install "gday" if OS.mac? && Hardware::CPU.arm?
    bin.install "gday" if OS.mac? && Hardware::CPU.intel?
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

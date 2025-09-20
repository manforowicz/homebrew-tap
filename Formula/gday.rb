class Gday < Formula
  desc "Command line tool to securely send files (without a relay or port forwarding)."
  homepage "https://github.com/manforowicz/gday/"
  version "0.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/manforowicz/gday/releases/download/v0.5.1/gday-aarch64-apple-darwin.tar.gz"
      sha256 "354adfe39ed838eead05f61f299a736ac57cdc89c9dbcf54b24058fc882ff3b9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/manforowicz/gday/releases/download/v0.5.1/gday-x86_64-apple-darwin.tar.gz"
      sha256 "e60783585ab09cd07d304ea3cd8b84271107196bbe73c384897d79d9caef50f5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/manforowicz/gday/releases/download/v0.5.1/gday-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c331ee71bbc0bd48a993d0f97be83738413e6ac4e7f961a41412c7798486d5d5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/manforowicz/gday/releases/download/v0.5.1/gday-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fab0c9a1bb8fae9b0010bf4c4b5de9a2272db954946ca290954cca7deb56d8e0"
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

class GdayGui < Formula
  desc "GUI to securely send files (without a relay or port forwarding)."
  homepage "https://github.com/manforowicz/gday/"
  version "0.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/manforowicz/gday/releases/download/v0.5.1/gday_gui-aarch64-apple-darwin.tar.gz"
      sha256 "fd9e86d3a56437e6d5b4a7b5e8695115551e4e66f209bfd28da9abd5073a392b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/manforowicz/gday/releases/download/v0.5.1/gday_gui-x86_64-apple-darwin.tar.gz"
      sha256 "cac93c27e75395b6f1bf0c7377d6e2f5a2ebc5b3a3e9df11bda120e4b4d1ce6f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/manforowicz/gday/releases/download/v0.5.1/gday_gui-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0389f7fd8b921a94280c295d6b3ee563c85d997672db4b7bee8bc6c25205e80c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/manforowicz/gday/releases/download/v0.5.1/gday_gui-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "549a49c9bfb379b84f973d24c579b5448f5c5dea6113f302676e6bb6ae1ba992"
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
    bin.install "gday_gui" if OS.mac? && Hardware::CPU.arm?
    bin.install "gday_gui" if OS.mac? && Hardware::CPU.intel?
    bin.install "gday_gui" if OS.linux? && Hardware::CPU.arm?
    bin.install "gday_gui" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

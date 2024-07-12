class Gday < Formula
  desc "Command line tool to securely send files (without a relay or port forwarding)."
  homepage "https://github.com/manforowicz/gday/tree/main/gday"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/manforowicz/gday/releases/download/v0.2.1/gday-aarch64-apple-darwin.tar.gz"
      sha256 "25af9b5df32d17eb5c48dc033d05b8c073c12fbd27d10dc7dbae3a79287f2708"
    end
    if Hardware::CPU.intel?
      url "https://github.com/manforowicz/gday/releases/download/v0.2.1/gday-x86_64-apple-darwin.tar.gz"
      sha256 "ced2d1471cf520bd861b262991d54a373685a1df8063482100ec73ce67c5b6dd"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/manforowicz/gday/releases/download/v0.2.1/gday-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "691e67626fec65fab750ca8614d01057534e40a035b7c9e7ff0a8885b237d6c4"
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
      bin.install "gday"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "gday"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "gday"
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

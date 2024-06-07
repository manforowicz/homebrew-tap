class Gday < Formula
  desc "Command line tool to send files directly and securely, without a relay or port forwarding."
  homepage "https://github.com/manforowicz/gday/gday/"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/manforowicz/gday/releases/download/v0.1.1/gday-aarch64-apple-darwin.tar.xz"
      sha256 "4ab0aea6b538fcbcc8ed2f6a149080997a80082fe9a7b1cd970df993d91ced38"
    end
    if Hardware::CPU.intel?
      url "https://github.com/manforowicz/gday/releases/download/v0.1.1/gday-x86_64-apple-darwin.tar.xz"
      sha256 "3866c777f2f19ab7f56777c1435c10f618d624d86980c523d16fea00069b5d00"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/manforowicz/gday/releases/download/v0.1.1/gday-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fa959e13f4d13ea23bb138055b59e16f40894bc8828ea1beff2aefb1e1eff072"
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

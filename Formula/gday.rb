class Gday < Formula
  desc "Command line tool to send files easily, securely, and directly, without a relay or port forwarding."
  homepage "https://github.com/manforowicz/gday/gday/"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/manforowicz/gday/releases/download/v0.1.1/gday-aarch64-apple-darwin.tar.xz"
      sha256 "57f91bd71e97c8dfedcdccbf2d960dbc9adc0918dc0cee73bc178093ed085433"
    end
    if Hardware::CPU.intel?
      url "https://github.com/manforowicz/gday/releases/download/v0.1.1/gday-x86_64-apple-darwin.tar.xz"
      sha256 "e73b1a3506bfdb5d6a943c1630b38e7add4b004b5e037b7f52bb54717bce4bcc"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/manforowicz/gday/releases/download/v0.1.1/gday-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fc11fd4535f2c08f73a2505620fc3432256c9a275e4dd76e3fe30ef2fb575e6d"
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

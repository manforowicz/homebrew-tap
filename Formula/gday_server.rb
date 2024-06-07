class GdayServer < Formula
  desc "Server that lets 2 peers exchange their socket addresses."
  homepage "https://github.com/manforowicz/gday/gday_server/"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/manforowicz/gday/releases/download/v0.1.1/gday_server-aarch64-apple-darwin.tar.xz"
      sha256 "3ce434116d5b36fa3c1353bb9a058343a219802c39811397f301459093f9e3b2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/manforowicz/gday/releases/download/v0.1.1/gday_server-x86_64-apple-darwin.tar.xz"
      sha256 "ced1d189422c4b3d22fcfe3e44a18fb47991b894766cc506c4c7fc0e18c67bf1"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/manforowicz/gday/releases/download/v0.1.1/gday_server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6eef5cea9fda6abf5bb01b5c62ea75879253cb3c274c5e76fa917a425659d9d5"
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

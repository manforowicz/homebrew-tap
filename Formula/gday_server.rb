class GdayServer < Formula
  desc "Server that lets 2 peers exchange their socket addresses."
  homepage "https://github.com/manforowicz/gday/tree/main/gday_server"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/manforowicz/gday/releases/download/v0.2.1/gday_server-aarch64-apple-darwin.tar.gz"
      sha256 "86376b1acc94ccea30d6b38963e8759702ccec31c00774cb5bc057451b3731f1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/manforowicz/gday/releases/download/v0.2.1/gday_server-x86_64-apple-darwin.tar.gz"
      sha256 "533af40d8f9bde479d88537d4035a180c48892c6799005e2252e327f0770f70c"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/manforowicz/gday/releases/download/v0.2.1/gday_server-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "eaf45a54b7f4097a378333e8ff3db42e4f6c28bb4758d5c22c0a6070397d3e83"
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

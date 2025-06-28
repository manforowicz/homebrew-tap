class GdayServer < Formula
  desc "Server that lets 2 peers exchange their socket addresses."
  homepage "https://github.com/manforowicz/gday/"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/manforowicz/gday/releases/download/v0.4.0/gday_server-aarch64-apple-darwin.tar.gz"
      sha256 "e056e3bc44c8e890fd34e0925fdcd66da014bc359153ff2e8a5fc1ba4b69e0b7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/manforowicz/gday/releases/download/v0.4.0/gday_server-x86_64-apple-darwin.tar.gz"
      sha256 "5549e13388225151a88fd6c30bc03d366a7884b765c2c3babf8c63f1052a367a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/manforowicz/gday/releases/download/v0.4.0/gday_server-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0200e1208b0ecafc277a1740a0e3fe1d89cd218719eccd21fbac1dc1c82c59b4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/manforowicz/gday/releases/download/v0.4.0/gday_server-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3509adedcf5f467dc84387bb2115987a5b5fb10f0c53e42c38aed7114af8a65e"
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
    bin.install "gday_server" if OS.mac? && Hardware::CPU.arm?
    bin.install "gday_server" if OS.mac? && Hardware::CPU.intel?
    bin.install "gday_server" if OS.linux? && Hardware::CPU.arm?
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

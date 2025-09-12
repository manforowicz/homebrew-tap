class GdayServer < Formula
  desc "Server that lets 2 peers exchange their socket addresses."
  homepage "https://github.com/manforowicz/gday/"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/manforowicz/gday/releases/download/v0.5.0/gday_server-aarch64-apple-darwin.tar.gz"
      sha256 "ab08fe7c1d7afe231f07dd41072a79f2b4e2e68517a4da3f638faa135385e51e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/manforowicz/gday/releases/download/v0.5.0/gday_server-x86_64-apple-darwin.tar.gz"
      sha256 "eb26ce53c3fa7de8f66c6d014f5bc5b9509b690539fde3ceccde3fd81536b14d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/manforowicz/gday/releases/download/v0.5.0/gday_server-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2c9561954f385e21474679cc56a3e1bd76759796b45f3dff5eb2a243afec17b9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/manforowicz/gday/releases/download/v0.5.0/gday_server-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b3fe6e1abba2da7fe64ce5d6b1ba61ebae926db69ea7840d9b1ea2839fe58d64"
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

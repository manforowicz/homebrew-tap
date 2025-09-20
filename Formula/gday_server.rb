class GdayServer < Formula
  desc "Server that lets 2 peers exchange their socket addresses."
  homepage "https://github.com/manforowicz/gday/"
  version "0.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/manforowicz/gday/releases/download/v0.5.1/gday_server-aarch64-apple-darwin.tar.gz"
      sha256 "be5f0496eb98ead51da498683b479bb6e93a49456d72b83c27a479f57adeec70"
    end
    if Hardware::CPU.intel?
      url "https://github.com/manforowicz/gday/releases/download/v0.5.1/gday_server-x86_64-apple-darwin.tar.gz"
      sha256 "f5a80e31d1b08b2ecdd0735ebd1b567e27add49d33a8818cadf9bedfa4ee4e10"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/manforowicz/gday/releases/download/v0.5.1/gday_server-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "af71ec48cc50cd0cfbba3ce08a5124842641521a7c30505203ea8b8b901c2935"
    end
    if Hardware::CPU.intel?
      url "https://github.com/manforowicz/gday/releases/download/v0.5.1/gday_server-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5d9c8a21d7bed73236e806666b6718fe365f0a3a43335e2a009e845bf2834aee"
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

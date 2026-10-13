# Homebrew formula; all archives remain hosted on zitro.sh.
#   brew install ZitroSoftware/tap/zitro
class Zitro < Formula
  desc "Command line interface for the zitro Cloud API"
  homepage "https://zitro.sh"
  version "0.6.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://zitro.sh/dl/0.6.0/zitro_0.6.0_darwin_arm64.tar.gz"
      sha256 "52dff556452b16d80a9dd2ec3352be3a4509e4206d2babb8ee7580a396982bb1"
    end
    on_intel do
      url "https://zitro.sh/dl/0.6.0/zitro_0.6.0_darwin_amd64.tar.gz"
      sha256 "ce96b5d064c35aa51c307c6b5f7da44c0d669be0d3c828adc31faeacb8c002ca"
    end
  end

  on_linux do
    on_arm do
      url "https://zitro.sh/dl/0.6.0/zitro_0.6.0_linux_arm64.tar.gz"
      sha256 "3bb5b1994035392e451a69b464c5e4ad3c025e282a71593cfcb21ddd70b5c435"
    end
    on_intel do
      url "https://zitro.sh/dl/0.6.0/zitro_0.6.0_linux_amd64.tar.gz"
      sha256 "d4ca3e7f30398791a78e0e6c117b602f78552204cb4d0ee8409c3840f1590dd7"
    end
  end

  def install
    bin.install "zitro"
    generate_completions_from_executable(bin/"zitro", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zitro version")
  end
end

# Homebrew formula; all archives remain hosted on zitro.sh.
#   brew install ZitroSoftware/tap/zitro
class Zitro < Formula
  desc "Command line interface for the zitro Cloud API"
  homepage "https://zitro.sh"
  version "0.7.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://zitro.sh/dl/0.7.0/zitro_0.7.0_darwin_arm64.tar.gz"
      sha256 "53861f077fca2b84efecd8ee9e0ab403ceab9f2b51b401e2180680f8f64a2c2b"
    end
    on_intel do
      url "https://zitro.sh/dl/0.7.0/zitro_0.7.0_darwin_amd64.tar.gz"
      sha256 "8a113d1790c0f3eebf70cad1fb614bc690b46f3086019e89c3ca1c4ae0045580"
    end
  end

  on_linux do
    on_arm do
      url "https://zitro.sh/dl/0.7.0/zitro_0.7.0_linux_arm64.tar.gz"
      sha256 "264e41a31ee38551cf952be6633ed016ce786c99de2142098d87f92d8a0ed7c3"
    end
    on_intel do
      url "https://zitro.sh/dl/0.7.0/zitro_0.7.0_linux_amd64.tar.gz"
      sha256 "73ed92eddcad96ca61d2fa71f250964de6a52a40b9c23724af3b59c9db83336a"
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

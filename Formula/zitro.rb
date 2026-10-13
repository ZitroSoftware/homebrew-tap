# Homebrew formula; all archives remain hosted on zitro.sh.
#   brew install ZitroSoftware/tap/zitro
class Zitro < Formula
  desc "Command line interface for the zitro Cloud API"
  homepage "https://zitro.sh"
  version "0.4.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://zitro.sh/dl/0.4.2/zitro_0.4.2_darwin_arm64.tar.gz"
      sha256 "cee7fde8c5958a7bf82e84a5d24074a27743f2e12d32a181690b276644e87f19"
    end
    on_intel do
      url "https://zitro.sh/dl/0.4.2/zitro_0.4.2_darwin_amd64.tar.gz"
      sha256 "703c99586bc73ebc71e361463c7c371344ef8323fd4ac2fd4cefcbdec29803bb"
    end
  end

  on_linux do
    on_arm do
      url "https://zitro.sh/dl/0.4.2/zitro_0.4.2_linux_arm64.tar.gz"
      sha256 "f60d82ca9f3d8d7bf956df3f8bb0a3b9497dc5fb41ce51760995209c32dfde66"
    end
    on_intel do
      url "https://zitro.sh/dl/0.4.2/zitro_0.4.2_linux_amd64.tar.gz"
      sha256 "c1cc2a794a2d3bd6964daaea9bfbe41309bf2829a70b0aff3245fb31fad31153"
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

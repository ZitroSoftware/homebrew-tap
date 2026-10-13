# Homebrew formula; all archives remain hosted on zitro.sh.
#   brew install ZitroSoftware/tap/zitro
class Zitro < Formula
  desc "Command line interface for the zitro Cloud API"
  homepage "https://zitro.sh"
  version "0.5.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://zitro.sh/dl/0.5.0/zitro_0.5.0_darwin_arm64.tar.gz"
      sha256 "785c5a2e70980eb2cb3ae6fa144dfd03b132f32c55236cb78afe11cd56619fd7"
    end
    on_intel do
      url "https://zitro.sh/dl/0.5.0/zitro_0.5.0_darwin_amd64.tar.gz"
      sha256 "3819e9f336a6f27b78eb2d59507aefca886e15d7c27ac3d9c647205a127af4f8"
    end
  end

  on_linux do
    on_arm do
      url "https://zitro.sh/dl/0.5.0/zitro_0.5.0_linux_arm64.tar.gz"
      sha256 "3eea5625e45514f36fd5060f4a7b6116257df9fda94d65c9884ff3ad8db331f6"
    end
    on_intel do
      url "https://zitro.sh/dl/0.5.0/zitro_0.5.0_linux_amd64.tar.gz"
      sha256 "497ca0f06603d144f555658a10916db0694395473d119d80351caf64e76de741"
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

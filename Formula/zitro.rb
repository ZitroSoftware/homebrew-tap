# Homebrew formula; all archives remain hosted on zitro.sh.
#   brew install ZitroSoftware/tap/zitro
class Zitro < Formula
  desc "Command line interface for the zitro Cloud API"
  homepage "https://zitro.sh"
  version "0.11.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://zitro.sh/dl/0.11.1/zitro_0.11.1_darwin_arm64.tar.gz"
      sha256 "a2dac08387229c5990c0813747e1cf823c3d0f95ba250ba798e2a66ef32690de"
    end
    on_intel do
      url "https://zitro.sh/dl/0.11.1/zitro_0.11.1_darwin_amd64.tar.gz"
      sha256 "dd2288e317802f318f2cf362916c990aba50002ef3991a17ad333d90741baf78"
    end
  end

  on_linux do
    on_arm do
      url "https://zitro.sh/dl/0.11.1/zitro_0.11.1_linux_arm64.tar.gz"
      sha256 "6e99f74d215690c3540a40900c63c4748afc2c42887923f558f2a58fe93f27c7"
    end
    on_intel do
      url "https://zitro.sh/dl/0.11.1/zitro_0.11.1_linux_amd64.tar.gz"
      sha256 "f92e83566da7a702257f0090d36f21d4a1797defa032e916ed28b53c98952d34"
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

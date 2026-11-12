# Homebrew formula; all archives remain hosted on zitro.sh.
#   brew install ZitroSoftware/tap/zitro
class Zitro < Formula
  desc "Command line interface for the zitro Cloud API"
  homepage "https://zitro.sh"
  version "0.12.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://zitro.sh/dl/0.12.1/zitro_0.12.1_darwin_arm64.tar.gz"
      sha256 "cd70f4caabb5be46c9e146a7c60e6b1909d2170f5d2a7b8e39836b54c653a7c1"
    end
    on_intel do
      url "https://zitro.sh/dl/0.12.1/zitro_0.12.1_darwin_amd64.tar.gz"
      sha256 "c1eb95ff18fb667fb48bdb20404046676e43b05fce193af24f4bf1bc8b2a5482"
    end
  end

  on_linux do
    on_arm do
      url "https://zitro.sh/dl/0.12.1/zitro_0.12.1_linux_arm64.tar.gz"
      sha256 "b681974ac8fa97854608a9f375047fe2e7e93c1faea2d8a5293255d08ea59360"
    end
    on_intel do
      url "https://zitro.sh/dl/0.12.1/zitro_0.12.1_linux_amd64.tar.gz"
      sha256 "a4171599f00785da298c8a1f45d0b0fdf69fc6246959f1132d5dd4ad440d8778"
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

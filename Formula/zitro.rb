# Homebrew formula; all archives remain hosted on zitro.sh.
#   brew install ZitroSoftware/tap/zitro
class Zitro < Formula
  desc "Command line interface for the zitro Cloud API"
  homepage "https://zitro.sh"
  version "0.10.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://zitro.sh/dl/0.10.0/zitro_0.10.0_darwin_arm64.tar.gz"
      sha256 "fd7bb41d05b34f5cfc61365203e7c33aed4f3810a424b2e0ed3644b970026c71"
    end
    on_intel do
      url "https://zitro.sh/dl/0.10.0/zitro_0.10.0_darwin_amd64.tar.gz"
      sha256 "cfb73517e14199732e11946c02eb65e5b93648030b4838bbcdb9c978dcf76f8d"
    end
  end

  on_linux do
    on_arm do
      url "https://zitro.sh/dl/0.10.0/zitro_0.10.0_linux_arm64.tar.gz"
      sha256 "2bf4570ff393af0a2aeec1d2a219fd2d44e3d73dca2696ae834b520d4c2b30bd"
    end
    on_intel do
      url "https://zitro.sh/dl/0.10.0/zitro_0.10.0_linux_amd64.tar.gz"
      sha256 "d447f25fc00dbe47423216fa3d2951d388ef91e04dadcd4fce2c9438ed74efc0"
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

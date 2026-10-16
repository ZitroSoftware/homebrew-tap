# Homebrew formula; all archives remain hosted on zitro.sh.
#   brew install ZitroSoftware/tap/zitro
class Zitro < Formula
  desc "Command line interface for the zitro Cloud API"
  homepage "https://zitro.sh"
  version "0.7.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://zitro.sh/dl/0.7.1/zitro_0.7.1_darwin_arm64.tar.gz"
      sha256 "440caa1376a3bc4058fa928950e43a3acfc81cb34139f47a0b20d875c8a01ba6"
    end
    on_intel do
      url "https://zitro.sh/dl/0.7.1/zitro_0.7.1_darwin_amd64.tar.gz"
      sha256 "30f7b21d60fca791143e89d19d6efeb7d5c4d1341d6b07df8ffc8e513046a12a"
    end
  end

  on_linux do
    on_arm do
      url "https://zitro.sh/dl/0.7.1/zitro_0.7.1_linux_arm64.tar.gz"
      sha256 "7361291cce91c8cd3b6c6db20345371a433bc356d986a8df0597be81b9bfafd7"
    end
    on_intel do
      url "https://zitro.sh/dl/0.7.1/zitro_0.7.1_linux_amd64.tar.gz"
      sha256 "e8e4697a5c2f6322d5011615e9a60d33e572c6ae38b4898112ac135d066d5cdf"
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

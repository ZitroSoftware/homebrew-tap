# Homebrew formula; all archives remain hosted on zitro.sh.
#   brew install ZitroSoftware/tap/zitro
class Zitro < Formula
  desc "Command line interface for the zitro Cloud API"
  homepage "https://zitro.sh"
  version "0.11.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://zitro.sh/dl/0.11.2/zitro_0.11.2_darwin_arm64.tar.gz"
      sha256 "22d1cc4cf44077a79e4c806c86526224e93e700922b5a04aaebc18ecad9862db"
    end
    on_intel do
      url "https://zitro.sh/dl/0.11.2/zitro_0.11.2_darwin_amd64.tar.gz"
      sha256 "e35b260e6a6d8468965b73b40b1067f23a4a7821119c7bdd713d806d3ea2d2ee"
    end
  end

  on_linux do
    on_arm do
      url "https://zitro.sh/dl/0.11.2/zitro_0.11.2_linux_arm64.tar.gz"
      sha256 "ee1e636188630fef34de72d18f6555d694c8a0f0deaf944b1529181ab959c59f"
    end
    on_intel do
      url "https://zitro.sh/dl/0.11.2/zitro_0.11.2_linux_amd64.tar.gz"
      sha256 "f1667a64f47b6201ec05f70d7f0f4f4c68ab738ed080859fc5dba2701dc1e20a"
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

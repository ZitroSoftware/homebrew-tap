# Homebrew formula; all archives remain hosted on zitro.sh.
#   brew install ZitroSoftware/tap/zitro
class Zitro < Formula
  desc "Command line interface for the zitro Cloud API"
  homepage "https://zitro.sh"
  version "0.9.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://zitro.sh/dl/0.9.0/zitro_0.9.0_darwin_arm64.tar.gz"
      sha256 "8f76e83bc853ff8d17a151bd05fa23b98db8d18d27da34d7bf6de3c004a06d14"
    end
    on_intel do
      url "https://zitro.sh/dl/0.9.0/zitro_0.9.0_darwin_amd64.tar.gz"
      sha256 "b6b112ab35e267602fdec3489208129ea86a737062206098dc47715225b76e35"
    end
  end

  on_linux do
    on_arm do
      url "https://zitro.sh/dl/0.9.0/zitro_0.9.0_linux_arm64.tar.gz"
      sha256 "05f59e6bce76425369b9d8db9e0869c11480cd351b49159648ddfe77a24392bd"
    end
    on_intel do
      url "https://zitro.sh/dl/0.9.0/zitro_0.9.0_linux_amd64.tar.gz"
      sha256 "2df8ecd724c5ac6b11be0ed8ef1badc417890293704e87d5a536034be8be850f"
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

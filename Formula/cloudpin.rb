class Cloudpin < Formula
  desc "Pin cloud CLI accounts to a repo and block commands on the wrong one"
  homepage "https://github.com/paureis/cloudpin"
  url "https://registry.npmjs.org/cloudpin/-/cloudpin-1.1.0.tgz"
  sha256 "4556f4ad13f9d2f9e8103cd8910edfd16cd8f19296e8cb9a3123583c7587a35a"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  def caveats
    <<~EOS
      Installing cloudpin changed no shell profile and installed no agent hook.
      To guard the commands you type, add this line to ~/.zshrc (or ~/.bashrc, with bash):
        eval "$(cloudpin shell-init zsh)"
      To guard an AI agent's commands (claude, codex, cursor, copilot, antigravity, gemini):
        cloudpin install-hook <agent>
      Then run `cloudpin doctor` to check the whole setup.
    EOS
  end

  test do
    # A section this cloudpin doesn't know is refused, never ignored.
    (testpath/"refused/.cloudpin.yml").write <<~YAML
      nosuchcloud:
        account: x
    YAML
    cd testpath/"refused" do
      output = shell_output("#{bin}/cloudpin check 2>&1", 1)
      assert_match 'unknown section "nosuchcloud"', output
      assert_match "written for a newer cloudpin", output
    end

    # A valid pin passes when its CLI (az) isn't installed: there is nothing to check.
    # PATH holds only node, so an az in /usr/bin (Microsoft's apt package) can't be found.
    (testpath/"accepted/.cloudpin.yml").write <<~YAML
      azure:
        subscription: 00000000-0000-0000-0000-000000000000
    YAML
    cd testpath/"accepted" do
      with_env(PATH: formula_opt_bin("node").to_s) do
        assert_match "az is not installed here", shell_output("#{bin}/cloudpin check")
      end
    end
  end
end

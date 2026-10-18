# paureis/tap

The Homebrew tap for [cloudpin](https://github.com/paureis/cloudpin): pin cloud CLI accounts to a repo, and stop any
command (yours or your AI agent's) that would run on the wrong one.

## Install

On macOS or Linux:

```sh
brew install paureis/tap/cloudpin
```

Upgrade with `brew upgrade cloudpin`. cloudpin runs on Homebrew's own Node.js (the `node` formula), which Homebrew
installs if it isn't there yet, even when another Node.js (nvm, the nodejs.org installer) is on PATH.

## What it installs

The formula installs cloudpin's npm package, `https://registry.npmjs.org/cloudpin/-/cloudpin-X.Y.Z.tgz`, with
Homebrew's standard Node.js recipe. Its `sha256` is the one listed in the `SHA256SUMS` file of the matching
[GitHub Release](https://github.com/paureis/cloudpin/releases), whose tarball is byte for byte the file npm serves and
carries a signed build-provenance attestation. To check it yourself:

```sh
curl -fsSLO https://registry.npmjs.org/cloudpin/-/cloudpin-1.1.0.tgz
gh attestation verify cloudpin-1.1.0.tgz --repo paureis/cloudpin   # built and signed by cloudpin's release workflow
shasum -a 256 cloudpin-1.1.0.tgz                                   # equals the sha256 in Formula/cloudpin.rb
```

Installing changes no shell profile and installs no agent hook. To be protected, run the next steps yourself (see
cloudpin's README):

```sh
echo 'eval "$(cloudpin shell-init zsh)"' >> ~/.zshrc   # guard your terminal (bash: shell-init bash, ~/.bashrc)
cloudpin install-hook claude                           # guard an AI agent (or codex, cursor, copilot, antigravity, gemini)
cloudpin doctor                                        # check the whole setup
```

## How versions are bumped

After each cloudpin release, `scripts/bump-installers.mjs` in [paureis/cloudpin](https://github.com/paureis/cloudpin)
reads that release's `SHA256SUMS` and rewrites the formula's `url` and `sha256`:

```sh
node scripts/bump-installers.mjs X.Y.Z --tap ../homebrew-tap
```

The change is reviewed and pushed by hand. This repository's CI audits the formula, installs it from source, runs
`brew test`, and checks that a wrong `sha256` makes the download fail.

## Problems

Report them in [paureis/cloudpin's issues](https://github.com/paureis/cloudpin/issues).

## License

MIT, as cloudpin.

# betterbird-nix

A Nix flake for [Betterbird](https://www.betterbird.eu/) — a fine-tuned fork of Mozilla Thunderbird — with automated version and hash updates.

## Usage

Add this flake as an input:

```nix
{
  inputs.betterbird-nix.url = "github:TheAnachronism/betterbird-nix";
}
```

Then use the package or overlay:

```nix
# Package
inputs.betterbird-nix.packages.x86_64-linux.betterbird

# Overlay
nixpkgs.overlays = [ inputs.betterbird-nix.overlays.default ];
```

Or build directly:

```sh
nix build github:TheAnachronism/betterbird-nix#betterbird
```

## Auto-updates

A GitHub Actions workflow runs every 6 hours (and on manual dispatch). When a new Betterbird release is available, it:

1. Updates `version` and `hash` in `package.nix`
2. Verifies the build with `nix build`
3. Commits the change and creates a GitHub release

## Platform

Currently supports **x86_64-linux** only. The package wraps the official binary tarball from Betterbird.

## License

MIT

# Reference: https://github.com/colonelpanic8/dotfiles/blob/4e3e75c3e27372f3b7694fc3239bff6013d64ed9/nixos/overlay.nix
{ pkgs, inputs, ... }:
let
  generated = pkgs.callPackage ../_sources/generated.nix { };
in
{
  nixpkgs.overlays = [
    inputs.rust-overlay.overlays.default
    inputs.rustowl.overlays.default
    inputs.nix-cachyos-kernel.overlays.pinned
    (import ./fix-ime.nix)
    # ORDERING: fix-libreoffice-fonts.nix MUST come before noto-fonts-* overlays.
    # Moving it after any of them breaks the font-pinning logic and causes
    # LibreOffice to rebuild locally instead of being fetched from cache.nixos.org.
    (import ./wifiman-desktop.nix)
    (import ./siketyan-ghr.nix inputs)
    #    (import ./webapp.nix)
  ];
}

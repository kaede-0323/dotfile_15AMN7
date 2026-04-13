# Reference: https://github.com/colonelpanic8/dotfiles/blob/4e3e75c3e27372f3b7694fc3239bff6013d64ed9/nixos/overlay.nix
{ ... }:
{
  nixpkgs.overlays = [
    (import ./fix-ime.nix)
    # ORDERING: fix-libreoffice-fonts.nix MUST come before noto-fonts-* overlays.
    # Moving it after any of them breaks the font-pinning logic and causes
    # LibreOffice to rebuild locally instead of being fetched from cache.nixos.org.
    (import ./wifiman-desktop.nix)
    #    (import ./webapp.nix)
  ];
}

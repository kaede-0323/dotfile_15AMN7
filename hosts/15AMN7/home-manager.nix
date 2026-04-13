{ lib, ... }:
{
  imports = [
    ./home-manager-minimal.nix
  ]
  ++ lib.optionals false [
    # Optional UX and app bundles (enable by flipping `false` to `true` or
    # moving selected modules into a host-specific profile file).
    ./../../home-manager/cli/shared
    ./../../home-manager/cli/dev
    ./../../home-manager/gui/shared
    ./../../home-manager/gui/dev
    ./../../home-manager/gui/dev/creative.nix
    ./../../home-manager/gui/game
    ./../../home-manager/gui/term/alacritty.nix
  ];
}

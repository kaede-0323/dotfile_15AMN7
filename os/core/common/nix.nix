{ inputs, pkgs, ...}:
{
  nix = {
    settings = {
      download-buffer-size = 524288000; # 500 * 1024 * 1024B
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
	"@wheel"
      ];
      accept-flake-config = true;
      substituters = [
        "https://aseipp-nix-cache.freetls.fastly.net"
	"https://cache.nixos.org"
	"https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdDD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
	"nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs.config.allowUnfree = true;
}

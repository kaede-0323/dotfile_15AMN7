{
  inputs,
  pkgs,
  hostname,
  config,
  pkgs-staging-next,
  ...
}:
{
  imports = [
    ../../os/core/shell.nix
    ./hardware-configuration.nix
  ];
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
      };
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
  };

  networking.networkmanager = {
    enable = true;
  };

  services.xserver = {
    enable = true;
    displayManager.startx.enable = true;
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
	"flakes"
      ];
    };
  };
}


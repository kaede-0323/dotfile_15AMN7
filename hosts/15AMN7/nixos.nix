{
  inputs,
  pkgs,
  hostname,
  config,
  ...
}:
{
  imports = [
    ../../os/core/shell.nix
    ./hardware-configuration.nix
  ];
  boot = {
    supportedFilesystems = [ "btrfs" ];
    loader = {
      systemd-boot = {
        enable = true;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  networking.networkmanager = {
    enable = true;
  };

  services.xserver = {
    enable = true;
    displayManager.startx.enable = true;
  };



  i18n.defaultLocale = "en_US.UTF-8";

  services.libinput.enable = true;

  fonts.packages = with pkgs; [
    iosevka
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
  ];

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
	"flakes"
      ];
    };
  };
}


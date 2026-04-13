{ pkgs, lib, ... }:
{
  imports = [
    ./../../home-manager/cli/shared
    ./../../home-manager/cli/dev
    (import ./../../home-manager/cli/git.nix {
      userName = "kaede-0323";
      userEmail = "ocho.study@gmail.com";
    })
    ./../../home-manager/cli/shell/zsh
    ./../../home-manager/gui/shared
    ./../../home-manager/gui/dev
    ./../../home-manager/gui/dev/creative.nix
    ./../../home-manager/gui/game
    ./../../home-manager/gui/term/alacritty.nix
  ];

  home.packages = with pkgs; [
    xorg.xinit
  ];

  xsession = {
    enable = true;
    windowManager.xmonad.enable = false;
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3;

      config = {
        modifier = "Mod4";
	terminal = "GTK_IM_MODULE=xim QT_IM_MODULE=xim XMODIFIERS=@im=none alacritty";
	menu = "rofi -show drun";

	workspaceLayout = "tabbed";

	gaps = {
	  inner = 1;
	  outer = 2;
	};

	fonts = {
	  names = [ "Iosevka" ];
	  size = 10.0;
	};

	window = {
	  border = 1;
	  titlebar = true;
	};
      	keybindings = lib.mkOptionDefault {
      	  "Mod4+Return" = "exec GTK_IM_MODULE=xim QT_IM_MODULE=xim XMODIFIERS=@im=none alacritty";
      	  "Mod4+q" = "kill";
      	  "Mod4+d" = "rofi -show drun";
      	};
      };
    };
  };

  wayland.windowManager.hyprland.enable = false;
}

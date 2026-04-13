{ pkgs, lib, ... }:
{
  imports = [
    (import ./../../home-manager/cli/git.nix {
      userName = "kaede-0323";
      userEmail = "ocho.study@gmail.com";
    })
    ./../../home-manager/cli/shell/zsh
  ];

  # Minimal i3 stack for 15AMN7.
  home.packages = with pkgs; [
    xorg.xinit
    alacritty
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

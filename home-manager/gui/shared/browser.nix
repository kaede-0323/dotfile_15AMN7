{
  system,
  inputs,
  pkgs,
  hostPlatform,
  ...
}:
let
  isLinux = hostPlatform.isLinux;
in
{
  programs = {
    librewolf = {
      enable = isLinux;
      package = pkgs.librewolf;
    };
  };
  home.packages = pkgs.lib.optionals isLinux [
    pkgs.librewolf
  ];
  xdg.mimeApps.defaultApplications =
    let
      defaultBrowser = [ "librewolf.desktop" ];
    in
    {
      "x-scheme-handler/http" = defaultBrowser;
      "x-scheme-handler/https" = defaultBrowser;
      "x-scheme-handler/about" = defaultBrowser;
      "x-scheme-handler/unknown" = defaultBrowser;
    };
}

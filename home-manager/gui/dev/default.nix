{ pkgs, hostPlatform, ... }:
{
  home.packages =
    with pkgs;
    [
      hoppscotch # WebAPI dev	tool
      gitify
      drawio
    ];
}

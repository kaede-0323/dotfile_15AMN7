{ pkgs, hostPlatform, ... }:
{
  imports = [
    ./ai.nix
    ./local-llm.nix
    ./idea
  ];

  home.packages = with pkgs; [
    hoppscotch # WebAPI dev	tool
    gitify
    drawio
  ];
}

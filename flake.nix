{
  nixConfig = {
    extra-substituters = [ ];
    extra-trusted-public-keys = [ ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utils.url = "github:numtide/flake-utils";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = inputs@{
    nixpkgs,
    flake-utils,
    treefmt-nix,
    ...
  }: {
    nixosConfigurations = (import ./hosts inputs).nixos;
    homeConfigurations = (import ./hosts inputs).home-manager;
  }
  // flake-utils.lib.eachDefaultSystem (
    system:
    let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    with pkgs;
    {
      formatter = treefmt-nix.lib.mkWrapper pkgs {
        projectRootFile = "flake.nix";
        programs = {
          nixfmt.enable = true;
          mdformat.enable = true;
        };
        settings = {
          global.excludes = [
            ".direnv/"
          ];
        };
      };

      devShells.default = mkShell {
        packages = [
          nvfetcher
          home-manager
          pinact
          zizmor
          nh
          gh
          (writeScriptBin "switch-home" ''
            nh home switch . -c"$@"
          '')
          (writeScriptBin "switch-nixos" ''
            ulimit -n 4096 && nh os switch . -H "$@"
          '')
          (writeScriptBin "update-flake" ''
            NIX_CONFIG="access-tokens = github.com=$(gh auth token)" nix flake update "$@"
          '')
        ];
      };
    }
  );
}

{
  nixConfig = {
    extra-substituters = [
      "https://hyprland.cachix.org"
      "https://ags.cachix.org"
      "https://niri.cachix.org"
      # ghr cache
      "https://siketyan.cachix.org"
      # Cachy OS kernel
      "https://attic.xuyh0120.win/lantian"
      # llm-agents cache
      "https://cache.numtide.com"
    ];
    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "ags.cachix.org-1:naAvMrz0CuYqeyGNyLgE010iUiuf/qx6kYrUv3NwAJ8="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      "siketyan.cachix.org-1:WNNtRH3yo7wUpQ0aURUTCq2BpF97m4UsP0h1nKe6pAA="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-staging-next.url = "github:NixOS/nixpkgs/staging-next";
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
    direnv-instant = {
      url = "github:Mic92/direnv-instant";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rustowl = {
      url = "github:nix-community/rustowl-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
      };
    };
    siketyan-ghr = {
      url = "github:siketyan/ghr";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
        rust-overlay.follows = "rust-overlay";
        flake-utils.follows = "utils";
      };
    };
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
  };
  outputs = inputs@{
    nixpkgs,
    flake-utils,
    treefmt-nix,
    rustowl,
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
      overlayFile = if pkgs.stdenv.isLinux then ./overlay/d-linux.nix else null;
      overlays = pkgs.lib.attrsets.mergeAttrsList (
        map (overlay: overlay pkgs pkgs) (import overlayFile { inherit pkgs inputs;}).nixpkgs.overlays
      );
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

{
  description = "A collection of Vim/Neovim plugins I use, as a Nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    awesome-neovim-plugins = {
      url = "github:m15a/flake-awesome-neovim-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      awesome-neovim-plugins,
      treefmt-nix,
      ...
    }:
    let
      inherit (flake-utils.lib) eachDefaultSystem filterPackages;
    in
    {
      overlays.default = import ./nix/overlay.nix;
    }
    // eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            awesome-neovim-plugins.overlays.default
            self.overlays.default
            (import ./nix/dev-shells.nix)
          ];
        };
        treefmt = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
      in
      rec {
        packages = filterPackages system pkgs.vimPluginsPersonalSelection;
        formatter = treefmt.config.build.wrapper;
        checks = packages // {
          format = treefmt.config.build.check self;
        };
        inherit (pkgs) devShells;
      }
    );
}

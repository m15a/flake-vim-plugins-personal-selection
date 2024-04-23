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
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      awesome-neovim-plugins,
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
            (import ./nix/ci.nix)
          ];
        };
      in
      rec {
        packages = filterPackages system pkgs.vimPluginAnalects;
        checks = packages // pkgs.checks;
        inherit (pkgs) devShells;
      }
    );
}

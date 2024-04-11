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
    {
      overlays = rec {
        vim-plugin-analects = import ./nix/overlay.nix;
        default = vim-plugin-analects;
      };
    }
    // flake-utils.lib.eachDefaultSystem (
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
        packages = flake-utils.lib.filterPackages system pkgs.vimPluginAnalects;

        checks = packages;

        devShells = {
          inherit (pkgs) ci-update ci-check-format;
          default = pkgs.mkShell {
            inputsFrom = [
              pkgs.ci-update
              pkgs.ci-check-format
            ];
            packages = [ pkgs.fennel-ls ] ++ (with pkgs.luajit.pkgs; [ readline ]);
          };
        };
      }
    );
}

final: prev:

let
  inherit (prev) lib;
in
lib.composeManyExtensions [
  (import ./vim-plugins-personal-selection.nix)
  (import ./overrides.nix)
] final prev

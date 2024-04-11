final: prev:

let
  inherit (prev) lib;
in
lib.composeManyExtensions [
  (import ./vim-plugin-analects.nix)
  (import ./overrides.nix)
] final prev

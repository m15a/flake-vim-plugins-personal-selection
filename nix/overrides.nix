final: prev:

let
  inherit (final) lib awesomeNeovimPlugins;

  dependencies =
    self: super:
    lib.mapAttrs (
      attrName: dependencies:
      super.${attrName}.overrideAttrs (_: {
        inherit dependencies;
      })
    ) { telescope-bibtex-nvim = [ awesomeNeovimPlugins.telescope-nvim ]; };

  andMore = self: super: { };
in
{
  vimPluginAnalects = prev.vimPluginAnalects.extend (
    lib.composeManyExtensions [
      dependencies
      andMore
    ]
  );
}

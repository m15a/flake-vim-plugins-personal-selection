final: prev:

let
  inherit (final) lib;

  dependencies =
    self: super:
    lib.mapAttrs
      (
        attrName: dependencies:
        super.${attrName}.overrideAttrs (_: {
          inherit dependencies;
        })
      )
      {
      };

  andMore = self: super: { };
in
{
  vimPluginsPersonalSelection = prev.vimPluginsPersonalSelection.extend (
    lib.composeManyExtensions [
      dependencies
      andMore
    ]
  );
}

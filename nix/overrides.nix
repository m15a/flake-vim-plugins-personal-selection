final: prev:

let
  # inherit (final) lib;

  overrides = self: super: { };
in
{
  vimPluginAnalects = prev.vimPluginAnalects.extend overrides;
}

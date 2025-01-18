final: prev:

let
  inherit (prev) lib;
  utils = prev.callPackage ./utils.nix { };

  builder =
    pluginInfo:
    let
      inherit (pluginInfo)
        date
        repo
        rev
        sha256
        url
        ;
      pname = utils.repoNameToPName repo;
    in
    {
      name = pname;
      value = final.vimUtils.buildVimPlugin {
        inherit pname;
        version = "${date}-${lib.strings.substring 0 7 rev}";
        src = final.fetchurl { inherit url sha256; };
        meta =
          lib.optionalAttrs (pluginInfo ? "description") {
            inherit (pluginInfo) description;
          }
          // lib.optionalAttrs (pluginInfo ? "homepage") {
            inherit (pluginInfo) homepage;
          }
          // lib.optionalAttrs (pluginInfo ? "license") {
            license = lib.getLicenseFromSpdxId pluginInfo.license;
          };
      };
    };

  pluginsInfo = lib.strings.fromJSON (
    lib.readFile ../data/plugins/personal-selection.json
  );

  origin = builtins.listToAttrs (
    map builder (lib.filter utils.isValidPluginInfo pluginsInfo)
  );
in
{
  vimPluginsPersonalSelection = lib.makeExtensible (
    _: lib.recurseIntoAttrs origin
  );
}

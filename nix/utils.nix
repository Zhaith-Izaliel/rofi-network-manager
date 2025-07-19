{lib}:
/*
  Most of these Rofi utils come from:
* https://github.com/nix-community/home-manager/blob/master/modules/programs/rofi.nix
*/
let
  inherit
    (lib)
    isBool
    isInt
    isString
    isList
    isAttrs
    generators
    filterAttrs
    concatStringsSep
    concatMap
    types
    mapAttrsToList
    mkOption
    toUpper
    isPath
    ;
in rec {
  mkValueString = value:
    if isBool value
    then
      if value
      then "true"
      else "false"
    else if isInt value
    then toString value
    else if (value._type or "") == "literal"
    then value.value
    else if isString value
    then ''"${value}"''
    else if isList value
    then "[ ${concatStringsSep "," (map mkValueString value)} ]"
    else abort "Unhandled value type ${builtins.typeOf value}";

  mkKeyValue = {
    sep ? ": ",
    end ? ";",
  }: name: value: "${name}${sep}${mkValueString value}${end}";

  mkRasiSection = name: value:
    if isAttrs value
    then let
      toRasiKeyValue = generators.toKeyValue {mkKeyValue = mkKeyValue {};};
      # Remove null values so the resulting config does not have empty lines
      configStr = toRasiKeyValue (filterAttrs (_: v: v != null) value);
    in ''
      ${name} {
      ${configStr}}
    ''
    else
      (mkKeyValue {
          sep = " ";
          end = "";
        }
        name
        value)
      + "\n";

  toRasi = attrs:
    concatStringsSep "\n" (concatMap (mapAttrsToList mkRasiSection) [
      (filterAttrs (n: _: n == "@theme") attrs)
      (filterAttrs (n: _: n == "@import") attrs)
      (removeAttrs attrs ["@theme" "@import"])
    ]);

  # Either a `section { foo: "bar"; }` or a `@import/@theme "some-text"`
  configType = with types; (
    either (
      attrsOf (
        either primitive (listOf primitive)
      )
    )
    str
  );

  primitive = with types; (oneOf [str int bool rasiLiteral]);

  themeType = with types; nullOr (attrsOf configType);

  rasiLiteral =
    types.submodule {
      options = {
        _type = mkOption {
          type = types.enum ["literal"];
          internal = true;
        };

        value = mkOption {
          type = types.str;
          internal = true;
        };
      };
    }
    // {
      description = "Rasi literal string";
    };

  toConf = config:
    concatStringsSep "\n" (
      mapAttrsToList
      (
        name: value: let
          valueToWrite =
            if isBool value
            then
              if value
              then "true"
              else "false"
            else if isInt value
            then toString value
            else if (isString value || isPath value)
            then ''"${value}"''
            else if isAttrs value
            then
              "("
              + concatStringsSep " " (mapAttrsToList (name: item: ''["${name}"]="${toString item}"'') value)
              + ")"
            else if isList value
            then
              "("
              + concatStringsSep " " (builtins.map (item: ''"${item}"'') value)
              + ")"
            else abort "Unhandled value type ${builtins.typeOf value}";
        in ''${toUpper name}=${valueToWrite}''
      )
      config
    );
}

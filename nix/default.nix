{
  stdenvNoCC,
  version ? "git",
  src,
  rofi,
  rofi-wayland,
  makeWrapper,
  libnotify,
  qrencode,
  networkmanager,
  networkmanagerapplet,
  bash,
  lib,
  useWayland ? true,
}: let
  paths =
    [
      libnotify
      qrencode
      networkmanagerapplet
      networkmanager
    ]
    ++ (
      if useWayland
      then [rofi-wayland]
      else [rofi]
    );
  wrapperPath = lib.makeBinPath paths;
in
  stdenvNoCC.mkDerivation rec {
    pname = "ronema";

    inherit version src useWayland;

    buildInputs = [
      bash
    ];

    installPhase = ''
      mkdir -p $out
      mkdir -p $out/bin
      cp -r -t $out src/themes src/languages src/icons src/ronema.conf
      cp src/ronema $out/bin
    '';

    nativeBuildInputs = [
      makeWrapper
    ];

    postFixup = ''
      # Ensure all dependencies are in PATH
        wrapProgram $out/bin/${pname} \
          --prefix PATH : "${wrapperPath}"
    '';

    dontUseCmakeBuild = true;
    dontUseCmakeConfigure = true;

    meta.mainProgram = pname;
  }

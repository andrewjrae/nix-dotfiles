{
  lib,
  stdenvNoCC,
  fetchurl,
}:

let
  version = "0.2.0";
  release = {
    aarch64-darwin = {
      arch = "arm64";
      hash = "sha256-C0jY80n2tzhJ4zj+jfpdwUB39Yuu6Y4B4qp4TWchs0A=";
    };
    x86_64-darwin = {
      arch = "x86_64";
      hash = "sha256-I1ROsPIz9jckCzlJ/9SSKSkZUuoV6gD0jr0q8f/ASH8=";
    };
  }.${stdenvNoCC.hostPlatform.system};
in
stdenvNoCC.mkDerivation {
  pname = "skhd-zig";
  inherit version;

  src = fetchurl {
    url = "https://github.com/jackielii/skhd.zig/releases/download/v${version}/skhd-${release.arch}-macos.tar.gz";
    inherit (release) hash;
  };

  sourceRoot = ".";
  dontBuild = true;
  dontConfigure = true;

  # Preserve upstream's signed app bundle. In particular, stripping or
  # otherwise rewriting its Mach-O binaries would invalidate the signature
  # used by macOS Accessibility/Input Monitoring permissions.
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications" "$out/bin"
    cp -R skhd.app "$out/Applications/skhd.app"
    ln -s ../Applications/skhd.app/Contents/MacOS/skhd "$out/bin/skhd"

    runHook postInstall
  '';

  meta = {
    description = "Simple hotkey daemon for macOS, ported to Zig";
    homepage = "https://github.com/jackielii/skhd.zig";
    changelog = "https://github.com/jackielii/skhd.zig/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "skhd";
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}

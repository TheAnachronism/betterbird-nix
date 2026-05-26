{
  lib,
  stdenvNoCC,
  autoPatchelfHook,
  copyDesktopItems,
  fetchurl,
  makeDesktopItem,
  patchelfUnstable,
  wrapGAppsHook3,
  alsa-lib,
  }:
  let
    sourceInfo = builtins.fromJSON (builtins.readFile ./sources.json);

    desktopItem = makeDesktopItem {
      name = "betterbird";
      desktopName = "Betterbird";
      genericName = "Mail Client";
      comment = "Fine-tuned version of Mozilla Thunderbird (binary build)";
      exec = "betterbird %u";
      terminal = false;
      icon = "betterbird";
      categories = [ "Network" "Email" "Office" ];
      keywords = [ "email" "mail" "news" "feed" "rss" "calendar" ];
      mimeTypes = [
        "message/rfc822"
        "x-scheme-handler/mailto"
        "application/x-xpinstall"
      ];
      startupWMClass = "Betterbird";
      startupNotify = true;
      extraConfig = {
        "X-GNOME-UsesNotifications" = "true";
      };
    };
  in
  stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "betterbird";
    version = sourceInfo.version;

    src = fetchurl {
      url = "https://www.betterbird.eu/downloads/LinuxArchive/betterbird-${finalAttrs.version}.en-US.linux-x86_64.tar.xz";
      hash = sourceInfo.hash;
    };

    nativeBuildInputs = [
      autoPatchelfHook
      copyDesktopItems
      patchelfUnstable
      wrapGAppsHook3
    ];

    desktopItems = [ desktopItem ];

    buildInputs = [
      alsa-lib
    ];

    patchelfFlags  = [ "--no-clobber-old-sections" ];

    strictDeps = true;

    postPatch = ''
      echo 'pref("app.update.auto", "false");' >> defaults/pref/challen-prefs.js
    '';

    installPhase = ''
      runHook preInstall

      appdir="$out/usr/lib/bnetterbird-bin/${finalAttrs.version}"

      mkdir -p "$appdir"
      cp -r ./* "$appdir"

      mkdir -p "$out/bin"
      ln -s "$appdir/betterbird" "$out/bin/betterbird"

      # wrapThunderbird expects "$out/lib" instead of "$out/usr/lib"
      ln -s "$out/usr/lib" "$out/lib"

      icon_src_dir="$appdir/chrome/icons/default"
      if [ -d "$icon_src_dir" ]; then
        for size in 16 22 24 32 48 64 128 256; do
          icon_src="$icon_src_dir/default''${size}.png"
          if [ -f "$icon_src" ]; then
            icon_dest_dir="$out/share/icons/hicolor/''${size}x''${size}/apps"
            mkdir -p "$icon_dest_dir"
            ln -s "$icon_src" "$icon_dest_dir/betterbird.png"
          fi
        done
        # Optional: SVG, if desktop environment prefers it
        if [ -f "$icon_src_dir/default.svg" ]; then
          icon_dest_dir="$out/share/icons/hicolor/scalable/apps"
          mkdir -p "$icon_dest_dir"
          ln -s "$icon_src_dir/default.svg" "$icon_dest_dir/betterbird.svg"
        fi
      fi

      runHook postInstall
    '';

    meta = with lib; {
      changelog = "https://www.betterbird.eu/releasenotes/";
      description = "Betterbird binary build – fine-tuned version of Mozilla Thunderbird";
      homepage = "https://www.betterbird.eu/";
      mainProgram = "betterbird";
      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      license = licenses.mpl20;
      platforms = [ "x86_64-linux" ];
    };
  })
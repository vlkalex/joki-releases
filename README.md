<p align="center"><img src="docs/icon.png" width="128" alt="JOKI icon"></p>

# JOKI

Movies and series: browse the TMDb catalogue, find a stream on WebShare, and play it, with MKV,
Dolby/DTS audio, HDR and Dolby Vision. Syncs what you watch with [Trakt](https://app.trakt.tv).

Named after Joy and Loki, two cats. The icon is them on movie night: Loki, the silver tabby, on the left
and Joy, the calico, on the right.

This repository holds the releases. JOKI for Mac releases are tagged `macos-v…`.

## Install on a Mac

You need **macOS 14 Sonoma or newer** (Apple Silicon or Intel).

Open **Terminal** (press ⌘ Space, type `Terminal`, press Return), paste this line and press Return:

```sh
curl -fsSL https://raw.githubusercontent.com/vlkalex/joki-releases/main/install.sh | bash
```

That's it. It downloads the newest JOKI, puts it in your Applications folder and opens it.
JOKI checks for updates when it starts and offers to install them; you can also click
**Settings → About → Check for Updates**. (Running the install line again also updates.)

When JOKI opens, sign in with your WebShare account (or choose "Skip for Now" and sign in later in Settings).

<details>
<summary>Install by hand instead</summary>

1. Download **JOKI.dmg** from the newest **JOKI for Mac** release on the [releases page](https://github.com/vlkalex/joki-releases/releases).
2. Open it and drag **JOKI** onto **Applications**.
3. Open JOKI. macOS says it "cannot be opened" because the app is not notarized by Apple. Click **Done**, then
   open **System Settings → Privacy & Security**, scroll down and click **Open Anyway** next to JOKI.
   You only have to do this once.
</details>

<details>
<summary>Uninstall</summary>

Drag **JOKI** from Applications to the Trash. To also remove your settings, favorites and watch history,
delete the folder `~/Library/Application Support/JOKI`.
</details>

Every release is signed: JOKI installs an update only when it carries the release signature, and the
installer checks each download against its published checksum.

Video playback by [mpv](https://mpv.io) and [FFmpeg](https://ffmpeg.org) (LGPL-2.1+). Metadata by
[TMDb](https://www.themoviedb.org); this product uses the TMDB API but is not endorsed or certified by TMDB.

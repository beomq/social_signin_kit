# Landing asset handoff

The package and the landing chooser have different asset responsibilities.

## App logo assets

The published package ships UI code without provider logos. Use an app-owned
asset path for `SocialButton`, or an app-owned widget for
`SocialButton.custom`. The chooser previews PNGs from the repository and
exports paths for the consuming app to register in its own asset bundle.

## Chooser previews and exports

The web chooser reads `landing/logo-catalog.json`. It shows the local PNG path
from `asset.preview` for each of all 35 providers and exports canonical source
metadata for the selected providers. The catalog, not the chooser script, is
the source of truth for asset provenance.

Each catalog entry has this shape:

```json
{
  "id": "providerEnumName",
  "name": "Provider",
  "background": "#000000",
  "foreground": "#ffffff",
  "rendering": {
    "logoSize": 24,
    "logoAspectRatio": 2
  },
  "label": {
    "en": "Continue with Provider",
    "ko": "Provider 로그인"
  },
  "capabilities": {
    "appearances": ["providerDefault", "light", "dark"],
    "shapes": {
      "rounded": "supported",
      "pill": "unverified",
      "circle": "restricted"
    },
    "shapeReasons": {
      "rounded": {"en": "Source-backed reason", "ko": "공식 근거"},
      "pill": {"en": "Unverified reason", "ko": "미확인 근거"},
      "circle": {"en": "Restricted reason", "ko": "제한 근거"}
    },
    "sources": ["https://first-party.example/guidance"]
  },
  "appearances": {
    "light": {
      "background": "#FFFFFF",
      "foreground": "#000000",
      "border": "#DDDDDD"
    },
    "dark": {
      "background": "#000000",
      "foreground": "#FFFFFF"
    }
  },
  "asset": {
    "preview": "../assets/social/providerEnumName.png",
    "download": "https://canonical-download.example/source.svg",
    "format": "svg",
    "sha256": "selected-source-or-member-sha256",
    "source": "https://source-page.example/",
    "license": "recorded license or usage terms",
    "official": true,
    "conditions": {
      "identificationUse": "plain factual scope",
      "transformation": "plain factual conversion or preservation record",
      "redistribution": "plain factual source-specific condition or unknown",
      "sources": ["https://first-party.example/guidance"],
      "checkedOn": "2026-09-30"
    },
    "archiveMember": "optional/path/inside/archive.png",
    "archiveSha256": "downloaded-archive-sha256",
    "rasterization": {
      "color": "#ffffff",
      "width": 128,
      "height": 128
    }
  }
}
```

`capabilities` is required for all 35 providers. Shape values are exactly
`supported`, `restricted`, or `unverified`; missing public guidance is
`unverified`, never an inferred prohibition. `shapeReasons` contains both
English and Korean text for every shape. `appearances` is optional and contains
only source-backed, implemented light/dark variants. If an appearance carries
an `asset`, that value is the complete asset manifest shape shown above rather
than a shortened path.

For a selected non-default appearance, the chooser exports that appearance's
complete asset and verification metadata. The
consuming-app save path remains the stable `assets/social/<id>.png`, so the
generated Dart's explicit `logo` path loads the selected bytes without an
appearance suffix. Apple light, for example, downloads and verifies the
official `color=white` response, saves those bytes to
`assets/social/apple.png` in the consuming app, and generates
`logo: 'assets/social/apple.png'`.

`archiveMember`, `archiveSha256`, and `rasterization` are optional.
`rendering.logoSize` is optional and defaults to 24 logical pixels in a
48-logical-pixel button. It records the package canvas footprint, including
provider-supplied internal padding; it never instructs an agent to crop,
rescale, or repad the source file.
`rendering.logoAspectRatio` defaults to 1 and records the original width
divided by its height. The generated Dart passes a non-default ratio for
rounded and pill buttons. Circle buttons use a square slot.
`conditions` is required for every provider. `asset.official` records that the
selected file came from the provider; it does not mean the provider approved
this package, its shared button, or package redistribution. Identification
use, transformation, and redistribution are recorded separately, and a missing
permission statement is not rewritten as a prohibition.
For ZIP rows, `archiveSha256` verifies the downloaded ZIP while `sha256`
verifies the extracted `archiveMember`. A direct `download` may point to
PNG, SVG, or ZIP. Relative URLs resolve against the landing document's
`baseURI`. The manifest marks localhost and `127.0.0.1` URLs as
same-machine-only.

Manifest schema version 2 uses `logo.downloadMethod` to distinguish two
acquisition routes. With `direct`, `logo.downloadUrl` identifies the file
and `downloadSha256` must match its bytes. With `source-page`, both
`logo.catalogDownload` and `logo.downloadUrl` are null. Open
`logo.sourcePage` to get a fresh pack. The manifest keeps the recorded
archive and member hashes. If the official pack has been repackaged, report
the changed archive hash and verify the selected member. If the pack or
member is missing, or the member hash differs, request an app-approved asset.

The generated handoff tells the receiving agent to:

1. obtain the selected appearance's source using its acquisition route;
2. check the exported file or archive hash as described above;
3. extract only `archive.member` when present and verify the exported
   `archive.memberSha256` against the extracted member;
4. rasterize SVG sources only, using explicit `rasterization` metadata and
   conversion tools already available in the development environment; apply
   `color` only when present and preserve source colors when
   `preserveColors: true`;
5. preserve direct PNG files and extracted PNG members byte-for-byte, including
   their original dimensions, transparency, and padding, without rescaling or
   placing them on a new 128px canvas;
6. save or copy the consuming-app PNG to the exact generated path; and
7. register that exact PNG path in the consuming app's `pubspec.yaml`.

The default flow does not add `flutter_svg` or another runtime SVG dependency.
The generated Dart passes explicit consuming-app logo paths, and the manifest
exports each provider's rendering footprint as `rendering.logoSize`.

The chooser does not download assets or execute a remote agent. It produces
reviewable text and JSON instructions for a separate implementation step.

# Landing asset handoff

Prepared: 2026-09-29

The package and the landing chooser have different asset responsibilities.

## Package defaults

The package has default PNGs for all 35 providers. Eleven use reviewed
provider-supplied originals:

| Provider | Runtime package path |
| --- | --- |
| Google | `assets/social/google.png` |
| Apple | `assets/social/apple.png` |
| Microsoft | `assets/social/microsoft.png` |
| Kakao | `assets/social/kakao.png` |
| Naver | `assets/social/naver.png` |
| LINE | `assets/social/line.png` |
| X | `assets/social/x.png` |
| LinkedIn | `assets/social/linkedin.png` |
| Twitch | `assets/social/twitch.png` |
| Spotify | `assets/social/spotify.png` |
| Bitbucket | `assets/social/bitbucket.png` |

The other 24 defaults are transparent 128×128 package PNGs rendered from
pinned Simple Icons SVGs with the catalog `foreground` color. They are not
provider-supplied originals or official login controls.

When an app omits `logo`, `SocialButton` loads the matching
`assets/social/<id>.png` with `package: 'social_signin_kit'`. The app does
not copy or register these package defaults.

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
    "logoSize": 24
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
complete `asset` object as the canonical download and hash source. The
consuming-app save path remains the stable `assets/social/<id>.png`, so the
generated Dart's explicit `logo` path loads the selected bytes without an
appearance suffix. Apple light, for example, downloads and verifies the
official `color=white` response, saves those bytes to
`assets/social/apple.png` in the consuming app, and generates
`logo: 'assets/social/apple.png'`. This handoff path is separate from this
package's runtime variant path, `assets/social/apple-light.png`.

`archiveMember`, `archiveSha256`, and `rasterization` are optional.
`rendering.logoSize` is optional and defaults to 24 logical pixels in a
48-logical-pixel button. It records the package canvas footprint, including
provider-supplied internal padding; it never instructs an agent to crop,
rescale, or repad the source file.
`conditions` is required for every provider. `asset.official` records that the
selected file came from the provider; it does not mean the provider approved
this package, its shared button, or package redistribution. Identification
use, transformation, and redistribution are recorded separately, and a missing
permission statement is not rewritten as a prohibition.
For ZIP rows, `archiveSha256` verifies the downloaded ZIP while `sha256`
verifies the extracted `archiveMember`. `download` may point to PNG, SVG,
or ZIP; consumers must not assume PNG. Relative download values are resolved
against the landing document's `baseURI`. A localhost or `127.0.0.1` export is
marked as same-machine-only. The generated handoff tells the receiving agent
to:

1. download the canonical source;
2. verify the exported `downloadSha256` against the downloaded file;
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
The generated Dart always passes explicit consuming-app logo paths, so the
handoff remains self-contained even though all 35 providers already have
package defaults. `SocialButton` applies the same provider rendering footprint
to explicit paths, and the exported manifest repeats `rendering.logoSize`.
Eleven defaults originate from providers; that provenance does not imply
approval or redistribution permission.

The chooser does not download assets or execute a remote agent. It produces
reviewable text and JSON instructions for a separate implementation step.

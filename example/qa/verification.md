# Example verification

Date: 2026-09-29

## Automated

Run from `/Users/beomseok/Desktop/social_login_buttons/example` after the core
API and palettes reached their final state.

| Command | Exit | Result |
| --- | ---: | --- |
| `fvm flutter test` | 0 | 6 tests passed |
| `fvm flutter analyze` | 0 | No issues found |
| `fvm flutter build web` | 0 | Built `build/web` |

## Browser QA

Browser: installed Google Chrome, owned temporary profile, device scale factor
1. The final production `build/web` output was served locally.

### Desktop — 1440 x 900

1. Waited for all five package PNG requests and the Flutter raster frame.
2. Confirmed Google renders in the selected live preview.
3. Clicked the selected Google button and observed `1 / google`, proving the
   package invokes the app callback without performing authentication.
4. Scrolled with real wheel input and inspected the catalog rows.
5. Confirmed Kakao, Naver, Google, Apple, and LINE render their actual package
   PNGs with the adjacent `공식 제공 패키지 로고` status.
6. Confirmed unresolved providers, including Notion, show the crossed-image
   status icon and `번들 로고 없음` rather than a generic brand substitute.

Artifacts:

- `bundled-logos-desktop-1440x900.png`
- `bundled-google-callback-1440x900.png`
- `bundled-logos-catalog-common-1440x900.png`
- `bundled-logos-catalog-line-1440x900.png`
- `bundled-logos-catalog-bottom-1440x900.png`

### Mobile — 390 x 844

1. Loaded the same production build with the iPhone 14 390 x 844 device preset.
2. Confirmed the selected Google package logo renders after raster completion.
3. Confirmed controls and the stage remain readable at the compact breakpoint.

Artifacts:

- `bundled-logos-mobile-390x844.png`
- `bundled-logos-mobile-stage-390x844.png`

## Raster asset provenance

The current gallery uses package defaults only. Google, Apple, Kakao, Naver,
and LINE files, source archive members, and SHA-256 values are recorded in
`../../assets/README.md`. Other providers display the package's explicit
unbundled marker; the old example-only geometric fixtures are no longer
declared or rendered.

## Limitations

- Bundled provider logos do not make the package's common geometry an official
  provider button or demonstrate full brand compliance.
- A missing asset throws the package's diagnostic error. The normal gallery
  does not render a deliberately missing path, so that error surface cannot
  obscure the usable catalog.
- Independent dual-oracle visual subagents could not be spawned from this
  worker because the harness rejected nested delegation at depth 2. The listed
  screenshots were instead inspected directly during browser QA.

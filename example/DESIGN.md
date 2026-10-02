# Social Login Buttons Gallery Design System

## 0. Research Log

- Embedded references: shortlisted Linear, Vercel, and Apple; picked Soft Structuralism + Linear because the gallery needs precise technical hierarchy without becoming a dark marketing page.
- Real-product lane: Lazyweb was skipped because its required token persistence writes outside the exclusive `example/**` scope.
- Spatial research: StyleGallery `page-grid` + `card-grid`; the document owns the only vertical scroll and cards reflow intrinsically.
- Interaction research: beui.dev `tabs` and `switch`; selected state moves through tonal fill and native Flutter controls retain keyboard/focus behavior.
- Imagen drafts: skipped because no image-generation tool is available and generated artifacts would exceed the logo-free, `example/**`-only scope.

## 1. Atmosphere & Identity

A precise specimen workbench: bright mineral surfaces, dark navy ink, and a
single electric-blue action color. The signature is the selected provider
stage, a deep panel that makes the neutral demo icon and callback state feel
like a live instrument rather than a documentation mock.

## 2. Color

All implementation colors are named in `_GalleryColors`.

| Role | Token | Value | Usage |
| --- | --- | --- | --- |
| Canvas | `canvas` | `#F3F6F8` | Page background |
| Canvas glow | `canvasGlow` | `#D9E9FF` | Atmospheric header wash |
| Surface | `surface` | `#FFFFFF` | Cards and controls |
| Surface muted | `surfaceMuted` | `#E9EEF2` | Secondary panels |
| Stage | `stage` | `#101C2C` | Selected-provider panel |
| Stage elevated | `stageElevated` | `#17263A` | Stage inner surface |
| Ink | `ink` | `#102033` | Primary text |
| Ink muted | `inkMuted` | `#5C6978` | Supporting copy |
| Ink faint | `inkFaint` | `#7E8995` | Metadata |
| On dark | `onDark` | `#F7FAFC` | Text on stage |
| On dark muted | `onDarkMuted` | `#B7C4D3` | Secondary stage text |
| Accent | `accent` | `#176BFF` | Selected controls and links |
| Accent wash | `accentWash` | `#E6EFFF` | Selection background |
| Success | `success` | `#0A7A53` | Callback state |
| Warning | `warning` | `#A25700` | Caution and unofficial note |
| Divider | `divider` | `#D8E0E7` | Structural separation |

Provider button colors remain owned by the package contract and are not
gallery design tokens.

## 3. Typography

The gallery bundles the Korean subset Regular, Medium, and Bold builds of Noto
Sans CJK from the official Noto repository and uses them for Korean and
English. Loading those weights before `runApp` prevents the Flutter web
engine's asynchronous remote fallback from exposing missing-glyph boxes on the
first rendered frame. The font is licensed under SIL Open Font License 1.1;
the bundled license is at `assets/fonts/OFL.txt`. All sizes are named in
`_GalleryTextStyles`.

| Level | Size | Weight | Line height | Usage |
| --- | ---: | ---: | ---: | --- |
| Display | 44 | 700 | 1.05 | Page title |
| Compact display | 36 | 700 | 1.08 | Page title below the compact breakpoint |
| H1 | 30 | 700 | 1.15 | Selected provider |
| H2 | 22 | 700 | 1.25 | Section headings |
| H3 | 17 | 700 | 1.35 | Card headings |
| Body large | 17 | 400 | 1.55 | Intro copy |
| Body | 15 | 400 | 1.5 | Standard copy |
| Small | 13 | 500 | 1.45 | Metadata |
| Label | 12 | 700 | 1.3 | Control labels and tags |

## 4. Spacing & Layout

Base unit: 4 logical pixels. `_GallerySpace` defines `1, 2, 3, 4, 5, 6, 8,
10, 12, 16, 20`. The page content max width is 1200, with 16 mobile and 32
desktop gutters. The document is the sole vertical scroll owner.

- Selected stage: one column below 760, two columns above it.
- Provider cards: one column below 620, two below 980, three above 980.
- Control rows use wrapping clusters and never force horizontal scrolling.

## 5. Components

### SectionHeader
- Structure: eyebrow, title, optional description.
- States: static only.
- Accessibility: semantic heading text in reading order.
- Layout: stack.

### ControlPanel
- Structure: labelled native segmented choices, dropdown, and switch.
- States: default, selected, focused, disabled where supported.
- Accessibility: native Material keyboard and semantics behavior.
- Layout: wrapping cluster on wide screens, vertical stack on mobile.

### SelectedProviderStage
- Structure: provider summary, live preview, metadata, callback live region.
- States: locale, shape, provider, enabled/disabled, callback count.
- Accessibility: full labels, live callback status, no brand-logo claim.
- Layout: responsive split; no internal scrolling.

### ProviderCard
- Structure: provider identity, actual public button, source classification,
  palette classification, asset guidance, limitations, official links.
- States: selected wash, enabled/disabled, rectangle/circle.
- Accessibility: source links name their provider and order; card order matches
  enum order.
- Layout: repeated card-grid item.

### ProviderAsset
- Structure: every preview omits `logo` and exercises the package default.
- States: Google, Apple, Kakao, Naver, and LINE render reviewed
  provider-supplied PNGs; other providers render the explicit unbundled marker.
- Accessibility: the logo/status slot is excluded from semantics because the
  button label remains the accessible name.
- Provenance: package asset URLs, source archive members, byte counts, and
  hashes are recorded in `../assets/README.md`.
- Layout: fixed package-owned slot derived from the common button size.

### SocialButtonListSpecimens
- Structure: one vertical and one horizontal list, each containing Google,
  GitHub, and Notion convenience buttons.
- States: common shape, 48 size, locale, and 8 spacing inherit from each list;
  disabled and callback behavior remain controlled by the gallery.
- Accessibility: visible headings distinguish list direction and asset mode.
- Layout: two columns above the stage split and one column below it; horizontal
  items wrap instead of introducing page-level horizontal scrolling.

## 6. Motion & Interaction

- No decorative entrance motion.
- Material controls provide immediate press, hover, and focus feedback.
- Selection changes update content in place without scroll jumps.
- Callback feedback updates in the same frame and is announced by a live region.
- Reduced motion needs no alternate path because the gallery adds no custom
  animation.

## 7. Depth & Surface

Strategy: mixed tonal shift plus restrained ambient shadow. `_GalleryShadows`
contains one card shadow and one stage shadow. Radius tokens are 10, 16, 24,
and full. Nested surfaces use concentric radii.

## 8. Accessibility Constraints & Accepted Debt

- Target: WCAG 2.2 AA; body contrast 4.5:1; visible keyboard focus; 48 logical
  pixel minimum interactive target.
- Text scaling must remain enabled and mobile content must reflow without
  horizontal page scrolling.
- Provider button semantics are owned by the package and exercised in its tests.

### Accepted Debt

None.

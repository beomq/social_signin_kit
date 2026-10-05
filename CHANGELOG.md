# Changelog

## 0.1.1

- Rewrote the public README in English with ASCII-only text for pub.dev validation.
- Corrected list examples to use `SocialButtonList.vertical`,
  `SocialButtonList.horizontal`, and `items` from the current public API.
- No runtime or public API changes.

## 0.1.0

- Public package contains UI code only; applications provide a required logo asset path.
- Removed package logo assets and automatic appearance-specific logo selection.
- Added caller-selected logo aspect ratio for complete wide marks.

Initial public code-only release.

- 35 provider style presets with Korean/English labels and caller-supplied logos.
- `SocialButton`, vertical/horizontal `SocialButtonList`, rounded/pill/circle shapes.
- Provider-default/light/dark palette presets where supported.
- Unsupported appearances retain the provider default and report once per provider/request in debug mode.
- Explicit app logo paths and per-item appearance overrides take precedence over list settings.
- Provider palette and capability metadata with first-party reference links.
- Original package code and documentation licensed under MIT; no third-party logos ship.

This package renders UI and invokes app callbacks. It does not implement
authentication, tokens, network requests, or provider approval. Public asset
redistribution remains subject to the recorded provider terms.

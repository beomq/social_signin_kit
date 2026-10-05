# social_signin_kit

A Flutter UI package for displaying sign-in buttons for 35 social providers
through a consistent API. Pressing a button invokes the callback supplied by
your app. Your app owns OAuth, tokens, network requests, and loading state.

[Live selector](https://beomq.github.io/social_signin_kit/landing/index.html) | [GitHub](https://github.com/beomq/social_signin_kit) | [pub.dev](https://pub.dev/packages/social_signin_kit)

> This package provides provider style presets and Korean/English labels, not
> official certification. It does not bundle brand logos. Supply an image your
> app is permitted to use through the required `logo` asset path. The presets
> are not a replacement for a provider's approved sign-in control or SDK.

## Install

Requires Flutter 3.29.0 or later and Dart 3.7.0 or later.

```yaml
dependencies:
  social_signin_kit: ^0.1.1
```

For a local clone, replace the version dependency with a path dependency:

```yaml
dependencies:
  social_signin_kit:
    path: /absolute/path/to/social_signin_kit
```

Use the actual clone path; the package does not need to be a sibling of your
app. Save your dependency changes and run this in the app directory:

```sh
fvm flutter pub get
```

Check compatibility with your app's existing SDK constraints before adding
the package; do not change those constraints just to install it.

## Supply your own logo

`SocialButton.logo` is a required image asset path in the consuming app.
Register your images in your app's `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/brand/
```

There is no package asset path or automatic logo replacement. Images are
displayed with `BoxFit.contain`, without cropping or recoloring. Your app
chooses the appropriate image for each appearance.

For a wide mark, set `logoAspectRatio` to its original width divided by its
height. Regular buttons use this ratio; the default is `1`. Circle buttons
display the complete image inside a square slot. To supply a custom widget,
use the compatibility API `SocialLoginButton(logo: widget, ...)`.

Your app must check the conditions for using each brand asset.
[Asset conditions and historical records](https://github.com/beomq/social_signin_kit/blob/main/docs/ASSETS.md)
are repository references, not bundled assets or permission to use a logo.

## Display a button

```dart
import 'package:flutter/material.dart';
import 'package:social_signin_kit/social_signin_kit.dart';

SocialButton(
  social: Social.notion,
  logo: 'assets/brand/notion.png',
  onPressed: startNotionSignIn,
)
```

`social`, `logo`, and `onPressed` are required. Pass `null` to `onPressed` to
disable the button. The callback names in these examples stand for your app's
existing authentication functions; the package does not implement them.

## Shapes and appearances

The supported shapes are `rounded`, `pill`, and `circle`. An unsupported
provider/shape combination falls back to that provider's default shape.

```dart
SocialButton(
  social: Social.notion,
  logo: 'assets/brand/notion.png',
  onPressed: startNotionSignIn,
  shape: SocialButtonShape.pill,
)
```

The appearances are `providerDefault`, `light`, and `dark`. These are package
palette presets based on sign-in controls, brand references, or custom styles;
availability does not imply provider approval. An unsupported appearance falls
back to `providerDefault` and reports once in debug mode, not in profile or
release mode. Your explicit `logo` path is preserved.

```dart
SocialButton(
  social: Social.google,
  logo: 'assets/brand/google.png',
  appearance: SocialButtonAppearance.dark,
  onPressed: startGoogleSignIn,
)
```

Circle buttons hide the visible label while retaining a tooltip and an
accessible name:

```dart
SocialButton(
  social: Social.github,
  logo: 'assets/brand/github.png',
  onPressed: startGitHubSignIn,
  shape: SocialButtonShape.circle,
)
```

## Display a list

`SocialButtonList.vertical` and `SocialButtonList.horizontal` accept
`SocialButton` items. Each item owns its
provider and callback. Omitted `shape`, `appearance`, and `size` values inherit
from the list; an explicit child value takes precedence. Unsupported settings
fall back independently for each provider. Each logo path remains unchanged.

### Vertical list

```dart
SocialButtonList.vertical(
  shape: SocialButtonShape.pill,
  appearance: SocialButtonAppearance.dark,
  size: 48,
  items: [
    SocialButton(
      social: Social.google,
      logo: 'assets/brand/google.png',
      onPressed: startGoogleSignIn,
    ),
    SocialButton(
      social: Social.apple,
      logo: 'assets/brand/apple.png',
      onPressed: startAppleSignIn,
    ),
    SocialButton(
      social: Social.notion,
      logo: 'assets/brand/notion.png',
      onPressed: startNotionSignIn,
    ),
  ],
)
```

An individual item can override the list appearance:

```dart
SocialButtonList.vertical(
  appearance: SocialButtonAppearance.dark,
  items: [
    SocialButton(
      social: Social.google,
      logo: 'assets/brand/google.png',
      appearance: SocialButtonAppearance.light,
      onPressed: startGoogleSignIn,
    ),
    SocialButton(
      social: Social.apple,
      logo: 'assets/brand/apple.png',
      onPressed: startAppleSignIn,
    ),
  ],
)
```

### Horizontal list

The horizontal layout uses a `Wrap`, allowing buttons to move onto additional
lines on narrow screens.

```dart
SocialButtonList.horizontal(
  shape: SocialButtonShape.circle,
  size: 48,
  spacing: 12,
  items: [
    SocialButton(
      social: Social.google,
      logo: 'assets/brand/google.png',
      onPressed: startGoogleSignIn,
    ),
    SocialButton(
      social: Social.apple,
      logo: 'assets/brand/apple.png',
      onPressed: startAppleSignIn,
    ),
    SocialButton(
      social: Social.notion,
      logo: 'assets/brand/notion.png',
      onPressed: startNotionSignIn,
    ),
  ],
)
```

## Labels and localization

When `locale` is omitted, buttons use the app's current locale. Language code
`ko` selects Korean labels; other languages use English labels. Pass `locale`
explicitly to override that choice, or supply `label` to override the preset:

```dart
SocialButton(
  social: Social.notion,
  logo: 'assets/brand/notion.png',
  onPressed: startNotionSignIn,
  locale: const Locale('en'),
  label: 'Continue with your team in Notion',
)
```

If your app uses `easy_localization`, pass the string translated by your app.
The package does not require that dependency. The following example assumes
your app has already configured its translation extension and localization:

```dart
MaterialApp(
  locale: context.locale,
  localizationsDelegates: context.localizationDelegates,
  supportedLocales: context.supportedLocales,
  home: SocialButton(
    social: Social.notion,
    logo: 'assets/brand/notion.png',
    label: 'auth.continue_with_notion'.tr(),
    onPressed: startNotionSignIn,
  ),
)
```

See [localization](https://github.com/beomq/social_signin_kit/blob/main/docs/LOCALIZATION.md)
for the selection rules.

## Disabled and loading states

`onPressed: null` disables a button. The package does not expose an `isLoading`
state. Your app manages in-flight requests and prevents duplicate submissions:

```dart
SocialButton(
  social: Social.naver,
  logo: 'assets/brand/naver.png',
  onPressed: isSigningIn ? null : startNaverSignIn,
)
```

Provide a separate progress indicator in your screen if needed. Some providers
use published state, spacing, and size values; others derive package states
from the provider palette. This does not certify a complete official control.
See [states and accessibility](https://github.com/beomq/social_signin_kit/blob/main/docs/STATES.md).

## Build a screen with the web selector

The repository's `landing/index.html` lets you select providers using actual
local logos. The selector is separate from the code-only pub.dev archive.
Use `?lang=en` or `?lang=ko` to switch its language without losing the selection
or layout settings. For local use, serve the repository root over HTTP and open
`landing/`; `file://` fetch restrictions can prevent the logo catalog loading.

The selector supports:

- Provider selection and display order.
- Vertical or horizontal lists.
- `rounded`, `pill`, and `circle` shapes.
- Previews using actual repository logos.
- Dart snippets with explicit app-owned logo paths.
- Agent instructions and a JSON handoff manifest.

Exported instructions ask the consuming app to use an existing package
dependency instead of inventing versions or repository URLs. The manifest
includes source pages, canonical download URLs, original formats, SHA-256
hashes, licenses, official/third-party status, and destination paths.
Archive members and archive hashes remain separate from extracted file hashes.
Relative download URLs resolve against the landing page; localhost URLs are
marked as available only on the same machine.

Explicit `archiveMember`, `archiveSha256`, and
`rasterization { color, width, height }` metadata is preserved. Rasterization
applies only to SVGs with explicit conversion metadata. Downloaded or extracted
PNGs retain their original bytes, dimensions, transparency, and internal
padding; they are not resized onto a 128px canvas. Instructions use the app's
existing conversion tools rather than adding a runtime dependency such as
`flutter_svg` by default.

Generated callback names are integration placeholders. Replace them with your
app's existing sign-in or account-linking functions. The selector does not
create OAuth, token, or redirect handling.

## Scope and provider requirements

- `Social` contains 35 providers, including Notion.
- The package renders UI and invokes `onPressed`; it does not authenticate users.
- Your app is responsible for asset permissions, authentication SDKs, OAuth,
  tokens, error screens, and loading state.
- Use the provider's official implementation when its complete button or SDK
  control is required.

## Documentation

- [API](https://github.com/beomq/social_signin_kit/blob/main/docs/API.md)
- [Localization](https://github.com/beomq/social_signin_kit/blob/main/docs/LOCALIZATION.md)
- [Assets](https://github.com/beomq/social_signin_kit/blob/main/docs/ASSETS.md)
- [States and accessibility](https://github.com/beomq/social_signin_kit/blob/main/docs/STATES.md)
- [Troubleshooting](https://github.com/beomq/social_signin_kit/blob/main/docs/TROUBLESHOOTING.md)
- [Migration from the compatibility API](https://github.com/beomq/social_signin_kit/blob/main/docs/MIGRATION.md)
- [Provider sources and limitations](https://github.com/beomq/social_signin_kit/blob/main/docs/PROVIDER_GUIDE.md)
- [Appearance and shape references](https://github.com/beomq/social_signin_kit/blob/main/research/theme-shape-support.md)
- [Agent integration instructions](https://github.com/beomq/social_signin_kit/blob/main/docs/AGENT_SETUP.md)
- [Web selector asset contract](https://github.com/beomq/social_signin_kit/blob/main/docs/LANDING_ASSETS.md)

## Publication checks

Before publishing, inspect the included files and warnings from:

```sh
fvm flutter pub publish --dry-run
```

The code-only archive excludes brand images and acquisition records. See the
[publication verification record](https://github.com/beomq/social_signin_kit/blob/main/docs/PUBLISHING.md)
for the packaging and SDK checks.

import 'dart:ui';

/// Visual color mode requested for a social button.
enum SocialButtonAppearance { providerDefault, light, dark }

/// Shared button geometry.
enum SocialButtonShape { rounded, pill, circle }

/// First-party evidence status for a package appearance or shape.
enum SocialButtonSupport { supported, restricted, unverified }

final class SocialButtonLocalizedReason {
  const SocialButtonLocalizedReason({required this.en, required this.ko});

  final String en;
  final String ko;

  String forLocale(Locale locale) =>
      locale.languageCode.toLowerCase() == 'ko' ? ko : en;
}

final class SocialButtonAppearanceStyle {
  const SocialButtonAppearanceStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderColor,
  });

  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;
}

final class SocialButtonCapabilities {
  SocialButtonCapabilities({
    required List<SocialButtonAppearance> appearances,
    required Map<SocialButtonShape, SocialButtonSupport> shapes,
    required Map<SocialButtonShape, SocialButtonLocalizedReason> shapeReasons,
    required List<String> sources,
    this.providerDefaultShape = SocialButtonShape.rounded,
  }) : appearances = List.unmodifiable(appearances),
       shapes = Map.unmodifiable(shapes),
       shapeReasons = Map.unmodifiable(shapeReasons),
       sources = List.unmodifiable(sources);

  final List<SocialButtonAppearance> appearances;
  final Map<SocialButtonShape, SocialButtonSupport> shapes;
  final Map<SocialButtonShape, SocialButtonLocalizedReason> shapeReasons;
  final List<String> sources;
  final SocialButtonShape providerDefaultShape;

  SocialButtonSupport shapeSupport(SocialButtonShape shape) => shapes[shape]!;

  /// Resolves the runtime shape without turning evidence metadata into a ban.
  ///
  /// [shapeSupport] remains available so callers can warn when a requested
  /// custom treatment conflicts with or is absent from first-party guidance.
  SocialButtonShape effectiveShape(SocialButtonShape requestedShape) =>
      requestedShape;

  SocialButtonAppearance effectiveAppearance(
    SocialButtonAppearance requestedAppearance,
  ) =>
      appearances.contains(requestedAppearance)
          ? requestedAppearance
          : SocialButtonAppearance.providerDefault;
}

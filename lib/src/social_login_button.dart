import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'social_button_models.dart';
import 'social_login_provider.dart';

enum SocialLoginButtonShape { rectangle, circle }

final _reportedAppearanceFallbacks = <(Social, SocialButtonAppearance)>{};

/// A UI-only sign-in button. The application owns the callback.
///
/// The provider's bundled package logo is used by default. An explicit [logo]
/// always loads from the consuming application's asset bundle.
/// Explicit settings override the enclosing [SocialButtonList].
class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    required this.social,
    required this.onPressed,
    this.logo,
    this.shape,
    this.appearance,
    this.size,
    this.locale,
    this.label,
    this.semanticLabel,
  });

  final Social social;
  final VoidCallback? onPressed;
  final String? logo;

  /// Null inherits the list shape, then defaults to [SocialButtonShape.rounded].
  final SocialButtonShape? shape;

  /// Null inherits the list appearance, then uses the provider default.
  final SocialButtonAppearance? appearance;

  /// Positive, finite minimum height, or circle diameter. Defaults to 48.
  ///
  /// Labelled buttons can grow with text scaling. Sizes below 48 retain a
  /// minimum 48 logical pixel touch target; parents must allow that space.
  final double? size;

  /// Null inherits the list locale, then Flutter's [Localizations] locale.
  /// Without localizations, English is used. Only `ko` selects Korean.
  final Locale? locale;
  final String? label;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    assert(logo == null || logo!.trim().isNotEmpty, 'logo must not be blank.');
    final defaults = _SocialButtonDefaults.maybeOf(context);
    final data = socialLoginProviderData(social);
    final requestedShape =
        shape ?? defaults?.shape ?? SocialButtonShape.rounded;
    final effectiveShape = data.capabilities.effectiveShape(requestedShape);
    final requestedAppearance =
        appearance ??
        defaults?.appearance ??
        SocialButtonAppearance.providerDefault;
    final effectiveAppearance = data.capabilities.effectiveAppearance(
      requestedAppearance,
    );
    assert(() {
      if (requestedAppearance != effectiveAppearance &&
          _reportedAppearanceFallbacks.add((social, requestedAppearance))) {
        debugPrint(
          '[social_signin_kit] ${social.name}: '
          '${requestedAppearance.name} is not supported; '
          'using ${effectiveAppearance.name}. '
          'Available: ${data.capabilities.appearances.map((value) => value.name).join(', ')}.',
        );
      }
      return true;
    }());
    final appearanceStyle = data.appearanceStyle(effectiveAppearance);
    final usesBundledLogo = logo == null;
    final bundledPath =
        appearanceStyle.asset ?? data.bundledLogoAsset;
    final path = logo ?? bundledPath;
    Widget logoWidget = Image.asset(
      path,
      key: ValueKey(path),
      package: usesBundledLogo ? 'social_signin_kit' : null,
      fit: BoxFit.contain,
      color:
          onPressed == null && social == Social.line && usesBundledLogo
              ? const Color(0x331E1E1E)
              : usesBundledLogo
              ? appearanceStyle.logoColor
              : null,
      colorBlendMode:
          onPressed == null && social == Social.line && usesBundledLogo
              ? BlendMode.srcIn
              : usesBundledLogo && appearanceStyle.logoColor != null
              ? BlendMode.srcIn
              : null,
      excludeFromSemantics: true,
      errorBuilder: (context, error, stackTrace) => _LogoAssetError(
        path: path,
        bundled: usesBundledLogo,
        error: error,
        stackTrace: stackTrace,
      ),
    );
    if (appearanceStyle.logoBackgroundColor != null) {
      logoWidget = ColoredBox(
        color: appearanceStyle.logoBackgroundColor!,
        child: logoWidget,
      );
    }
    return _SocialButton(
      provider: social,
      logo: logoWidget,
      onPressed: onPressed,
      shape: effectiveShape,
      appearance: effectiveAppearance,
      size: size ?? defaults?.size ?? 48,
      locale: locale ?? defaults?.locale,
      label: label,
      semanticLabel: semanticLabel,
      expand: defaults?.expand ?? true,
      usesProviderLogoLayout: true,
    );
  }
}

/// Common settings for a group of buttons, without replacing explicit items.
///
/// Vertical lists stretch labelled buttons to the available width (280 when
/// unbounded). Horizontal lists keep natural widths and wrap into new runs,
/// also using 280 as their available width when the parent is unbounded.
/// An explicit circle remains square, including inside a vertical list.
/// This widget does not own scrolling.
class SocialButtonList extends StatelessWidget {
  const SocialButtonList.vertical({
    super.key,
    required this.items,
    this.shape = SocialButtonShape.rounded,
    this.appearance = SocialButtonAppearance.providerDefault,
    this.size = 48,
    this.locale,
    this.spacing = 8,
  }) : _vertical = true;

  const SocialButtonList.horizontal({
    super.key,
    required this.items,
    this.shape = SocialButtonShape.circle,
    this.appearance = SocialButtonAppearance.providerDefault,
    this.size = 48,
    this.locale,
    this.spacing = 8,
  }) : _vertical = false;

  final List<SocialButton> items;
  final SocialButtonShape shape;
  final SocialButtonAppearance appearance;
  final double size;
  final Locale? locale;

  /// Space between items, and between horizontal runs. Defaults to 8.
  final double spacing;
  final bool _vertical;

  @override
  Widget build(BuildContext context) {
    assert(size.isFinite && size > 0, 'size must be positive and finite.');
    assert(
      spacing.isFinite && spacing >= 0,
      'spacing must be non-negative and finite.',
    );
    return _SocialButtonDefaults(
      shape: shape,
      appearance: appearance,
      size: size,
      locale: locale,
      expand: _vertical,
      child: _vertical
          ? LayoutBuilder(
              builder: (context, constraints) => SizedBox(
                width: constraints.hasBoundedWidth ? constraints.maxWidth : 280,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var index = 0; index < items.length; index++) ...[
                      if (index > 0) SizedBox(height: spacing),
                      items[index],
                    ],
                  ],
                ),
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) => SizedBox(
                width: constraints.hasBoundedWidth ? null : 280,
                child: Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: items,
                ),
              ),
            ),
    );
  }
}

class _SocialButtonDefaults extends InheritedWidget {
  const _SocialButtonDefaults({
    required this.shape,
    required this.appearance,
    required this.size,
    required this.locale,
    required this.expand,
    required super.child,
  });

  final SocialButtonShape shape;
  final SocialButtonAppearance appearance;
  final double size;
  final Locale? locale;
  final bool expand;

  static _SocialButtonDefaults? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_SocialButtonDefaults>();

  @override
  bool updateShouldNotify(_SocialButtonDefaults oldWidget) =>
      shape != oldWidget.shape ||
      appearance != oldWidget.appearance ||
      size != oldWidget.size ||
      locale != oldWidget.locale ||
      expand != oldWidget.expand;
}

/// Compatibility API accepting a caller-supplied logo widget.
class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    super.key,
    required this.provider,
    required this.logo,
    required this.onPressed,
    this.shape = SocialLoginButtonShape.rectangle,
    this.appearance = SocialButtonAppearance.providerDefault,
    this.locale,
    this.label,
    this.semanticLabel,
  });

  final SocialLoginProvider provider;
  final Widget logo;
  final VoidCallback? onPressed;
  final SocialLoginButtonShape shape;
  final SocialButtonAppearance appearance;
  final Locale? locale;
  final String? label;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final requestedShape =
        shape == SocialLoginButtonShape.circle
            ? SocialButtonShape.circle
            : SocialButtonShape.rounded;
    final effectiveShape =
        socialLoginProviderData(provider).capabilities.effectiveShape(
          requestedShape,
        );
    return _SocialButton(
      provider: provider,
      logo: logo,
      onPressed: onPressed,
      shape: effectiveShape,
      appearance: appearance,
      size: 48,
      locale: locale,
      label: label,
      semanticLabel: semanticLabel,
      expand: true,
      usesProviderLogoLayout: false,
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.provider,
    required this.logo,
    required this.onPressed,
    required this.shape,
    required this.appearance,
    required this.size,
    required this.locale,
    required this.label,
    required this.semanticLabel,
    required this.expand,
    required this.usesProviderLogoLayout,
  });

  final Social provider;
  final Widget logo;
  final VoidCallback? onPressed;
  final SocialButtonShape shape;
  final SocialButtonAppearance appearance;
  final double size;
  final Locale? locale;
  final String? label;
  final String? semanticLabel;
  final bool expand;
  final bool usesProviderLogoLayout;

  @override
  Widget build(BuildContext context) {
    assert(_debugCheckInput());
    final data = socialLoginProviderData(provider);
    final appearanceStyle = data.appearanceStyle(appearance);
    final resolvedLocale =
        locale ?? Localizations.maybeLocaleOf(context) ?? const Locale('en');
    final visibleLabel = label ?? data.labelFor(resolvedLocale);
    final accessibilityLabel = semanticLabel ?? visibleLabel;
    final spec = _buttonSpec(
      provider,
      size: size,
      usesProviderLogoLayout: usesProviderLogoLayout,
    );
    final button = TextButton(
      onPressed: onPressed,
      style: _buttonStyle(
        data,
        appearanceStyle,
        spec,
        Theme.of(context).textTheme.labelLarge!,
      ),
      child: Semantics(
        label: accessibilityLabel,
        excludeSemantics: true,
        child:
            shape == SocialButtonShape.circle
                ? _LogoSlot(logo: logo, size: spec.logoSize ?? size / 2)
                : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _LogoSlot(logo: logo, size: spec.logoSize ?? size / 2),
                    if (spec.separatorColor != null) ...[
                      SizedBox(width: spec.logoLabelSpacing),
                      Container(
                        key: const ValueKey('line-separator'),
                        width: 1,
                        height: spec.logoSize ?? size / 2,
                        color:
                            onPressed == null
                                ? spec.disabledSeparatorColor ??
                                    spec.separatorColor
                                : spec.separatorColor,
                      ),
                    ],
                    SizedBox(width: spec.logoLabelSpacing),
                    Flexible(
                      child: Text(
                        visibleLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
      ),
    );

    if (shape == SocialButtonShape.circle) {
      return Align(
        alignment: Alignment.center,
        widthFactor: 1,
        heightFactor: 1,
        child: Tooltip(
          message: accessibilityLabel,
          excludeFromSemantics: true,
          child: SizedBox.square(
            dimension: size < 48 ? 48 : size,
            child: Center(child: button),
          ),
        ),
      );
    }

    if (!expand) return button;

    return LayoutBuilder(
      builder:
          (context, constraints) => SizedBox(
            width:
                constraints.hasBoundedWidth
                    ? constraints.maxWidth
                    : spec.preferredWidth,
            child: button,
          ),
    );
  }

  bool _debugCheckInput() {
    assert(size.isFinite && size > 0, 'size must be positive and finite.');
    assert(
      label == null || label!.trim().isNotEmpty,
      'label must not be blank.',
    );
    assert(
      label == null || (!label!.contains('\n') && !label!.contains('\r')),
      'label must not contain line breaks.',
    );
    assert(
      semanticLabel == null || semanticLabel!.trim().isNotEmpty,
      'semanticLabel must not be blank.',
    );
    return true;
  }

  ButtonStyle _buttonStyle(
    SocialLoginProviderData data,
    SocialButtonAppearanceStyle appearanceStyle,
    _ProviderButtonSpec spec,
    TextStyle themeTextStyle,
  ) {
    final isCircle = shape == SocialButtonShape.circle;
    // Muting each palette preserves its hue instead of replacing every service
    // with global greys. Composite translucent text first (for example Kakao),
    // so all disabled colors remain opaque and independent of the app surface.
    // These derived states are package presets, not provider specifications.
    // The caller-owned logo is never tinted or faded.
    final compositedForeground =
        Color.alphaBlend(
          appearanceStyle.foregroundColor,
          appearanceStyle.backgroundColor,
        );
    final disabledBackground =
        spec.disabledBackground ??
        Color.lerp(
          appearanceStyle.backgroundColor,
          compositedForeground,
          0.08,
        )!;
    final disabledForeground =
        spec.disabledForeground ??
        Color.lerp(
          compositedForeground,
          appearanceStyle.backgroundColor,
          0.12,
        )!;
    final disabledBorder =
        spec.disabledBorder ??
        Color.lerp(
          appearanceStyle.borderColor ?? compositedForeground,
          disabledBackground,
          0.5,
        )!;
    // Choose a visible wash without reducing the tested text contrast.
    // These washes are package choices, not official interaction colors.
    final overlayBase =
        appearanceStyle.foregroundColor.computeLuminance() > 0.5
            ? (appearanceStyle.backgroundColor.computeLuminance() < 0.02
                ? Colors.white : Colors.black)
            : (appearanceStyle.backgroundColor.computeLuminance() < 0.8
                ? Colors.white : Colors.black);
    Color foregroundFor(Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return disabledForeground;
      }
      if (states.contains(WidgetState.pressed) &&
          spec.pressedOpacity != null) {
        return appearanceStyle.foregroundColor.withValues(
          alpha: spec.pressedOpacity!,
        );
      }
      if (states.contains(WidgetState.hovered) && spec.hoverOpacity != null) {
        return appearanceStyle.foregroundColor.withValues(
          alpha: spec.hoverOpacity!,
        );
      }
      return appearanceStyle.foregroundColor;
    }

    return ButtonStyle(
      elevation: const WidgetStatePropertyAll(0),
      backgroundColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.disabled)) {
            return disabledBackground;
          }
          if (states.contains(WidgetState.pressed) &&
              spec.pressedOpacity != null) {
            return appearanceStyle.backgroundColor.withValues(
              alpha: spec.pressedOpacity!,
            );
          }
          if (states.contains(WidgetState.hovered) &&
              spec.hoverOpacity != null) {
            return appearanceStyle.backgroundColor.withValues(
              alpha: spec.hoverOpacity!,
            );
          }
          return appearanceStyle.backgroundColor;
        },
      ),
      foregroundColor: WidgetStateProperty.resolveWith(
        foregroundFor,
      ),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return null;
        }
        if (spec.hoverOpacity != null || spec.pressedOpacity != null) {
          return Colors.transparent;
        }
        if (states.contains(WidgetState.pressed)) {
          return spec.pressedOverlay ?? overlayBase.withValues(alpha: 0.12);
        }
        if (states.contains(WidgetState.focused)) {
          return overlayBase.withValues(alpha: 0.12);
        }
        if (states.contains(WidgetState.hovered)) {
          return spec.hoverOverlay ?? overlayBase.withValues(alpha: 0.08);
        }
        return null;
      }),
      side: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return BorderSide(color: disabledBorder);
        }
        if (states.contains(WidgetState.focused)) {
          return BorderSide(
            color: appearanceStyle.foregroundColor,
            width: 2,
          );
        }
        final borderColor = appearanceStyle.borderColor;
        return borderColor == null
            ? BorderSide.none
            : BorderSide(color: borderColor);
      }),
      shape: WidgetStatePropertyAll(
        switch (shape) {
          SocialButtonShape.circle => const CircleBorder(),
          SocialButtonShape.pill => const StadiumBorder(),
          SocialButtonShape.rounded =>
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(spec.cornerRadius),
            ),
        },
      ),
      textStyle: WidgetStateProperty.resolveWith(
        (states) => themeTextStyle.copyWith(
          fontSize: spec.fontSize,
          height: spec.lineHeight,
          fontWeight: spec.fontWeight,
          color: foregroundFor(states),
        ),
      ),
      padding: WidgetStatePropertyAll(
        isCircle
            ? EdgeInsets.all(
              ((size - (spec.logoSize ?? size / 2)) / 2)
                  .clamp(0, size / 4)
                  .toDouble(),
            )
            : spec.padding,
      ),
      minimumSize: WidgetStatePropertyAll(
        isCircle
            ? Size.square(size)
            : Size(0, size < spec.minimumHeight ? spec.minimumHeight : size),
      ),
      fixedSize:
          isCircle ? WidgetStatePropertyAll(Size.square(size)) : null,
      maximumSize: const WidgetStatePropertyAll(Size.infinite),
      visualDensity: VisualDensity.standard,
      tapTargetSize: MaterialTapTargetSize.padded,
      alignment: Alignment.center,
    );
  }
}

final class _ProviderButtonSpec {
  const _ProviderButtonSpec({
    this.logoSize,
    this.logoLabelSpacing = 8,
    this.separatorColor,
    this.disabledSeparatorColor,
    this.cornerRadius = 8,
    this.minimumHeight = 48,
    this.preferredWidth = 280,
    this.fontSize = 14,
    this.lineHeight,
    this.fontWeight = FontWeight.w600,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.hoverOverlay,
    this.pressedOverlay,
    this.disabledBackground,
    this.disabledForeground,
    this.disabledBorder,
    this.hoverOpacity,
    this.pressedOpacity,
  });

  final double? logoSize;
  final double logoLabelSpacing;
  final Color? separatorColor;
  final Color? disabledSeparatorColor;
  final double cornerRadius;
  final double minimumHeight;
  final double preferredWidth;
  final double fontSize;
  final double? lineHeight;
  final FontWeight fontWeight;
  final EdgeInsets padding;
  final Color? hoverOverlay;
  final Color? pressedOverlay;
  final Color? disabledBackground;
  final Color? disabledForeground;
  final Color? disabledBorder;
  final double? hoverOpacity;
  final double? pressedOpacity;
}

_ProviderButtonSpec _buttonSpec(
  Social provider, {
  required double size,
  required bool usesProviderLogoLayout,
}) => switch (provider) {
  Social.microsoft => _ProviderButtonSpec(
    logoSize: usesProviderLogoLayout ? 21 : null,
  ),
  Social.line =>
    usesProviderLogoLayout
        ? _ProviderButtonSpec(
          logoSize: 30,
          logoLabelSpacing: size * 4 / 11,
          separatorColor: const Color(0x14000000),
          disabledSeparatorColor: const Color(0x99E5E5E5),
          padding: EdgeInsets.symmetric(
            horizontal: size * 4 / 11,
            vertical: size * 2 / 11,
          ),
          hoverOverlay: const Color(0x1A000000),
          pressedOverlay: const Color(0x4D000000),
          disabledBackground: const Color(0xFFFFFFFF),
          disabledForeground: const Color(0x331E1E1E),
          disabledBorder: const Color(0x99E5E5E5),
        )
        : const _ProviderButtonSpec(
          separatorColor: Color(0x14000000),
          disabledSeparatorColor: Color(0x99E5E5E5),
          hoverOverlay: Color(0x1A000000),
          pressedOverlay: Color(0x4D000000),
          disabledBackground: Color(0xFFFFFFFF),
          disabledForeground: Color(0x331E1E1E),
          disabledBorder: Color(0x99E5E5E5),
        ),
  Social.slack => const _ProviderButtonSpec(
    logoSize: 20,
    logoLabelSpacing: 12,
    minimumHeight: 44,
    preferredWidth: 256,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
  Social.vk => const _ProviderButtonSpec(
    logoSize: 28,
    minimumHeight: 44,
    fontSize: 16,
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    hoverOpacity: 0.8,
    pressedOpacity: 0.7,
    disabledBackground: Color(0xFF006DEB),
    disabledForeground: Color(0xFFF7FBFF),
  ),
  Social.kakao => const _ProviderButtonSpec(
    logoSize: 48,
    cornerRadius: 12,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    padding: EdgeInsets.symmetric(horizontal: 16),
  ),
  Social.naver => _ProviderButtonSpec(
    logoSize: usesProviderLogoLayout ? 45 : null,
    logoLabelSpacing: 8,
    minimumHeight: 56,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    disabledBackground: const Color(0xFF039B47),
    disabledForeground: const Color(0xFFF7FCFA),
  ),
  Social.google => _ProviderButtonSpec(
    logoSize: usesProviderLogoLayout ? 20 : null,
    logoLabelSpacing: usesProviderLogoLayout ? 10 : 8,
    fontSize: 14,
    lineHeight: 20 / 14,
    fontWeight: FontWeight.w500,
    padding:
        usesProviderLogoLayout
            ? const EdgeInsets.fromLTRB(12, 10, 12, 10)
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),
  Social.apple => const _ProviderButtonSpec(
    logoSize: 44,
    cornerRadius: 15,
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
  ),
  Social.spotify => const _ProviderButtonSpec(
    logoSize: 24,
    logoLabelSpacing: 12,
  ),
  _ => _ProviderButtonSpec(
    logoSize: usesProviderLogoLayout ? 24 : null,
  ),
};

class _LogoSlot extends StatelessWidget {
  const _LogoSlot({required this.logo, required this.size});

  final Widget logo;
  final double size;

  @override
  Widget build(BuildContext context) =>
      SizedBox.square(dimension: size, child: ExcludeSemantics(child: logo));
}

// Report each failed image once, while keeping the visual failure inside the
// logo slot. Throwing in Image.errorBuilder would render a raw ErrorWidget and
// repeat diagnostics whenever the surrounding button rebuilds.
class _LogoAssetError extends StatefulWidget {
  const _LogoAssetError({
    required this.path,
    required this.bundled,
    required this.error,
    required this.stackTrace,
  });

  final String path;
  final bool bundled;
  final Object error;
  final StackTrace? stackTrace;

  @override
  State<_LogoAssetError> createState() => _LogoAssetErrorState();
}

class _LogoAssetErrorState extends State<_LogoAssetError> {
  @override
  void initState() {
    super.initState();
    _report();
  }

  @override
  void didUpdateWidget(_LogoAssetError oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.path != oldWidget.path || widget.error != oldWidget.error) {
      _report();
    }
  }

  void _report() => FlutterError.reportError(FlutterErrorDetails(
    exception: FlutterError.fromParts([
      ErrorSummary('Unable to load SocialButton logo asset: "${widget.path}".'),
      ErrorDescription(
        widget.bundled
            ? 'The package-declared logo at "${widget.path}" could not be '
                'loaded. Re-run flutter pub get and report the package asset '
                'failure.'
            : 'Expected an image at "${widget.path}" in the application asset '
                'bundle. Add and declare it under flutter/assets in '
                'pubspec.yaml, or pass a different logo path.',
      ),
      DiagnosticsProperty<Object>('Asset error', widget.error),
    ]),
    stack: widget.stackTrace,
    library: 'social_signin_kit',
  ));

  @override
  Widget build(BuildContext context) => Tooltip(
    message: 'Missing logo asset: "${widget.path}"',
    excludeFromSemantics: true,
    child: const SizedBox.expand(
      child: FittedBox(child: Icon(Icons.broken_image_outlined, size: 24)),
    ),
  );
}

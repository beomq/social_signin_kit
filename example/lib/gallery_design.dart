import 'package:flutter/material.dart';

abstract final class GalleryColors {
  static const canvas = Color(0xFFF3F6F8);
  static const canvasGlow = Color(0xFFD9E9FF);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFE9EEF2);
  static const stage = Color(0xFF101C2C);
  static const stageElevated = Color(0xFF17263A);
  static const ink = Color(0xFF102033);
  static const inkMuted = Color(0xFF5C6978);
  static const inkFaint = Color(0xFF7E8995);
  static const onDark = Color(0xFFF7FAFC);
  static const onDarkMuted = Color(0xFFB7C4D3);
  static const accent = Color(0xFF176BFF);
  static const accentWash = Color(0xFFE6EFFF);
  static const success = Color(0xFF0A7A53);
  static const warning = Color(0xFFA25700);
  static const divider = Color(0xFFD8E0E7);
}

abstract final class GallerySpace {
  static const x1 = 4.0;
  static const x2 = 8.0;
  static const x3 = 12.0;
  static const x4 = 16.0;
  static const x5 = 20.0;
  static const x6 = 24.0;
  static const x8 = 32.0;
  static const x10 = 40.0;
  static const x12 = 48.0;
  static const x16 = 64.0;
  static const x20 = 80.0;
}

abstract final class GalleryRadii {
  static const small = 10.0;
  static const medium = 16.0;
  static const large = 24.0;
  static const full = 999.0;
}

abstract final class GalleryLayout {
  static const maxContentWidth = 1200.0;
  static const mobileGutter = 16.0;
  static const desktopGutter = 32.0;
  static const compact = 620.0;
  static const stageSplit = 760.0;
  static const threeColumns = 980.0;
  static const controlWidth = 220.0;
  static const cardMinWidth = 280.0;
}

abstract final class GalleryShadows {
  static const card = [
    BoxShadow(color: Color(0x120D223A), blurRadius: 24, offset: Offset(0, 10)),
  ];
  static const stage = [
    BoxShadow(color: Color(0x24101C2C), blurRadius: 40, offset: Offset(0, 20)),
  ];
}

abstract final class GalleryTextStyles {
  static const display = TextStyle(
    fontSize: 44,
    height: 1.05,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.2,
    color: GalleryColors.ink,
  );
  static const displayCompact = TextStyle(
    fontSize: 36,
    height: 1.08,
    fontWeight: FontWeight.w700,
    letterSpacing: -1,
    color: GalleryColors.ink,
  );
  static const h1 = TextStyle(
    fontSize: 30,
    height: 1.15,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );
  static const h2 = TextStyle(
    fontSize: 22,
    height: 1.25,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    color: GalleryColors.ink,
  );
  static const h3 = TextStyle(
    fontSize: 17,
    height: 1.35,
    fontWeight: FontWeight.w700,
  );
  static const bodyLarge = TextStyle(
    fontSize: 17,
    height: 1.55,
    fontWeight: FontWeight.w400,
    color: GalleryColors.inkMuted,
  );
  static const body = TextStyle(
    fontSize: 15,
    height: 1.5,
    fontWeight: FontWeight.w400,
  );
  static const small = TextStyle(
    fontSize: 13,
    height: 1.45,
    fontWeight: FontWeight.w500,
  );
  static const label = TextStyle(
    fontSize: 12,
    height: 1.3,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
  );
}

ThemeData buildGalleryTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: GalleryColors.accent,
    brightness: Brightness.light,
    surface: GalleryColors.surface,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    fontFamily: 'NotoSansKR',
    scaffoldBackgroundColor: GalleryColors.canvas,
    textTheme: const TextTheme(
      bodyLarge: GalleryTextStyles.bodyLarge,
      bodyMedium: GalleryTextStyles.body,
      bodySmall: GalleryTextStyles.small,
      titleLarge: GalleryTextStyles.h2,
      titleMedium: GalleryTextStyles.h3,
      labelLarge: GalleryTextStyles.label,
    ),
    focusColor: GalleryColors.accentWash,
    dividerColor: GalleryColors.divider,
    dropdownMenuTheme: DropdownMenuThemeData(
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: GalleryColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(GalleryRadii.small),
          borderSide: const BorderSide(color: GalleryColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(GalleryRadii.small),
          borderSide: const BorderSide(color: GalleryColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(GalleryRadii.small),
          borderSide: const BorderSide(color: GalleryColors.accent, width: 2),
        ),
      ),
    ),
  );
}

class GallerySurface extends StatelessWidget {
  const GallerySurface({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(GallerySpace.x6),
    this.color = GalleryColors.surface,
    this.radius = GalleryRadii.medium,
    this.shadow = GalleryShadows.card,
    this.borderColor = GalleryColors.divider,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final double radius;
  final List<BoxShadow> shadow;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        border: borderColor == null ? null : Border.all(color: borderColor!),
        boxShadow: shadow,
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

class GallerySectionHeader extends StatelessWidget {
  const GallerySectionHeader({
    required this.eyebrow,
    required this.title,
    super.key,
    this.description,
  });

  final String eyebrow;
  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow.toUpperCase(),
          style: GalleryTextStyles.label.copyWith(color: GalleryColors.accent),
        ),
        const SizedBox(height: GallerySpace.x2),
        Text(title, style: GalleryTextStyles.h2),
        if (description != null) ...[
          const SizedBox(height: GallerySpace.x2),
          Text(
            description!,
            style: GalleryTextStyles.body.copyWith(
              color: GalleryColors.inkMuted,
            ),
          ),
        ],
      ],
    );
  }
}

class GalleryTag extends StatelessWidget {
  const GalleryTag({
    required this.label,
    super.key,
    this.foreground = GalleryColors.inkMuted,
    this.background = GalleryColors.surfaceMuted,
  });

  final String label;
  final Color foreground;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(GalleryRadii.full),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: GallerySpace.x3,
          vertical: GallerySpace.x2,
        ),
        child: Text(
          label,
          style: GalleryTextStyles.label.copyWith(color: foreground),
        ),
      ),
    );
  }
}

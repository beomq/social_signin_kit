import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:social_signin_kit/social_signin_kit.dart';

void main() {
  group('public contract and rendering', () {
    testWidgets('renders every provider, shape, and contracted locale', (
      tester,
    ) async {
      for (final provider in SocialLoginProvider.values) {
        for (final shape in SocialLoginButtonShape.values) {
          for (final locale in const [Locale('ko'), Locale('en')]) {
            final logo = SizedBox(
              key: ValueKey('logo-${provider.name}-${shape.name}'),
            );

            await tester.pumpWidget(
              _app(
                SocialLoginButton(
                  provider: provider,
                  logo: logo,
                  onPressed: () {},
                  shape: shape,
                  locale: locale,
                ),
              ),
            );

            expect(find.byType(SocialLoginButton), findsOneWidget);
            expect(
              tester.widget(find.byKey(logo.key!)),
              same(logo),
              reason: '${provider.name}/${shape.name} replaced the logo widget',
            );
            expect(tester.takeException(), isNull);
          }
        }
      }
    });

    testWidgets('rejects blank and multiline programmer input', (tester) async {
      for (final invalid in ['', '   ', '\n', 'two\nlines', 'two\rlines']) {
        await tester.pumpWidget(
          _app(
            SocialLoginButton(
              provider: SocialLoginProvider.google,
              logo: const SizedBox(),
              onPressed: () {},
              label: invalid,
            ),
          ),
        );
        expect(tester.takeException(), isAssertionError);
      }

      await tester.pumpWidget(
        _app(
          SocialLoginButton(
            provider: SocialLoginProvider.google,
            logo: const SizedBox(),
            onPressed: () {},
            semanticLabel: ' ',
          ),
        ),
      );
      expect(tester.takeException(), isAssertionError);
    });
  });

  group('locale and labels', () {
    testWidgets('uses explicit locale before inherited locale', (tester) async {
      await tester.pumpWidget(
        _app(
          _withLocale(
            const Locale('ko'),
            const SocialLoginButton(
              provider: SocialLoginProvider.google,
              logo: SizedBox(),
              onPressed: _noop,
              locale: Locale('ja'),
            ),
          ),
        ),
      );

      expect(find.text('Sign in with Google'), findsOneWidget);
      expect(find.text('Google 로그인'), findsNothing);
    });

    testWidgets('uses inherited Korean and English locales', (tester) async {
      await tester.pumpWidget(
        _app(
          _withLocale(
            const Locale('ko', 'KR'),
            const SocialLoginButton(
              provider: SocialLoginProvider.google,
              logo: SizedBox(),
              onPressed: _noop,
            ),
          ),
        ),
      );
      expect(find.text('Google 로그인'), findsOneWidget);

      await tester.pumpWidget(
        _app(
          _withLocale(
            const Locale('en', 'GB'),
            const SocialLoginButton(
              provider: SocialLoginProvider.google,
              logo: SizedBox(),
              onPressed: _noop,
            ),
          ),
        ),
      );
      expect(find.text('Sign in with Google'), findsOneWidget);
    });

    testWidgets('falls back to English without inherited localizations', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Material(
              child: SocialLoginButton(
                provider: SocialLoginProvider.google,
                logo: SizedBox(),
                onPressed: _noop,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Sign in with Google'), findsOneWidget);
    });

    testWidgets('rebuild updates label and circle tooltip together', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          const SocialLoginButton(
            provider: SocialLoginProvider.google,
            logo: SizedBox(),
            onPressed: _noop,
            shape: SocialLoginButtonShape.circle,
            locale: Locale('ko'),
          ),
        ),
      );

      var tooltip = tester.widget<Tooltip>(find.byType(Tooltip));
      expect(tooltip.message, 'Google 로그인');
      expect(tooltip.excludeFromSemantics, isTrue);

      await tester.pumpWidget(
        _app(
          const SocialLoginButton(
            provider: SocialLoginProvider.google,
            logo: SizedBox(),
            onPressed: _noop,
            shape: SocialLoginButtonShape.circle,
            locale: Locale('en'),
          ),
        ),
      );

      tooltip = tester.widget<Tooltip>(find.byType(Tooltip));
      expect(tooltip.message, 'Sign in with Google');
    });

    testWidgets('custom labels preserve whitespace and semantics precedence', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();

      await tester.pumpWidget(
        _app(
          const SocialLoginButton(
            provider: SocialLoginProvider.google,
            logo: SizedBox(),
            onPressed: _noop,
            label: '  Custom label  ',
            semanticLabel: 'Accessible action',
          ),
        ),
      );

      expect(find.text('  Custom label  '), findsOneWidget);
      expect(find.bySemanticsLabel('Accessible action'), findsOneWidget);
      expect(find.bySemanticsLabel('  Custom label  '), findsNothing);
      semantics.dispose();
    });
  });

  group('input and semantics', () {
    testWidgets('pointer, keyboard, and semantics each activate once', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      var count = 0;

      await tester.pumpWidget(
        _app(
          SocialLoginButton(
            provider: SocialLoginProvider.google,
            logo: const SizedBox(),
            onPressed: () => count++,
          ),
        ),
      );

      await tester.tap(find.byType(TextButton));
      await tester.pump();
      expect(count, 1);

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(count, 2);

      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(count, 3);

      final node = tester.getSemantics(find.byType(TextButton));
      node.owner!.performAction(node.id, SemanticsAction.tap);
      await tester.pump();
      expect(count, 4);
      semantics.dispose();
    });

    testWidgets(
      'disabled blocks all input and re-enabling restores activation',
      (tester) async {
        final semantics = tester.ensureSemantics();
        var count = 0;

        await tester.pumpWidget(
          _app(
            const SocialLoginButton(
              provider: SocialLoginProvider.google,
              logo: SizedBox(),
              onPressed: null,
            ),
          ),
        );

        await tester.tap(find.byType(TextButton));
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.sendKeyEvent(LogicalKeyboardKey.space);
        await tester.pump();
        expect(count, 0);

        final disabledNode = tester.getSemantics(find.byType(TextButton));
        final disabledData = disabledNode.getSemanticsData();
        expect(disabledData.hasFlag(SemanticsFlag.hasEnabledState), isTrue);
        expect(disabledData.hasFlag(SemanticsFlag.isEnabled), isFalse);
        expect(disabledData.hasAction(SemanticsAction.tap), isFalse);

        await tester.pumpWidget(
          _app(
            SocialLoginButton(
              provider: SocialLoginProvider.google,
              logo: const SizedBox(),
              onPressed: () => count++,
            ),
          ),
        );
        await tester.tap(find.byType(TextButton));
        await tester.pump();
        expect(count, 1);
        semantics.dispose();
      },
    );

    testWidgets('has one labelled button node and excludes logo semantics', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();

      await tester.pumpWidget(
        _app(
          SocialLoginButton(
            provider: SocialLoginProvider.google,
            logo: Semantics(label: 'logo semantics', child: const SizedBox()),
            onPressed: _noop,
          ),
        ),
      );

      final node = tester.getSemantics(find.byType(TextButton));
      final data = node.getSemanticsData();
      expect(data.label, 'Sign in with Google');
      expect(data.hasFlag(SemanticsFlag.isButton), isTrue);
      expect(data.hasFlag(SemanticsFlag.hasEnabledState), isTrue);
      expect(data.hasFlag(SemanticsFlag.isEnabled), isTrue);
      expect(data.hasAction(SemanticsAction.tap), isTrue);
      expect(find.bySemanticsLabel('logo semantics'), findsNothing);
      expect(find.bySemanticsLabel('Sign in with Google'), findsOneWidget);
      semantics.dispose();
    });

    testWidgets('circle uses visual label override as its default name', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();

      await tester.pumpWidget(
        _app(
          const SocialLoginButton(
            provider: SocialLoginProvider.google,
            logo: SizedBox(),
            onPressed: _noop,
            shape: SocialLoginButtonShape.circle,
            label: 'Custom circle',
          ),
        ),
      );

      expect(find.text('Custom circle'), findsNothing);
      expect(find.bySemanticsLabel('Custom circle'), findsOneWidget);
      expect(
        tester.widget<Tooltip>(find.byType(Tooltip)).message,
        'Custom circle',
      );
      semantics.dispose();
    });
  });

  group('layout and visual states', () {
    testWidgets('rectangle respects finite widths and minimum height', (
      tester,
    ) async {
      for (final width in [96.0, 160.0, 320.0]) {
        await tester.pumpWidget(
          _app(
            Center(
              child: SizedBox(
                width: width,
                child: const SocialLoginButton(
                  provider: SocialLoginProvider.google,
                  logo: SizedBox(),
                  onPressed: _noop,
                ),
              ),
            ),
          ),
        );

        final size = tester.getSize(find.byType(TextButton));
        expect(size.width, width);
        expect(size.height, greaterThanOrEqualTo(48));
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('rectangle prefers 280 width in an unbounded row', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          const Row(
            children: [
              SocialLoginButton(
                provider: SocialLoginProvider.google,
                logo: SizedBox(),
                onPressed: _noop,
              ),
            ],
          ),
        ),
      );

      expect(tester.getSize(find.byType(TextButton)).width, 280);
      expect(tester.takeException(), isNull);
    });

    testWidgets('long labels ellipsize and scaled text grows vertically', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          const SizedBox(
            width: 96,
            child: SocialLoginButton(
              provider: SocialLoginProvider.google,
              logo: SizedBox(),
              onPressed: _noop,
              label: 'A deliberately very long custom label',
            ),
          ),
        ),
      );
      final text = tester.widget<Text>(
        find.text('A deliberately very long custom label'),
      );
      expect(text.maxLines, 1);
      expect(text.overflow, TextOverflow.ellipsis);
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(
        _app(
          const SizedBox(
            width: 320,
            child: SocialLoginButton(
              provider: SocialLoginProvider.google,
              logo: SizedBox(),
              onPressed: _noop,
              label: 'Scaled label',
            ),
          ),
          textScaler: const TextScaler.linear(2),
        ),
      );
      expect(tester.getSize(find.byType(TextButton)).height, greaterThan(48));
      expect(tester.takeException(), isNull);
    });

    testWidgets('circle keeps a 48 square surface in a wide parent', (
      tester,
    ) async {
      for (final provider in const [
        SocialLoginProvider.google,
        SocialLoginProvider.kakao,
      ]) {
        await tester.pumpWidget(
          _app(
            SizedBox(
              width: 320,
              child: SocialLoginButton(
                provider: provider,
                logo: const SizedBox(),
                onPressed: _noop,
                shape: SocialLoginButtonShape.circle,
              ),
            ),
          ),
        );

        expect(tester.getSize(find.byType(TextButton)), const Size.square(48));
        expect(
          tester
              .widget<TextButton>(find.byType(TextButton))
              .style!
              .shape!
              .resolve({}),
          isA<CircleBorder>(),
        );
      }
    });

    testWidgets('resolved state palettes retain text contrast', (tester) async {
      final disabledBackgrounds = <Color>{};
      final disabledForegrounds = <Color>{};
      final disabledBorders = <Color>{};
      for (final provider in SocialLoginProvider.values) {
        await tester.pumpWidget(
          _app(
            SocialLoginButton(
              provider: provider,
              logo: const SizedBox(),
              onPressed: _noop,
            ),
          ),
        );

        final style = tester.widget<TextButton>(find.byType(TextButton)).style!;
        for (final states in const [
          <WidgetState>{},
          {WidgetState.hovered},
          {WidgetState.focused},
          {WidgetState.pressed},
        ]) {
          final base = style.backgroundColor!.resolve(states)!;
          final overlay = style.overlayColor!.resolve(states);
          final background =
              overlay == null ? base : Color.alphaBlend(overlay, base);
          final foreground = style.foregroundColor!.resolve(states)!;

          final ratio = _contrastRatio(
            foreground: foreground,
            background: background,
          );
          if ({
            SocialLoginProvider.line,
            SocialLoginProvider.naver,
            SocialLoginProvider.vk,
          }.contains(provider)) {
            expect(
              ratio,
              lessThan(4.5),
              reason:
                  '${provider.name} intentionally preserves provider colors',
            );
          } else {
            expect(
              ratio,
              greaterThanOrEqualTo(4.5),
              reason: '${provider.name} failed for $states',
            );
          }
        }

        final focusedSide = style.side!.resolve({WidgetState.focused})!;
        expect(focusedSide.width, 2);
        expect(
          focusedSide.color,
          socialLoginProviderData(provider).foregroundColor,
        );
        final data = socialLoginProviderData(provider);
        final compositedForeground =
            Color.alphaBlend(data.foregroundColor, data.backgroundColor);
        const disabled = {WidgetState.disabled};
        final disabledBackground = style.backgroundColor!.resolve(disabled)!;
        final disabledForeground = style.foregroundColor!.resolve(disabled)!;
        final disabledBorder = style.side!.resolve(disabled)!;
        if (provider == SocialLoginProvider.line) {
          expect(disabledBackground, const Color(0xFFFFFFFF));
          expect(disabledForeground, const Color(0x331E1E1E));
          expect(disabledBorder.color, const Color(0x99E5E5E5));
        } else if (provider == SocialLoginProvider.naver) {
          expect(disabledBackground, const Color(0xFF039B47));
          expect(disabledForeground, const Color(0xFFF7FCFA));
        } else if (provider == SocialLoginProvider.vk) {
          expect(disabledBackground, const Color(0xFF006DEB));
          expect(disabledForeground, const Color(0xFFF7FBFF));
        } else {
          expect(
            disabledBackground,
            Color.lerp(data.backgroundColor, compositedForeground, 0.08),
          );
          expect(
            disabledForeground,
            Color.lerp(compositedForeground, data.backgroundColor, 0.12),
          );
          expect(
            disabledBorder.color,
            Color.lerp(
              data.borderColor ?? compositedForeground,
              disabledBackground,
              0.5,
            ),
          );
        }
        expect(disabledBackground, isNot(data.backgroundColor));
        expect(disabledForeground, isNot(data.foregroundColor));
        expect(disabledBorder.width, 1);
        expect(style.overlayColor!.resolve(disabled), isNull);
        expect(style.overlayColor!.resolve({
          WidgetState.disabled, WidgetState.focused, WidgetState.pressed,
        }), isNull);
        final disabledContrast = _contrastRatio(
          foreground: disabledForeground,
          background: disabledBackground,
        );
        if (provider == SocialLoginProvider.line) {
          expect(disabledContrast, lessThan(3));
        } else {
          expect(
            disabledContrast,
            greaterThanOrEqualTo(3),
            reason: '${provider.name} disabled text must remain readable',
          );
        }
        disabledBackgrounds.add(disabledBackground);
        disabledForegrounds.add(disabledForeground);
        disabledBorders.add(disabledBorder.color);
      }
      // Shared monochrome identities may coincide, but states cannot collapse
      // to one global grey palette for all the distinct service colors.
      expect(disabledBackgrounds.length, greaterThanOrEqualTo(25));
      expect(disabledForegrounds.length, greaterThanOrEqualTo(25));
      expect(disabledBorders.length, greaterThanOrEqualTo(25));
    });
  });
}

void _noop() {}

Widget _app(Widget child, {TextScaler textScaler = TextScaler.noScaling}) {
  return MaterialApp(
    home: MediaQuery(
      data: MediaQueryData(textScaler: textScaler),
      child: Scaffold(body: child),
    ),
  );
}

Widget _withLocale(Locale locale, Widget child) {
  return Localizations(
    locale: locale,
    delegates: const [DefaultWidgetsLocalizations.delegate],
    child: child,
  );
}

double _contrastRatio({required Color foreground, required Color background}) {
  final composited = Color.alphaBlend(foreground, background);
  final foregroundLuminance = composited.computeLuminance();
  final backgroundLuminance = background.computeLuminance();
  final lighter =
      foregroundLuminance > backgroundLuminance
          ? foregroundLuminance
          : backgroundLuminance;
  final darker =
      foregroundLuminance > backgroundLuminance
          ? backgroundLuminance
          : foregroundLuminance;

  return (lighter + 0.05) / (darker + 0.05);
}

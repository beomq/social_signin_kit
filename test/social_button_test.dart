import 'dart:convert';
import 'dart:ui' show SemanticsAction, SemanticsFlag;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:social_signin_kit/social_signin_kit.dart';

const _appLogo = 'images/app-logo.png';

void main() {
  testWidgets(
    'explicit wide app mark ratios use proportional slots and square circles',
    (tester) async {
      for (final (social, ratio) in [
        (Social.zoom, 1426 / 321),
        (Social.steam, 278 / 84),
      ]) {
        await _pump(
          tester,
          SocialButton(
            logo: _appLogo,
            social: social,
            logoAspectRatio: ratio,
            onPressed: _noop,
          ),
        );
        final image = tester.widget<Image>(find.byType(Image));
        final dimensions = tester.getSize(find.byType(Image));
        expect(image.color, isNull);
        expect(dimensions.width / dimensions.height, closeTo(ratio, 0.001));

        await _pump(
          tester,
          SocialButton(
            logo: _appLogo,
            social: social,
            logoAspectRatio: ratio,
            shape: SocialButtonShape.circle,
            onPressed: _noop,
          ),
        );
        final circular = tester.getSize(find.byType(Image));
        expect(circular.width, circular.height);
        expect(tester.takeException(), isNull);
      }
    },
  );

  testWidgets('default ratios are square even for wide-mark providers', (
    tester,
  ) async {
    for (final social in [Social.zoom, Social.steam]) {
      await _pump(
        tester,
        SocialButton(social: social, logo: _appLogo, onPressed: _noop),
      );
      final size = tester.getSize(find.byType(Image));
      expect(size.width, size.height);
    }
  });

  testWidgets('regular slots use explicit positive finite ratios', (
    tester,
  ) async {
    for (final shape in [SocialButtonShape.rounded, SocialButtonShape.pill]) {
      for (final ratio in [0.5, 1.0, 2.0]) {
        await _pump(
          tester,
          SocialButton(
            social: Social.google,
            logo: _appLogo,
            logoAspectRatio: ratio,
            shape: shape,
            onPressed: _noop,
          ),
        );
        final image = tester.widget<Image>(find.byType(Image));
        final size = tester.getSize(find.byType(Image));
        expect(size.height, 20);
        expect(size.width / size.height, ratio);
        expect(image.fit, BoxFit.contain);
        expect(tester.takeException(), isNull);
      }
    }
  });

  testWidgets('rejects blank app logo paths', (tester) async {
    for (final logo in ['', ' ', '\t\n']) {
      await tester.pumpWidget(
        _app(
          SocialButton(social: Social.google, logo: logo, onPressed: _noop),
          bundle: _LogoBundle(),
        ),
      );
      expect(tester.takeException(), isAssertionError);
    }
  });

  testWidgets('rejects nonpositive and nonfinite logo ratios', (tester) async {
    for (final ratio in [
      0.0,
      -1.0,
      double.nan,
      double.infinity,
      double.negativeInfinity,
    ]) {
      await tester.pumpWidget(
        _app(
          SocialButton(
            social: Social.google,
            logo: _appLogo,
            logoAspectRatio: ratio,
            onPressed: _noop,
          ),
          bundle: _LogoBundle(),
        ),
      );
      expect(tester.takeException(), isAssertionError);
    }
  });

  testWidgets('provider typography keeps app font without theme foreground', (
    tester,
  ) async {
    await tester.pumpWidget(
      DefaultAssetBundle(
        bundle: _LogoBundle(),
        child: MaterialApp(
          theme: ThemeData(
            fontFamily: 'ApplicationFont',
            textTheme: const TextTheme(
              labelLarge: TextStyle(color: Colors.red),
            ),
          ),
          home: const Scaffold(
            body: SocialButton(
              logo: _appLogo,
              social: Social.notion,
              onPressed: _noop,
            ),
          ),
        ),
      ),
    );
    await _decode(tester);
    final button = tester.widget<TextButton>(find.byType(TextButton));
    expect(button.style!.textStyle!.resolve({})!.fontFamily, 'ApplicationFont');
    expect(
      button.style!.textStyle!.resolve({})!.color,
      socialLoginProviderData(Social.notion).foregroundColor,
    );
    expect(
      button.style!.foregroundColor!.resolve({}),
      socialLoginProviderData(Social.notion).foregroundColor,
    );
    expect(
      button.style!.textStyle!.resolve({WidgetState.disabled})!.color,
      button.style!.foregroundColor!.resolve({WidgetState.disabled}),
    );
  });

  testWidgets('every provider and shape loads the consuming app asset', (
    tester,
  ) async {
    final bundle = _LogoBundle();
    for (final social in Social.values) {
      for (final shape in SocialButtonShape.values) {
        await _pump(
          tester,
          SocialButton(
            social: social,
            logo: _appLogo,
            shape: shape,
            onPressed: _noop,
          ),
          bundle: bundle,
        );
        final image = tester.widget<Image>(find.byType(Image));
        final asset = image.image as AssetImage;
        expect(asset.assetName, _appLogo);
        expect(asset.package, isNull);
        expect(image.fit, BoxFit.contain);
        expect(image.color, isNull);
        expect(image.excludeFromSemantics, isTrue);
        expect(find.byType(RawImage), findsOneWidget);
        expect(tester.widget<RawImage>(find.byType(RawImage)).image, isNotNull);
        expect(tester.takeException(), isNull);
      }
    }
    expect(bundle.requested.where((key) => key.endsWith('.png')).toSet(), {
      _appLogo,
    });
  });

  testWidgets('caller asset path loads without a package key', (tester) async {
    final bundle = _LogoBundle();
    await _pump(
      tester,
      const SocialButton(
        social: Social.notion,
        logo: 'images/custom.png',
        onPressed: _noop,
      ),
      bundle: bundle,
    );
    final asset = tester.widget<Image>(find.byType(Image)).image as AssetImage;
    expect(asset.assetName, 'images/custom.png');
    expect(asset.package, isNull);
    expect(bundle.requested, contains('images/custom.png'));
    expect(
      bundle.requested,
      isNot(contains('packages/social_signin_kit/assets/social/notion.png')),
    );
  });

  testWidgets('missing app assets report the expected path', (tester) async {
    for (final path in [_appLogo, 'missing/custom.png']) {
      final bundle = _LogoBundle(missing: {path});
      await tester.pumpWidget(
        _app(
          SocialButton(social: Social.google, logo: path, onPressed: _noop),
          bundle: bundle,
        ),
      );
      await _decode(tester);
      final error = tester.takeException();
      expect(error, isA<FlutterError>());
      expect(error.toString(), contains(path));
      expect(find.byIcon(Icons.person_outline), findsNothing);
      expect(find.byType(ErrorWidget), findsNothing);
      expect(find.byIcon(Icons.broken_image_outlined), findsOneWidget);
      expect(tester.getSize(find.byType(Image)), const Size.square(20));
      expect(tester.getSize(find.byType(TextButton)).height, 48);
      expect(
        tester.widget<Tooltip>(find.byType(Tooltip)).message,
        contains(path),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('app locale changes rebuild labels and circle tooltips', (
    tester,
  ) async {
    const button = SocialButton(
      logo: _appLogo,
      social: Social.notion,
      onPressed: _noop,
    );
    for (final locale in const [
      Locale('ko', 'KR'),
      Locale('en'),
      Locale('ja'),
    ]) {
      await _pump(tester, button, locale: locale);
      expect(
        find.text(socialLoginProviderData(Social.notion).labelFor(locale)),
        findsOneWidget,
      );
    }
    const circle = SocialButton(
      logo: _appLogo,
      social: Social.notion,
      shape: SocialButtonShape.circle,
      onPressed: _noop,
    );
    for (final locale in const [Locale('ko'), Locale('en')]) {
      await _pump(tester, circle, locale: locale);
      expect(
        tester.widget<Tooltip>(find.byType(Tooltip)).message,
        socialLoginProviderData(Social.notion).labelFor(locale),
      );
    }
  });

  testWidgets('explicit locale and labels win over list and app locales', (
    tester,
  ) async {
    await _pump(
      tester,
      const SocialButtonList.vertical(
        locale: Locale('ko'),
        items: [
          SocialButton(
            logo: _appLogo,
            social: Social.google,
            locale: Locale('ja'),
            onPressed: _noop,
          ),
          SocialButton(
            logo: _appLogo,
            social: Social.notion,
            label: 'Custom action',
            semanticLabel: 'Accessible action',
            onPressed: _noop,
          ),
        ],
      ),
      locale: const Locale('ko'),
    );
    expect(
      find.text(socialLoginProviderData(Social.google).labelEn),
      findsOneWidget,
    );
    expect(find.text('Custom action'), findsOneWidget);
    final semantics = tester.ensureSemantics();
    expect(find.bySemanticsLabel('Accessible action'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('defaults are rounded and 48 with no localizations', (
    tester,
  ) async {
    final bundle = _LogoBundle();
    await tester.pumpWidget(
      DefaultAssetBundle(
        bundle: bundle,
        child: const MediaQuery(
          data: MediaQueryData(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Material(
              child: Center(
                child: SocialButton(
                  logo: _appLogo,
                  social: Social.notion,
                  onPressed: _noop,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await _decode(tester);
    final style = tester.widget<TextButton>(find.byType(TextButton)).style!;
    expect(style.shape!.resolve({}), isA<RoundedRectangleBorder>());
    expect(style.minimumSize!.resolve({}), const Size(0, 48));
    expect(
      find.text(socialLoginProviderData(Social.notion).labelEn),
      findsOneWidget,
    );
  });

  testWidgets(
    'explicit default-valued settings beat non-default list settings',
    (tester) async {
      const inheritedKey = ValueKey('inherited');
      const explicitKey = ValueKey('explicit');
      const inherited = SocialButton(
        logo: _appLogo,
        key: inheritedKey,
        social: Social.notion,
        onPressed: _noop,
      );
      for (final size in [64.0, 72.0]) {
        await _pump(
          tester,
          SocialButtonList.horizontal(
            shape: SocialButtonShape.pill,
            size: size,
            locale: const Locale('ko'),
            items: const [
              inherited,
              SocialButton(
                logo: _appLogo,
                key: explicitKey,
                social: Social.google,
                shape: SocialButtonShape.rounded,
                size: 48,
                locale: Locale('en'),
                onPressed: _noop,
              ),
            ],
          ),
        );
        final inheritedStyle = _style(tester, inheritedKey);
        expect(inheritedStyle.shape!.resolve({}), isA<StadiumBorder>());
        expect(inheritedStyle.minimumSize!.resolve({})!.height, size);
        final explicitStyle = _style(tester, explicitKey);
        expect(explicitStyle.shape!.resolve({}), isA<RoundedRectangleBorder>());
        expect(explicitStyle.minimumSize!.resolve({})!.height, 48);
        expect(
          find.text(socialLoginProviderData(Social.notion).labelKo),
          findsOneWidget,
        );
        expect(
          find.text(socialLoginProviderData(Social.google).labelEn),
          findsOneWidget,
        );
        expect(tester.widget(find.byKey(inheritedKey)), same(inherited));
      }
    },
  );

  testWidgets('appearance inherits from lists and explicit values win', (
    tester,
  ) async {
    const inheritedKey = ValueKey('appearance-inherited');
    const explicitKey = ValueKey('appearance-explicit');
    await _pump(
      tester,
      const SocialButtonList.vertical(
        appearance: SocialButtonAppearance.dark,
        items: [
          SocialButton(
            logo: _appLogo,
            key: inheritedKey,
            social: Social.google,
            onPressed: _noop,
          ),
          SocialButton(
            logo: _appLogo,
            key: explicitKey,
            social: Social.google,
            appearance: SocialButtonAppearance.light,
            onPressed: _noop,
          ),
        ],
      ),
    );

    final inheritedStyle = _style(tester, inheritedKey);
    expect(
      inheritedStyle.backgroundColor!.resolve({}),
      const Color(0xFF131314),
    );
    expect(
      inheritedStyle.foregroundColor!.resolve({}),
      const Color(0xFFE3E3E3),
    );
    final explicitStyle = _style(tester, explicitKey);
    expect(explicitStyle.backgroundColor!.resolve({}), const Color(0xFFFFFFFF));
    expect(explicitStyle.foregroundColor!.resolve({}), const Color(0xFF1F1F1F));
  });

  testWidgets('unsupported appearance reports once and retains defaults', (
    tester,
  ) async {
    final messages = <String?>[];
    final originalDebugPrint = debugPrint;
    debugPrint = (String? message, {int? wrapWidth}) => messages.add(message);
    addTearDown(() => debugPrint = originalDebugPrint);
    for (var index = 0; index < 2; index++) {
      await _pump(
        tester,
        SocialButton(
          logo: _appLogo,
          key: ValueKey(index),
          social: Social.pinterest,
          appearance: SocialButtonAppearance.dark,
          onPressed: _noop,
        ),
      );
      final style = tester.widget<TextButton>(find.byType(TextButton)).style!;
      expect(
        style.backgroundColor!.resolve({}),
        socialLoginProviderData(Social.pinterest).backgroundColor,
      );
    }
    expect(messages, hasLength(1));
    expect(messages.single, contains('pinterest'));
    expect(messages.single, contains('dark'));
    expect(messages.single, contains('providerDefault'));
    await _pump(
      tester,
      const SocialButton(
        logo: _appLogo,
        social: Social.github,
        appearance: SocialButtonAppearance.dark,
        onPressed: _noop,
      ),
    );
    expect(messages, hasLength(1));
    debugPrint = originalDebugPrint;
  });

  testWidgets('unsupported appearances resolve to provider defaults', (
    tester,
  ) async {
    for (final appearance in const [
      SocialButtonAppearance.light,
      SocialButtonAppearance.dark,
    ]) {
      await _pump(
        tester,
        SocialButton(
          logo: _appLogo,
          social: Social.notion,
          appearance: appearance,
          onPressed: _noop,
        ),
      );
      final style = tester.widget<TextButton>(find.byType(TextButton)).style!;
      expect(
        style.backgroundColor!.resolve({}),
        socialLoginProviderData(Social.notion).backgroundColor,
      );
      expect(
        style.foregroundColor!.resolve({}),
        socialLoginProviderData(Social.notion).foregroundColor,
      );
    }
  });

  testWidgets('source-backed light and dark palettes resolve all states', (
    tester,
  ) async {
    const expected = {
      Social.microsoft: {
        SocialButtonAppearance.light: [
          Color(0xFFFFFFFF),
          Color(0xFF5E5E5E),
          Color(0xFF8C8C8C),
        ],
        SocialButtonAppearance.dark: [
          Color(0xFF2F2F2F),
          Color(0xFFFFFFFF),
          null,
        ],
      },
      Social.slack: {
        SocialButtonAppearance.light: [
          Color(0xFFFFFFFF),
          Color(0xFF000000),
          Color(0xFFDDDDDD),
        ],
        SocialButtonAppearance.dark: [
          Color(0xFF4A154B),
          Color(0xFFFFFFFF),
          null,
        ],
      },
      Social.google: {
        SocialButtonAppearance.light: [
          Color(0xFFFFFFFF),
          Color(0xFF1F1F1F),
          Color(0xFF747775),
        ],
        SocialButtonAppearance.dark: [
          Color(0xFF131314),
          Color(0xFFE3E3E3),
          Color(0xFF8E918F),
        ],
      },
      Social.apple: {
        SocialButtonAppearance.light: [
          Color(0xFFFFFFFF),
          Color(0xFF000000),
          null,
        ],
        SocialButtonAppearance.dark: [
          Color(0xFF000000),
          Color(0xFFFFFFFF),
          null,
        ],
      },
    };

    for (final providerEntry in expected.entries) {
      for (final appearanceEntry in providerEntry.value.entries) {
        await _pump(
          tester,
          SocialButton(
            logo: _appLogo,
            social: providerEntry.key,
            appearance: appearanceEntry.key,
            onPressed: _noop,
          ),
        );
        final style = tester.widget<TextButton>(find.byType(TextButton)).style!;
        final colors = appearanceEntry.value;
        expect(style.backgroundColor!.resolve({}), colors[0]);
        expect(style.foregroundColor!.resolve({}), colors[1]);
        final side = style.side!.resolve({})!;
        expect(side == BorderSide.none ? null : side.color, colors[2]);
        expect(
          style.backgroundColor!.resolve({WidgetState.disabled}),
          isNot(colors[0]),
        );
        expect(style.overlayColor!.resolve({WidgetState.hovered}), isNotNull);
        expect(style.overlayColor!.resolve({WidgetState.pressed}), isNotNull);
      }
    }
  });

  testWidgets('app logos stay untinted across appearances and enabled states', (
    tester,
  ) async {
    final bundle = _LogoBundle();
    for (final social in Social.values) {
      for (final appearance in SocialButtonAppearance.values) {
        for (final enabled in [true, false]) {
          await _pump(
            tester,
            SocialButton(
              social: social,
              logo: _appLogo,
              appearance: appearance,
              onPressed: enabled ? _noop : null,
            ),
            bundle: bundle,
          );
          final image = tester.widget<Image>(find.byType(Image));
          final asset = image.image as AssetImage;
          expect(asset.assetName, _appLogo);
          expect(asset.package, isNull);
          expect(image.color, isNull);
          expect(image.colorBlendMode, isNull);
          expect(image.fit, BoxFit.contain);
          expect(find.byType(ColorFiltered), findsNothing);
          expect(
            find.ancestor(
              of: find.byType(Image),
              matching: find.byType(ColoredBox),
            ),
            findsNothing,
          );
          expect(
            tester.widget<RawImage>(find.byType(RawImage)).image,
            isNotNull,
          );
          expect(tester.takeException(), isNull);
        }
      }
    }
    expect(bundle.requested.where((key) => key.endsWith('.png')).toSet(), {
      _appLogo,
    });
  });

  testWidgets('restricted metadata warns while requested shapes render', (
    tester,
  ) async {
    await _pump(
      tester,
      const SocialButton(
        logo: _appLogo,
        social: Social.kakao,
        shape: SocialButtonShape.pill,
        onPressed: _noop,
      ),
    );
    expect(
      tester
          .widget<TextButton>(find.byType(TextButton))
          .style!
          .shape!
          .resolve({}),
      isA<StadiumBorder>(),
    );

    await _pump(
      tester,
      const SocialButtonList.horizontal(
        items: [
          SocialButton(logo: _appLogo, social: Social.kakao, onPressed: _noop),
        ],
      ),
    );
    expect(
      tester
          .widget<TextButton>(find.byType(TextButton))
          .style!
          .shape!
          .resolve({}),
      isA<CircleBorder>(),
    );
    expect(find.byType(Tooltip), findsOneWidget);
  });

  testWidgets(
    'inherited settings update for identical const button instances',
    (tester) async {
      const items = [
        SocialButton(logo: _appLogo, social: Social.notion, onPressed: _noop),
      ];
      await _pump(
        tester,
        const SocialButtonList.vertical(locale: Locale('ko'), items: items),
      );
      expect(
        find.text(socialLoginProviderData(Social.notion).labelKo),
        findsOneWidget,
      );
      await _pump(
        tester,
        const SocialButtonList.horizontal(
          size: 64,
          locale: Locale('en'),
          items: items,
        ),
      );
      final style = tester.widget<TextButton>(find.byType(TextButton)).style!;
      expect(style.shape!.resolve({}), isA<CircleBorder>());
      expect(tester.getSize(find.byType(TextButton)), const Size.square(64));
      expect(
        tester.widget<Tooltip>(find.byType(Tooltip)).message,
        socialLoginProviderData(Social.notion).labelEn,
      );
    },
  );

  testWidgets('vertical list has equal widths, spacing, and explicit circles', (
    tester,
  ) async {
    await _pump(
      tester,
      const SizedBox(
        width: 240,
        child: SocialButtonList.vertical(
          spacing: 13,
          items: [
            SocialButton(
              logo: _appLogo,
              social: Social.notion,
              onPressed: _noop,
            ),
            SocialButton(
              logo: _appLogo,
              social: Social.google,
              label: 'G',
              onPressed: _noop,
            ),
            SocialButton(
              logo: _appLogo,
              social: Social.github,
              shape: SocialButtonShape.circle,
              size: 60,
              onPressed: _noop,
            ),
          ],
        ),
      ),
    );
    final buttons = find.byType(TextButton);
    expect(tester.getSize(buttons.at(0)).width, 240);
    expect(tester.getSize(buttons.at(1)).width, 240);
    expect(
      tester.getTopLeft(buttons.at(1)).dy -
          tester.getBottomLeft(buttons.at(0)).dy,
      13,
    );
    expect(tester.getSize(buttons.at(2)), const Size.square(60));
  });

  testWidgets('horizontal circle list wraps with both-axis spacing', (
    tester,
  ) async {
    const items = [
      SocialButton(logo: _appLogo, social: Social.notion, onPressed: _noop),
      SocialButton(logo: _appLogo, social: Social.google, onPressed: _noop),
      SocialButton(logo: _appLogo, social: Social.github, onPressed: _noop),
    ];
    for (final width in [200.0, 110.0]) {
      await _pump(
        tester,
        SizedBox(
          width: width,
          child: const SocialButtonList.horizontal(spacing: 10, items: items),
        ),
      );
      final buttons = find.byType(TextButton);
      for (var index = 0; index < 3; index++) {
        expect(tester.getSize(buttons.at(index)), const Size.square(48));
      }
      expect(
        tester.getTopLeft(buttons.at(1)).dx -
            tester.getTopRight(buttons.at(0)).dx,
        10,
      );
      expect(
        tester.getTopLeft(buttons.at(2)).dy -
            tester.getTopLeft(buttons.at(0)).dy,
        width == 110 ? 58 : 0,
      );
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('lists survive unbounded width, empty items, and scaled labels', (
    tester,
  ) async {
    for (final vertical in [true, false]) {
      final items = [
        const SocialButton(
          logo: _appLogo,
          social: Social.notion,
          label: 'An unusually long accessible action label',
          onPressed: _noop,
        ),
        const SocialButton(
          logo: _appLogo,
          social: Social.google,
          onPressed: _noop,
        ),
      ];
      final list =
          vertical
              ? SocialButtonList.vertical(items: items)
              : SocialButtonList.horizontal(
                shape: SocialButtonShape.pill,
                items: items,
              );
      await _pump(tester, Row(children: [list]));
      expect(tester.takeException(), isNull);
      if (vertical) {
        expect(tester.getSize(find.byType(TextButton).first).width, 280);
      }
      await _pump(
        tester,
        SizedBox(width: 160, child: list),
        textScaler: const TextScaler.linear(2),
      );
      expect(
        tester.getSize(find.byType(TextButton).first).height,
        greaterThan(48),
      );
      expect(tester.takeException(), isNull);
    }
    await _pump(
      tester,
      const Column(
        children: [
          SocialButtonList.vertical(items: []),
          SocialButtonList.horizontal(items: []),
        ],
      ),
    );
    expect(find.byType(TextButton), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('circle sizes below 48 keep an accessible touch target', (
    tester,
  ) async {
    await _pump(
      tester,
      const SocialButton(
        logo: _appLogo,
        social: Social.notion,
        size: 32,
        shape: SocialButtonShape.circle,
        onPressed: _noop,
      ),
    );
    final style = tester.widget<TextButton>(find.byType(TextButton)).style!;
    expect(style.fixedSize!.resolve({}), const Size.square(32));
    expect(tester.getSize(find.byType(TextButton)), const Size.square(48));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'new buttons expose one action and respect disabled transitions',
    (tester) async {
      final semantics = tester.ensureSemantics();
      var count = 0;
      for (final enabled in [true, false, true]) {
        await _pump(
          tester,
          SocialButton(
            logo: _appLogo,
            social: Social.notion,
            onPressed: enabled ? () => count++ : null,
            label: 'Unique action',
            shape: SocialButtonShape.circle,
          ),
        );
        final before = count;
        final node = tester.getSemantics(find.byType(TextButton));
        final data = node.getSemanticsData();
        expect(data.label, 'Unique action');
        expect(data.hasFlag(SemanticsFlag.isButton), isTrue);
        expect(data.hasFlag(SemanticsFlag.isEnabled), enabled);
        expect(data.hasAction(SemanticsAction.tap), enabled);
        expect(find.bySemanticsLabel('Unique action'), findsOneWidget);
        await tester.tap(find.byType(TextButton));
        await tester.pump();
        expect(count, before + (enabled ? 1 : 0));
        if (enabled) {
          node.owner!.performAction(node.id, SemanticsAction.tap);
          await tester.pump();
          expect(count, before + 2);
        }
      }
      semantics.dispose();
    },
  );

  testWidgets(
    'hover press focus and disabled resolve distinct package states',
    (tester) async {
      for (final social in Social.values) {
        await _pump(
          tester,
          SocialButton(logo: _appLogo, social: social, onPressed: _noop),
        );
        final style = tester.widget<TextButton>(find.byType(TextButton)).style!;
        final base = style.backgroundColor!.resolve({})!;
        final hover = style.overlayColor!.resolve({WidgetState.hovered})!;
        final pressed = style.overlayColor!.resolve({WidgetState.pressed})!;
        if (social == Social.vk) {
          expect(Color.alphaBlend(hover, base), base);
          expect(
            style.backgroundColor!.resolve({WidgetState.hovered})!.a,
            closeTo(0.8, 0.001),
          );
          expect(
            style.backgroundColor!.resolve({WidgetState.pressed})!.a,
            closeTo(0.7, 0.001),
          );
        } else {
          expect(
            Color.alphaBlend(hover, base),
            isNot(base),
            reason: social.name,
          );
          expect(pressed, isNot(hover));
        }
        expect(
          style.overlayColor!.resolve({
            WidgetState.hovered,
            WidgetState.focused,
            WidgetState.pressed,
          }),
          pressed,
        );
        expect(style.side!.resolve({WidgetState.focused})!.width, 2);
        expect(
          style.overlayColor!.resolve({
            WidgetState.disabled,
            WidgetState.pressed,
            WidgetState.focused,
          }),
          isNull,
        );
      }
    },
  );

  testWidgets('LINE uses its documented states and separator', (tester) async {
    await _pump(
      tester,
      const SocialButton(logo: _appLogo, social: Social.line, onPressed: _noop),
    );
    final style = tester.widget<TextButton>(find.byType(TextButton)).style!;

    expect(
      Color.alphaBlend(
        style.overlayColor!.resolve({WidgetState.hovered})!,
        const Color(0xFF06C755),
      ),
      Color.alphaBlend(const Color(0x1A000000), const Color(0xFF06C755)),
    );
    expect(
      Color.alphaBlend(
        style.overlayColor!.resolve({WidgetState.pressed})!,
        const Color(0xFF06C755),
      ),
      Color.alphaBlend(const Color(0x4D000000), const Color(0xFF06C755)),
    );
    expect(
      style.backgroundColor!.resolve({WidgetState.disabled}),
      const Color(0xFFFFFFFF),
    );
    expect(
      style.foregroundColor!.resolve({WidgetState.disabled}),
      const Color(0x331E1E1E),
    );
    expect(
      style.side!.resolve({WidgetState.disabled})!.color,
      const Color(0x99E5E5E5),
    );
    expect(find.byKey(const ValueKey('line-separator')), findsOneWidget);
    final lineRow = tester.widget<Row>(find.byType(Row));
    final lineGaps = lineRow.children.whereType<SizedBox>().toList();
    expect(lineGaps, hasLength(2));
    for (final gap in lineGaps) {
      expect(gap.width, closeTo(48 * 4 / 11, 0.001));
    }

    await _pump(
      tester,
      const SocialButton(logo: _appLogo, social: Social.line, onPressed: null),
    );
    expect(tester.widget<Image>(find.byType(Image)).color, isNull);
    expect(
      tester
          .widget<Container>(find.byKey(const ValueKey('line-separator')))
          .color,
      const Color(0x99E5E5E5),
    );
  });

  testWidgets('provider metrics retain app logo geometry', (tester) async {
    await _pump(
      tester,
      const SocialButton(
        logo: _appLogo,
        social: Social.google,
        onPressed: _noop,
      ),
    );
    expect(tester.getSize(find.byType(Image)), const Size.square(20));
    final googleStyle =
        tester.widget<TextButton>(find.byType(TextButton)).style!;
    expect(googleStyle.textStyle!.resolve({})!.fontSize, 14);
    expect(googleStyle.textStyle!.resolve({})!.height, 20 / 14);
    expect(googleStyle.textStyle!.resolve({})!.fontWeight, FontWeight.w500);

    await _pump(
      tester,
      const SocialButton(
        logo: _appLogo,
        social: Social.microsoft,
        onPressed: _noop,
      ),
    );
    expect(tester.getSize(find.byType(Image)), const Size.square(21));

    await _pump(
      tester,
      const SocialButton(logo: _appLogo, social: Social.line, onPressed: _noop),
    );
    expect(tester.getSize(find.byType(Image)), const Size.square(30));

    await _pump(
      tester,
      const SocialButton(
        logo: _appLogo,
        social: Social.spotify,
        onPressed: _noop,
      ),
    );
    expect(tester.getSize(find.byType(Image)), const Size.square(24));
    expect(
      tester
          .widget<Row>(find.byType(Row))
          .children
          .whereType<SizedBox>()
          .single
          .width,
      12,
    );

    await _pump(
      tester,
      const SocialButton(
        logo: _appLogo,
        social: Social.naver,
        onPressed: _noop,
      ),
    );
    expect(
      tester.getSize(find.byType(Image)).width,
      greaterThanOrEqualTo(44.8),
    );
    final row = tester.widget<Row>(find.byType(Row));
    expect(row.children.whereType<SizedBox>().single.width, 8);
  });

  testWidgets('different app assets retain provider logo geometry', (
    tester,
  ) async {
    const expectedSizes = {
      Social.microsoft: 21.0,
      Social.line: 30.0,
      Social.kakao: 48.0,
      Social.naver: 45.0,
      Social.google: 20.0,
      Social.apple: 44.0,
      Social.spotify: 24.0,
      Social.notion: 24.0,
    };

    for (final entry in expectedSizes.entries) {
      Size? firstImageSize;
      for (final logo in [_appLogo, 'images/${entry.key.name}.png']) {
        await _pump(
          tester,
          SocialButton(social: entry.key, logo: logo, onPressed: _noop),
        );
        final imageSize = tester.getSize(find.byType(Image));
        firstImageSize ??= imageSize;
        expect(imageSize, firstImageSize, reason: entry.key.name);
        expect(imageSize, Size.square(entry.value), reason: entry.key.name);
      }
    }

    for (final logo in [_appLogo, 'images/google.png']) {
      await _pump(
        tester,
        SocialButton(social: Social.google, logo: logo, onPressed: _noop),
      );
      final row = tester.widget<Row>(find.byType(Row));
      expect(row.children.whereType<SizedBox>().single.width, 10);
    }

    for (final logo in [_appLogo, 'images/line.png']) {
      await _pump(
        tester,
        SocialButton(social: Social.line, logo: logo, onPressed: _noop),
      );
      final row = tester.widget<Row>(find.byType(Row));
      for (final gap in row.children.whereType<SizedBox>()) {
        expect(gap.width, closeTo(48 * 4 / 11, 0.001));
      }
    }
  });

  testWidgets('documented provider default radii are rendered', (tester) async {
    for (final entry
        in const {
          Social.kakao: 12.0,
          Social.apple: 15.0,
          Social.vk: 8.0,
        }.entries) {
      await _pump(
        tester,
        SocialButton(logo: _appLogo, social: entry.key, onPressed: _noop),
      );
      final shape =
          tester
                  .widget<TextButton>(find.byType(TextButton))
                  .style!
                  .shape!
                  .resolve({})!
              as RoundedRectangleBorder;
      expect(shape.borderRadius, BorderRadius.circular(entry.value));
    }
  });

  testWidgets('Apple remains responsive beyond generated endpoint widths', (
    tester,
  ) async {
    await _pump(
      tester,
      const SizedBox(
        width: 500,
        child: SocialButton(
          logo: _appLogo,
          social: Social.apple,
          onPressed: _noop,
        ),
      ),
    );
    expect(tester.getSize(find.byType(TextButton)).width, 500);
  });
}

void _noop() {}

ButtonStyle _style(WidgetTester tester, Key key) =>
    tester
        .widget<TextButton>(
          find.descendant(
            of: find.byKey(key),
            matching: find.byType(TextButton),
          ),
        )
        .style!;

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  _LogoBundle? bundle,
  Locale locale = const Locale('en'),
  TextScaler textScaler = TextScaler.noScaling,
}) async {
  await tester.pumpWidget(
    _app(
      child,
      bundle: bundle ?? _LogoBundle(),
      locale: locale,
      textScaler: textScaler,
    ),
  );
  await _decode(tester);
}

// Await the exact image-completion signal instead of a decoding delay.
Future<void> _decode(WidgetTester tester) async {
  await tester.runAsync(() async {
    for (final element in find.byType(Image).evaluate()) {
      await precacheImage(
        (element.widget as Image).image,
        element,
        onError: (error, stackTrace) {},
      ).timeout(const Duration(seconds: 10));
    }
  });
  await tester.pump();
}

Widget _app(
  Widget child, {
  required AssetBundle bundle,
  Locale locale = const Locale('en'),
  TextScaler textScaler = TextScaler.noScaling,
}) => MaterialApp(
  home: DefaultAssetBundle(
    bundle: bundle,
    child: Localizations(
      locale: locale,
      delegates: const [DefaultWidgetsLocalizations.delegate],
      child: MediaQuery(
        data: MediaQueryData(textScaler: textScaler),
        child: Scaffold(body: Center(child: child)),
      ),
    ),
  ),
);

class _LogoBundle extends CachingAssetBundle {
  _LogoBundle({this.missing = const {}});

  final Set<String> missing;
  final Set<String> requested = {};

  @override
  Future<ByteData> load(String key) async {
    requested.add(key);
    if (key == 'AssetManifest.bin') {
      return const StandardMessageCodec().encodeMessage(<String, Object?>{})!;
    }
    if (missing.contains(key)) throw FlutterError('Missing asset: $key');
    // A single transparent pixel, not a brand logo or a shipped package asset.
    return ByteData.sublistView(
      base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAACklEQVR4nGMA'
        'AQAABQABDQottAAAAABJRU5ErkJggg==',
      ),
    );
  }
}

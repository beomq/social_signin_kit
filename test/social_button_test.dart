import 'dart:convert';
import 'dart:io';
import 'dart:ui'
    show ImageByteFormat, SemanticsAction, SemanticsFlag, instantiateImageCodec;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:social_signin_kit/social_signin_kit.dart';

void main() {
  testWidgets('provider typography keeps app font without theme foreground', (
    tester,
  ) async {
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(
        fontFamily: 'ApplicationFont',
        textTheme: const TextTheme(
          labelLarge: TextStyle(color: Colors.red),
        ),
      ),
      home: const Scaffold(body: SocialButton(social: Social.notion, onPressed: _noop)),
    ));
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
      button.style!
          .textStyle!
          .resolve({WidgetState.disabled})!
          .color,
      button.style!.foregroundColor!.resolve({WidgetState.disabled}),
    );
  });

  final bundledLogoPaths = {
    for (final social in Social.values)
      social: social == Social.github
          ? 'assets/original/github/GitHub_Invertocat_White.png'
          : 'assets/social/${social.name}.png',
  };

  test('Spotify and Naver assets keep their source-backed pixels', () async {
    Future<({int width, int height, List<int> rgba})> decode(
      String path,
    ) async {
      final codec = await instantiateImageCodec(await File(path).readAsBytes());
      addTearDown(codec.dispose);
      final frame = await codec.getNextFrame();
      addTearDown(frame.image.dispose);
      final data = await frame.image.toByteData(
        format: ImageByteFormat.rawRgba,
      );
      return (
        width: frame.image.width,
        height: frame.image.height,
        rgba: data!.buffer.asUint8List(),
      );
    }

    int pixelCount(List<int> bytes, List<int> expected) {
      var count = 0;
      for (var offset = 0; offset < bytes.length; offset += 4) {
        if (bytes[offset] == expected[0] &&
            bytes[offset + 1] == expected[1] &&
            bytes[offset + 2] == expected[2] &&
            bytes[offset + 3] == expected[3]) {
          count++;
        }
      }
      return count;
    }

    final spotifySource = await decode(
      'assets/original/spotify/Spotify_Primary_Logo_RGB_Black.png',
    );
    final spotifyRuntime = await decode('assets/social/spotify.png');
    expect(
      (spotifySource.width, spotifySource.height),
      (939, 940),
    );
    expect(
      (spotifyRuntime.width, spotifyRuntime.height),
      (128, 128),
    );
    expect(
      pixelCount(spotifyRuntime.rgba, const [0, 0, 0, 255]),
      greaterThan(8000),
    );
    expect(
      pixelCount(spotifyRuntime.rgba, const [255, 255, 255, 255]),
      0,
    );

    final naverOriginal = await decode(
      'assets/original/naver/NAVER_login_Dark_KR_green_icon_H56.png',
    );
    final naverRuntime = await decode('assets/social/naver.png');
    expect((naverOriginal.width, naverOriginal.height), (224, 224));
    expect((naverRuntime.width, naverRuntime.height), (224, 224));
    expect(
      pixelCount(naverOriginal.rgba, const [5, 172, 79, 255]),
      greaterThan(30000),
    );
    expect(naverRuntime.rgba, naverOriginal.rgba);

    final catalog =
        jsonDecode(
              await File('landing/logo-catalog.json').readAsString(),
            )
            as List<dynamic>;
    final naver =
        catalog.singleWhere((entry) => entry['id'] == 'naver')
            as Map<String, dynamic>;
    final spotify =
        catalog.singleWhere((entry) => entry['id'] == 'spotify')
            as Map<String, dynamic>;
    expect(naver['background'], '#05AC4F');
    expect(
      spotify['asset']['sha256'],
      '14113bb619ec259ae51a713e4098038c2a51bc2e65ed5dd97da25aa72702d7a5',
    );
    expect(spotify['asset']['rasterization'], {
      'color': '#000000',
      'width': 128,
      'height': 128,
      'preserveColors': true,
    });
  });

  testWidgets('bundled defaults use package assets for every shape', (
    tester,
  ) async {
    final bundle = _LogoBundle();
    for (final entry in bundledLogoPaths.entries) {
      for (final shape in SocialButtonShape.values) {
        await _pump(
          tester,
          SocialButton(social: entry.key, shape: shape, onPressed: _noop),
          bundle: bundle,
        );
        final image = tester.widget<Image>(find.byType(Image));
        final asset = image.image as AssetImage;
        expect(asset.assetName, entry.value);
        expect(asset.package, 'social_signin_kit');
        expect(image.fit, BoxFit.contain);
        expect(image.color, isNull);
        expect(find.byType(RawImage), findsOneWidget);
        expect(tester.widget<RawImage>(find.byType(RawImage)).image, isNotNull);
        expect(tester.takeException(), isNull);
      }
    }
    expect(
      bundle.requested.where((key) => key.endsWith('.png')).toSet(),
      bundledLogoPaths.values
          .map((path) => 'packages/social_signin_kit/$path')
          .toSet(),
    );
  });

  testWidgets('custom asset path overrides the default without a package key', (
    tester,
  ) async {
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

  testWidgets('missing bundled and custom assets report the expected path', (
    tester,
  ) async {
    for (final path in ['assets/social/google.png', 'missing/custom.png']) {
      final bundled = path == 'assets/social/google.png';
      final requestedPath =
          bundled ? 'packages/social_signin_kit/$path' : path;
      final bundle = _LogoBundle(missing: {requestedPath});
      await tester.pumpWidget(_app(
        SocialButton(
          social: Social.google,
          logo: bundled ? null : path,
          onPressed: _noop,
        ),
        bundle: bundle,
      ));
      await tester.pump();
      final error = tester.takeException();
      expect(error, isA<FlutterError>());
      expect(error.toString(), contains(path));
      expect(find.byIcon(Icons.person_outline), findsNothing);
      expect(find.byType(ErrorWidget), findsNothing);
      expect(find.byIcon(Icons.broken_image_outlined), findsOneWidget);
      expect(
        tester.getSize(find.byType(Image)),
        const Size.square(20),
      );
      expect(tester.getSize(find.byType(TextButton)).height, 48);
      expect(tester.widget<Tooltip>(find.byType(Tooltip)).message, contains(path));
      await tester.pump();
      expect(tester.takeException(), isNull);
    }
  });

  test('all 35 declared package logo files are loadable', () async {
    expect(bundledLogoPaths, hasLength(35));
    for (final path in bundledLogoPaths.values) {
      final bytes = await rootBundle.load(
        'packages/social_signin_kit/$path',
      );
      expect(bytes.lengthInBytes, greaterThan(0), reason: path);
    }
  });

  testWidgets('app locale changes rebuild labels and circle tooltips', (
    tester,
  ) async {
    const button = SocialButton(social: Social.notion, onPressed: _noop);
    for (final locale in const [Locale('ko', 'KR'), Locale('en'), Locale('ja')]) {
      await _pump(tester, button, locale: locale);
      expect(find.text(socialLoginProviderData(Social.notion).labelFor(locale)),
          findsOneWidget);
    }
    const circle = SocialButton(
      social: Social.notion,
      shape: SocialButtonShape.circle,
      onPressed: _noop,
    );
    for (final locale in const [Locale('ko'), Locale('en')]) {
      await _pump(tester, circle, locale: locale);
      expect(tester.widget<Tooltip>(find.byType(Tooltip)).message,
          socialLoginProviderData(Social.notion).labelFor(locale));
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
            social: Social.google,
            locale: Locale('ja'),
            onPressed: _noop,
          ),
          SocialButton(
            social: Social.notion,
            label: 'Custom action',
            semanticLabel: 'Accessible action',
            onPressed: _noop,
          ),
        ],
      ),
      locale: const Locale('ko'),
    );
    expect(find.text(socialLoginProviderData(Social.google).labelEn),
        findsOneWidget);
    expect(find.text('Custom action'), findsOneWidget);
    final semantics = tester.ensureSemantics();
    expect(find.bySemanticsLabel('Accessible action'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('defaults are rounded and 48 with no localizations', (
    tester,
  ) async {
    final bundle = _LogoBundle();
    await tester.pumpWidget(DefaultAssetBundle(
      bundle: bundle,
      child: const MediaQuery(
        data: MediaQueryData(),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Material(
            child: Center(
              child: SocialButton(social: Social.notion, onPressed: _noop),
            ),
          ),
        ),
      ),
    ));
    await _decode(tester);
    final style = tester.widget<TextButton>(find.byType(TextButton)).style!;
    expect(style.shape!.resolve({}), isA<RoundedRectangleBorder>());
    expect(style.minimumSize!.resolve({}), const Size(0, 48));
    expect(find.text(socialLoginProviderData(Social.notion).labelEn),
        findsOneWidget);
  });

  testWidgets('explicit default-valued settings beat non-default list settings', (
    tester,
  ) async {
    const inheritedKey = ValueKey('inherited');
    const explicitKey = ValueKey('explicit');
    const inherited = SocialButton(
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
      expect(find.text(socialLoginProviderData(Social.notion).labelKo),
          findsOneWidget);
      expect(find.text(socialLoginProviderData(Social.google).labelEn),
          findsOneWidget);
      expect(tester.widget(find.byKey(inheritedKey)), same(inherited));
    }
  });

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
            key: inheritedKey,
            social: Social.google,
            onPressed: _noop,
          ),
          SocialButton(
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
    expect(
      explicitStyle.backgroundColor!.resolve({}),
      const Color(0xFFFFFFFF),
    );
    expect(
      explicitStyle.foregroundColor!.resolve({}),
      const Color(0xFF1F1F1F),
    );
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
        expect(
          side == BorderSide.none ? null : side.color,
          colors[2],
        );
        expect(
          style.backgroundColor!.resolve({WidgetState.disabled}),
          isNot(colors[0]),
        );
        expect(
          style.overlayColor!.resolve({WidgetState.hovered}),
          isNotNull,
        );
        expect(
          style.overlayColor!.resolve({WidgetState.pressed}),
          isNotNull,
        );
      }
    }
  });

  testWidgets('appearance logo treatments preserve explicit overrides', (
    tester,
  ) async {
    await _pump(
      tester,
      const SocialButton(
        social: Social.apple,
        appearance: SocialButtonAppearance.light,
        onPressed: _noop,
      ),
    );
    var image = tester.widget<Image>(find.byType(Image));
    var asset = image.image as AssetImage;
    expect(asset.assetName, 'assets/social/apple-light.png');
    expect(asset.package, 'social_signin_kit');
    expect(image.color, isNull);

    await _pump(
      tester,
      const SocialButton(
        social: Social.apple,
        logo: 'images/apple.png',
        appearance: SocialButtonAppearance.light,
        onPressed: _noop,
      ),
    );
    image = tester.widget<Image>(find.byType(Image));
    asset = image.image as AssetImage;
    expect(asset.assetName, 'images/apple.png');
    expect(asset.package, isNull);
    expect(find.byType(ColorFiltered), findsNothing);

    await _pump(
      tester,
      const SocialButton(
        social: Social.slack,
        appearance: SocialButtonAppearance.light,
        onPressed: _noop,
      ),
    );
    image = tester.widget<Image>(find.byType(Image));
    asset = image.image as AssetImage;
    expect(asset.assetName, 'assets/social/slack-light.png');
    expect(asset.package, 'social_signin_kit');
    expect(image.color, isNull);
  });

  test('Apple light provider asset is bundled and loadable', () async {
    final bytes = await rootBundle.load(
      'packages/social_signin_kit/assets/social/apple-light.png',
    );
    expect(bytes.lengthInBytes, 1092);
  });

  test('Slack light provider asset is bundled and loadable', () async {
    final bytes = await rootBundle.load(
      'packages/social_signin_kit/assets/social/slack-light.png',
    );
    expect(bytes.lengthInBytes, 3320);
  });

  testWidgets('GitHub appearances select supplied untinted originals', (
    tester,
  ) async {
    for (final appearance in SocialButtonAppearance.values) {
      await _pump(
        tester,
        SocialButton(
          social: Social.github,
          appearance: appearance,
          onPressed: _noop,
        ),
      );
      final image = tester.widget<Image>(find.byType(Image));
      final asset = image.image as AssetImage;
      final variant = appearance == SocialButtonAppearance.light
          ? 'Black'
          : 'White';
      expect(
        asset.assetName,
        'assets/original/github/GitHub_Invertocat_$variant.png',
      );
      expect(asset.package, 'social_signin_kit');
      expect(image.color, isNull);
      final bytes = await rootBundle.load(asset.keyName);
      expect(bytes.lengthInBytes, greaterThan(0));
    }
  });

  testWidgets('verified appearances load untinted complete original canvases', (
    tester,
  ) async {
    const cases = [
      (Social.x, SocialButtonAppearance.light, 'assets/original/x/logo-black.png'),
      (Social.x, SocialButtonAppearance.dark, 'assets/original/x/logo-white.png'),
      (Social.discord, SocialButtonAppearance.light, 'assets/original/discord/Discord-Symbol-Black.png'),
      (Social.discord, SocialButtonAppearance.dark, 'assets/original/discord/Discord-Symbol-White.png'),
      (Social.linkedin, SocialButtonAppearance.light, 'assets/original/linkedin/LI-In-Bug.png'),
      (Social.linkedin, SocialButtonAppearance.dark, 'assets/original/linkedin/InBug-White.png'),
      (Social.twitch, SocialButtonAppearance.light, 'assets/original/twitch/glitch_flat_black-ops.png'),
      (Social.twitch, SocialButtonAppearance.dark, 'assets/original/twitch/glitch_flat_white.png'),
      (Social.spotify, SocialButtonAppearance.light, 'assets/original/spotify/Spotify_Primary_Logo_RGB_Black.png'),
      (Social.spotify, SocialButtonAppearance.dark, 'assets/original/spotify/Spotify_Primary_Logo_RGB_White.png'),
      (Social.reddit, SocialButtonAppearance.light, 'assets/original/reddit/Reddit_Logo.png'),
      (Social.reddit, SocialButtonAppearance.dark, 'assets/original/reddit/Reddit_Logo.png'),
      (Social.gitlab, SocialButtonAppearance.light, 'assets/original/gitlab/gitlab-logo-500-rgb.png'),
      (Social.gitlab, SocialButtonAppearance.dark, 'assets/original/gitlab/gitlab-logo-500-rgb.png'),
      (Social.bitbucket, SocialButtonAppearance.light, 'assets/original/bitbucket/Bitbucket_icon.png'),
      (Social.bitbucket, SocialButtonAppearance.dark, 'assets/original/bitbucket/Bitbucket_icon.png'),
      (Social.telegram, SocialButtonAppearance.light, 'assets/original/telegram/Logo.png'),
      (Social.telegram, SocialButtonAppearance.dark, 'assets/original/telegram/Logo.png'),
      (Social.weibo, SocialButtonAppearance.light, 'assets/original/weibo/LOGO_64x64.png'),
      (Social.weibo, SocialButtonAppearance.dark, 'assets/original/weibo/LOGO_64x64.png'),
      (Social.paypal, SocialButtonAppearance.light, 'assets/original/paypal/PayPal-Monogram-FullColor-RGB.png'),
      (Social.naver, SocialButtonAppearance.light, 'assets/original/naver/NAVER_login_Light_KR_green_icon_H56.png'),
      (Social.naver, SocialButtonAppearance.dark, 'assets/original/naver/NAVER_login_Dark_KR_green_icon_H56.png'),
      (Social.line, SocialButtonAppearance.light, 'assets/original/line/line_88.png'),
      (Social.line, SocialButtonAppearance.dark, 'assets/original/line/line_88.png'),
      (Social.kakao, SocialButtonAppearance.light, 'assets/original/kakao/kakao_login_light.png'),
      (Social.kakao, SocialButtonAppearance.dark, 'assets/original/kakao/kakao_login_light.png'),
    ];
    final catalog = jsonDecode(File('landing/logo-catalog.json').readAsStringSync())
        as List<dynamic>;
    for (final (social, appearance, path) in cases) {
      await _pump(tester, SocialButton(
        social: social, appearance: appearance, onPressed: _noop,
      ));
      final image = tester.widget<Image>(find.byType(Image));
      final asset = image.image as AssetImage;
      expect(asset.assetName, path);
      expect(asset.package, 'social_signin_kit');
      expect(image.color, isNull);
      expect(image.fit, BoxFit.contain);
      final bytes = await rootBundle.load(asset.keyName);
      expect(bytes.lengthInBytes, greaterThan(0));
      final entry = catalog.singleWhere((dynamic c) => c['id'] == social.name)
          as Map<String, dynamic>;
      final variant = entry['asset']['variants'][appearance.name]
          as Map<String, dynamic>;
      expect(variant['preview'], '../$path');
      expect(variant['official'], isTrue);
      expect(variant['sha256'], matches(RegExp(r'^[a-f0-9]{64}$')));
    }
    await _pump(tester, const SocialButton(
      social: Social.x, appearance: SocialButtonAppearance.dark,
      logo: 'images/custom.png', onPressed: _noop,
    ));
    final image = tester.widget<Image>(find.byType(Image));
    final asset = image.image as AssetImage;
    expect(asset.assetName, 'images/custom.png');
    expect(asset.package, isNull);
    expect(image.color, isNull);
  });

  test('all 35 providers expose bounded complete variant metadata', () {
    final catalog = jsonDecode(File('landing/logo-catalog.json').readAsStringSync())
        as List<dynamic>;
    expect(catalog.map((dynamic c) => c['id']).toSet(),
        Social.values.map((social) => social.name).toSet());
    for (final dynamic entry in catalog) {
      for (final appearance in SocialButtonAppearance.values) {
        final variant = entry['asset']['variants'][appearance.name]
            as Map<String, dynamic>;
        for (final key in const ['preview', 'download', 'source', 'format',
          'sha256', 'conditions', 'archiveSha256', 'archiveMember',
          'implemented', 'authControlApproved']) {
          expect(variant.containsKey(key), isTrue,
              reason: '${entry['id']}.${appearance.name}.$key');
        }
        final social = Social.values.singleWhere((s) => s.name == entry['id']);
        final data = socialLoginProviderData(social);
        expect(variant['preview'],
            '../${data.appearanceStyle(appearance).asset ?? data.bundledLogoAsset}');
      }
    }
  });

  testWidgets('restricted metadata warns while requested shapes render', (
    tester,
  ) async {
    await _pump(
      tester,
      const SocialButton(
        social: Social.kakao,
        shape: SocialButtonShape.pill,
        onPressed: _noop,
      ),
    );
    expect(
      tester.widget<TextButton>(find.byType(TextButton)).style!.shape!.resolve(
        {},
      ),
      isA<StadiumBorder>(),
    );

    await _pump(
      tester,
      const SocialButtonList.horizontal(
        items: [
          SocialButton(
            social: Social.kakao,
            onPressed: _noop,
          ),
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

  testWidgets('inherited settings update for identical const button instances', (
    tester,
  ) async {
    const items = [
      SocialButton(social: Social.notion, onPressed: _noop),
    ];
    await _pump(tester, const SocialButtonList.vertical(
      locale: Locale('ko'),
      items: items,
    ));
    expect(find.text(socialLoginProviderData(Social.notion).labelKo),
        findsOneWidget);
    await _pump(tester, const SocialButtonList.horizontal(
      size: 64,
      locale: Locale('en'),
      items: items,
    ));
    final style = tester.widget<TextButton>(find.byType(TextButton)).style!;
    expect(style.shape!.resolve({}), isA<CircleBorder>());
    expect(tester.getSize(find.byType(TextButton)), const Size.square(64));
    expect(tester.widget<Tooltip>(find.byType(Tooltip)).message,
        socialLoginProviderData(Social.notion).labelEn);
  });

  testWidgets('vertical list has equal widths, spacing, and explicit circles', (
    tester,
  ) async {
    await _pump(tester, const SizedBox(
      width: 240,
      child: SocialButtonList.vertical(
        spacing: 13,
        items: [
          SocialButton(social: Social.notion, onPressed: _noop),
          SocialButton(social: Social.google, label: 'G', onPressed: _noop),
          SocialButton(
            social: Social.github,
            shape: SocialButtonShape.circle,
            size: 60,
            onPressed: _noop,
          ),
        ],
      ),
    ));
    final buttons = find.byType(TextButton);
    expect(tester.getSize(buttons.at(0)).width, 240);
    expect(tester.getSize(buttons.at(1)).width, 240);
    expect(tester.getTopLeft(buttons.at(1)).dy -
        tester.getBottomLeft(buttons.at(0)).dy, 13);
    expect(tester.getSize(buttons.at(2)), const Size.square(60));
  });

  testWidgets('horizontal circle list wraps with both-axis spacing', (
    tester,
  ) async {
    const items = [
      SocialButton(social: Social.notion, onPressed: _noop),
      SocialButton(social: Social.google, onPressed: _noop),
      SocialButton(social: Social.github, onPressed: _noop),
    ];
    for (final width in [200.0, 110.0]) {
      await _pump(tester, SizedBox(
        width: width,
        child: const SocialButtonList.horizontal(spacing: 10, items: items),
      ));
      final buttons = find.byType(TextButton);
      for (var index = 0; index < 3; index++) {
        expect(tester.getSize(buttons.at(index)), const Size.square(48));
      }
      expect(tester.getTopLeft(buttons.at(1)).dx -
          tester.getTopRight(buttons.at(0)).dx, 10);
      expect(tester.getTopLeft(buttons.at(2)).dy -
          tester.getTopLeft(buttons.at(0)).dy, width == 110 ? 58 : 0);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('lists survive unbounded width, empty items, and scaled labels', (
    tester,
  ) async {
    for (final vertical in [true, false]) {
      final items = [
        const SocialButton(
          social: Social.notion,
          label: 'An unusually long accessible action label',
          onPressed: _noop,
        ),
        const SocialButton(social: Social.google, onPressed: _noop),
      ];
      final list = vertical
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
      expect(tester.getSize(find.byType(TextButton).first).height, greaterThan(48));
      expect(tester.takeException(), isNull);
    }
    await _pump(tester, const Column(children: [
      SocialButtonList.vertical(items: []),
      SocialButtonList.horizontal(items: []),
    ]));
    expect(find.byType(TextButton), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('circle sizes below 48 keep an accessible touch target', (
    tester,
  ) async {
    await _pump(tester, const SocialButton(
      social: Social.notion,
      size: 32,
      shape: SocialButtonShape.circle,
      onPressed: _noop,
    ));
    final style = tester.widget<TextButton>(find.byType(TextButton)).style!;
    expect(style.fixedSize!.resolve({}), const Size.square(32));
    expect(tester.getSize(find.byType(TextButton)), const Size.square(48));
    expect(tester.takeException(), isNull);
  });

  testWidgets('new buttons expose one action and respect disabled transitions', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    var count = 0;
    for (final enabled in [true, false, true]) {
      await _pump(tester, SocialButton(
        social: Social.notion,
        onPressed: enabled ? () => count++ : null,
        label: 'Unique action',
        shape: SocialButtonShape.circle,
      ));
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
  });

  testWidgets('hover press focus and disabled resolve distinct package states', (
    tester,
  ) async {
    for (final social in Social.values) {
      await _pump(tester, SocialButton(social: social, onPressed: _noop));
      final style = tester.widget<TextButton>(find.byType(TextButton)).style!;
      final base = style.backgroundColor!.resolve({})!;
      final hover = style.overlayColor!.resolve({WidgetState.hovered})!;
      final pressed = style.overlayColor!.resolve({WidgetState.pressed})!;
      if (social == Social.vk) {
        expect(Color.alphaBlend(hover, base), base);
        expect(
          style
              .backgroundColor!
              .resolve({WidgetState.hovered})!
              .a,
          closeTo(0.8, 0.001),
        );
        expect(
          style
              .backgroundColor!
              .resolve({WidgetState.pressed})!
              .a,
          closeTo(0.7, 0.001),
        );
      } else {
        expect(Color.alphaBlend(hover, base), isNot(base), reason: social.name);
        expect(pressed, isNot(hover));
      }
      expect(style.overlayColor!.resolve({
        WidgetState.hovered, WidgetState.focused, WidgetState.pressed,
      }), pressed);
      expect(style.side!.resolve({WidgetState.focused})!.width, 2);
      expect(style.overlayColor!.resolve({
        WidgetState.disabled, WidgetState.pressed, WidgetState.focused,
      }), isNull);
    }
  });

  testWidgets('LINE uses its documented states and separator', (tester) async {
    await _pump(
      tester,
      const SocialButton(social: Social.line, onPressed: _noop),
    );
    final style = tester.widget<TextButton>(find.byType(TextButton)).style!;

    expect(
      Color.alphaBlend(
        style.overlayColor!.resolve({WidgetState.hovered})!,
        const Color(0xFF06C755),
      ),
      Color.alphaBlend(
        const Color(0x1A000000),
        const Color(0xFF06C755),
      ),
    );
    expect(
      Color.alphaBlend(
        style.overlayColor!.resolve({WidgetState.pressed})!,
        const Color(0xFF06C755),
      ),
      Color.alphaBlend(
        const Color(0x4D000000),
        const Color(0xFF06C755),
      ),
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
      const SocialButton(social: Social.line, onPressed: null),
    );
    expect(
      tester.widget<Image>(find.byType(Image)).color,
      const Color(0x331E1E1E),
    );
    expect(
      tester.widget<Container>(
        find.byKey(const ValueKey('line-separator')),
      ).color,
      const Color(0x99E5E5E5),
    );
  });

  testWidgets('provider metrics use real bundled canvas geometry', (
    tester,
  ) async {
    await _pump(
      tester,
      const SocialButton(social: Social.google, onPressed: _noop),
    );
    expect(tester.getSize(find.byType(Image)), const Size.square(20));
    final googleStyle =
        tester.widget<TextButton>(find.byType(TextButton)).style!;
    expect(googleStyle.textStyle!.resolve({})!.fontSize, 14);
    expect(googleStyle.textStyle!.resolve({})!.height, 20 / 14);
    expect(googleStyle.textStyle!.resolve({})!.fontWeight, FontWeight.w500);

    await _pump(
      tester,
      const SocialButton(social: Social.microsoft, onPressed: _noop),
    );
    expect(tester.getSize(find.byType(Image)), const Size.square(21));

    await _pump(
      tester,
      const SocialButton(social: Social.line, onPressed: _noop),
    );
    expect(tester.getSize(find.byType(Image)), const Size.square(30));

    await _pump(
      tester,
      const SocialButton(social: Social.spotify, onPressed: _noop),
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
      const SocialButton(social: Social.naver, onPressed: _noop),
    );
    expect(tester.getSize(find.byType(Image)).width, greaterThanOrEqualTo(44.8));
    final row = tester.widget<Row>(find.byType(Row));
    expect(
      row.children.whereType<SizedBox>().single.width,
      8,
    );
  });

  testWidgets('app asset overrides retain provider logo geometry', (
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
      Size? bundledSize;
      for (final logo in [null, 'images/${entry.key.name}.png']) {
        await _pump(
          tester,
          SocialButton(
            social: entry.key,
            logo: logo,
            onPressed: _noop,
          ),
        );
        final imageSize = tester.getSize(find.byType(Image));
        bundledSize ??= imageSize;
        expect(imageSize, bundledSize, reason: entry.key.name);
        expect(imageSize, Size.square(entry.value), reason: entry.key.name);
      }
    }

    for (final logo in [null, 'images/google.png']) {
      await _pump(
        tester,
        SocialButton(
          social: Social.google,
          logo: logo,
          onPressed: _noop,
        ),
      );
      final row = tester.widget<Row>(find.byType(Row));
      expect(row.children.whereType<SizedBox>().single.width, 10);
    }

    for (final logo in [null, 'images/line.png']) {
      await _pump(
        tester,
        SocialButton(
          social: Social.line,
          logo: logo,
          onPressed: _noop,
        ),
      );
      final row = tester.widget<Row>(find.byType(Row));
      for (final gap in row.children.whereType<SizedBox>()) {
        expect(gap.width, closeTo(48 * 4 / 11, 0.001));
      }
    }
  });

  testWidgets('documented provider default radii are rendered', (tester) async {
    for (final entry in const {
      Social.kakao: 12.0,
      Social.apple: 15.0,
      Social.vk: 8.0,
    }.entries) {
      await _pump(
        tester,
        SocialButton(social: entry.key, onPressed: _noop),
      );
      final shape = tester
          .widget<TextButton>(find.byType(TextButton))
          .style!
          .shape!
          .resolve({})! as RoundedRectangleBorder;
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
        child: SocialButton(social: Social.apple, onPressed: _noop),
      ),
    );
    expect(tester.getSize(find.byType(TextButton)).width, 500);
  });
}

void _noop() {}

ButtonStyle _style(WidgetTester tester, Key key) => tester.widget<TextButton>(
  find.descendant(of: find.byKey(key), matching: find.byType(TextButton)),
).style!;

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  _LogoBundle? bundle,
  Locale locale = const Locale('en'),
  TextScaler textScaler = TextScaler.noScaling,
}) async {
  await tester.pumpWidget(_app(
    child,
    bundle: bundle ?? _LogoBundle(),
    locale: locale,
    textScaler: textScaler,
  ));
  await _decode(tester);
}

// Await the exact image-completion signal instead of a decoding delay.
Future<void> _decode(WidgetTester tester) async {
  await tester.runAsync(() async {
    for (final element in find.byType(Image).evaluate()) {
      await precacheImage((element.widget as Image).image, element);
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
    return ByteData.sublistView(base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAACklEQVR4nGMA'
      'AQAABQABDQottAAAAABJRU5ErkJggg==',
    ));
  }
}

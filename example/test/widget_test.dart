import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:social_signin_kit/social_signin_kit.dart';
import 'package:social_signin_kit_example/demo_logo.dart';
import 'package:social_signin_kit_example/gallery_design.dart';
import 'package:social_signin_kit_example/main.dart';

void main() {
  testWidgets('consumer demo bundle supplies a decodable neutral PNG', (
    tester,
  ) async {
    await tester.runAsync(() async {
      final data = await DemoLogoAssetBundle().load(demoLogoAsset);
      final codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      );
      final frame = await codec.getNextFrame();
      expect(frame.image.width, 16);
      expect(frame.image.height, 16);
      frame.image.dispose();
      codec.dispose();
    });
  });

  test('gallery theme uses the bundled Korean font family', () {
    final theme = buildGalleryTheme();

    expect(theme.textTheme.bodyMedium?.fontFamily, 'NotoSansKR');
  });

  testWidgets('starts with the contracted controls and all provider buttons', (
    tester,
  ) async {
    await tester.pumpWidget(const SocialLoginExampleApp());

    expect(
      find.byKey(const ValueKey<String>('locale-control')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey<String>('shape-control')), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('appearance-control')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('disabled-control')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('provider-control')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('selected-provider-button')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('vertical-button-list')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('horizontal-button-list')),
      findsOneWidget,
    );
    expect(find.byType(SocialButtonList), findsNWidgets(2));
    expect(find.byType(SocialButton), findsNWidgets(42));

    for (final provider in Social.values) {
      expect(
        find.byKey(ValueKey<String>('provider-button-${provider.name}')),
        findsOneWidget,
      );
    }

    final selected = tester.widget<SocialButton>(
      find.byKey(const ValueKey<String>('selected-provider-button')),
    );
    expect(selected.social, Social.google);
    expect(selected.shape, SocialButtonShape.pill);
    expect(selected.appearance, SocialButtonAppearance.providerDefault);
    expect(selected.locale, const Locale('ko'));
    expect(selected.logo, demoLogoAsset);
    expect(selected.onPressed, isNotNull);
    expect(
      tester
          .widget<SocialButton>(
            find.byKey(const ValueKey<String>('provider-button-notion')),
          )
          .logo,
      demoLogoAsset,
    );
    for (final provider in Social.values) {
      expect(
        tester
            .widget<SocialButton>(
              find.byKey(ValueKey<String>('provider-button-${provider.name}')),
            )
            .logo,
        demoLogoAsset,
      );
    }
    for (final button in tester.widgetList<SocialButton>(
      find.byType(SocialButton),
    )) {
      expect(button.logo, demoLogoAsset);
    }
    final selectedImage = find.descendant(
      of: find.byKey(const ValueKey<String>('selected-provider-button')),
      matching: find.byType(Image),
    );
    final image = tester.widget<Image>(selectedImage);
    final assetImage = image.image as AssetImage;
    expect(assetImage.assetName, demoLogoAsset);
    expect(assetImage.package, isNull);
    expect(
      DefaultAssetBundle.of(tester.element(selectedImage)),
      isA<DemoLogoAssetBundle>(),
    );
    expect(
      tester
          .widget<Text>(find.byKey(const ValueKey<String>('callback-count')))
          .data,
      '0',
    );
    expect(
      tester
          .widget<Text>(find.byKey(const ValueKey<String>('callback-provider')))
          .data,
      'none',
    );
  });

  testWidgets('locale shape appearance and provider controls update previews', (
    tester,
  ) async {
    await tester.pumpWidget(const SocialLoginExampleApp());

    await _tapVisible(tester, find.text('English'));
    await _tapVisible(tester, find.text('Circle'));
    await _tapVisible(tester, find.text('Dark'));

    final providerControl = find.byKey(
      const ValueKey<String>('provider-control'),
    );
    tester.widget<DropdownMenu<Social>>(providerControl).onSelected!(
      Social.github,
    );
    await tester.pump();

    final selected = tester.widget<SocialButton>(
      find.byKey(const ValueKey<String>('selected-provider-button')),
    );
    expect(selected.social, Social.github);
    expect(selected.shape, SocialButtonShape.circle);
    expect(selected.appearance, SocialButtonAppearance.dark);
    expect(selected.locale, const Locale('en'));

    for (final provider in Social.values) {
      final preview = tester.widget<SocialButton>(
        find.byKey(ValueKey<String>('provider-button-${provider.name}')),
      );
      expect(preview.shape, SocialButtonShape.circle);
      expect(preview.appearance, SocialButtonAppearance.dark);
      expect(preview.locale, const Locale('en'));
    }

    final vertical = tester.widget<SocialButtonList>(
      find.byKey(const ValueKey<String>('vertical-button-list')),
    );
    final horizontal = tester.widget<SocialButtonList>(
      find.byKey(const ValueKey<String>('horizontal-button-list')),
    );
    for (final list in [vertical, horizontal]) {
      expect(list.shape, SocialButtonShape.circle);
      expect(list.appearance, SocialButtonAppearance.dark);
      expect(list.size, 48);
      expect(list.locale, const Locale('en'));
      expect(list.spacing, GallerySpace.x2);
      for (final item in list.items) {
        expect(item.shape, isNull);
        expect(item.size, isNull);
        expect(item.locale, isNull);
      }
    }
  });

  testWidgets('callbacks count the actual selected and catalog providers', (
    tester,
  ) async {
    await tester.pumpWidget(const SocialLoginExampleApp());

    await _tapVisible(
      tester,
      find.byKey(const ValueKey<String>('selected-provider-button')),
    );
    expect(_keyedText(tester, 'callback-count'), '1');
    expect(_keyedText(tester, 'callback-provider'), 'google');

    final github = find.byKey(const ValueKey<String>('provider-button-github'));
    await tester.ensureVisible(github);
    await tester.pumpAndSettle();
    await tester.tap(github);
    await tester.pump();
    expect(_keyedText(tester, 'callback-count'), '2');
    expect(_keyedText(tester, 'callback-provider'), 'github');

    final listNotion = find.byKey(
      const ValueKey<String>('horizontal-list-notion'),
    );
    await tester.ensureVisible(listNotion);
    await tester.pumpAndSettle();
    await tester.tap(listNotion);
    await tester.pump();
    expect(_keyedText(tester, 'callback-count'), '3');
    expect(_keyedText(tester, 'callback-provider'), 'notion');
  });

  testWidgets('disabled blocks callbacks and re-enabling preserves state', (
    tester,
  ) async {
    await tester.pumpWidget(const SocialLoginExampleApp());

    final selected = find.byKey(
      const ValueKey<String>('selected-provider-button'),
    );
    await _tapVisible(tester, selected);
    expect(_keyedText(tester, 'callback-count'), '1');

    await _tapVisible(
      tester,
      find.byKey(const ValueKey<String>('disabled-control')),
    );

    final disabledSelected = tester.widget<SocialButton>(selected);
    expect(disabledSelected.onPressed, isNull);
    for (final provider in Social.values) {
      final preview = tester.widget<SocialButton>(
        find.byKey(ValueKey<String>('provider-button-${provider.name}')),
      );
      expect(preview.onPressed, isNull);
    }
    expect(
      tester
          .widget<SocialButton>(
            find.byKey(const ValueKey<String>('vertical-list-google')),
          )
          .onPressed,
      isNull,
    );
    expect(
      tester
          .widget<SocialButton>(
            find.byKey(const ValueKey<String>('horizontal-list-google')),
          )
          .onPressed,
      isNull,
    );

    await _tapVisible(tester, selected);
    expect(_keyedText(tester, 'callback-count'), '1');
    expect(_keyedText(tester, 'callback-provider'), 'google');

    await _tapVisible(
      tester,
      find.byKey(const ValueKey<String>('disabled-control')),
    );
    await _tapVisible(tester, selected);
    expect(_keyedText(tester, 'callback-count'), '2');
    expect(_keyedText(tester, 'callback-provider'), 'google');
  });

  testWidgets('mobile viewport reflows and scrolls to the final provider', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const SocialLoginExampleApp());
    expect(tester.takeException(), isNull);

    final lastProvider = find.byKey(
      const ValueKey<String>('provider-button-notion'),
    );
    await tester.ensureVisible(lastProvider);
    await tester.pumpAndSettle();

    expect(lastProvider, findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

String? _keyedText(WidgetTester tester, String key) {
  return tester.widget<Text>(find.byKey(ValueKey<String>(key))).data;
}

Future<void> _tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pump();
}

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:social_signin_kit/social_signin_kit.dart';

void main() {
  testWidgets('custom logo retains state and app owns focus node', (
    tester,
  ) async {
    final focus = FocusNode();
    var mounts = 0;
    var disposals = 0;
    var taps = 0;
    Widget app(bool loading) => MaterialApp(
      home: Scaffold(
        body: SocialButton.custom(
          social: Social.google,
          logo: _StatefulLogo(
            onMount: () => mounts++,
            onDispose: () => disposals++,
          ),
          focusNode: focus,
          autofocus: true,
          isLoading: loading,
          onPressed: () => taps++,
        ),
      ),
    );
    await tester.pumpWidget(app(false));
    await tester.pumpAndSettle();
    expect(focus.hasFocus, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(taps, 1);
    await tester.pumpWidget(app(true));
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(taps, 1);
    await tester.pumpWidget(app(false));
    await tester.pumpAndSettle();
    focus.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(taps, 2);
    expect(mounts, 1);
    expect(disposals, 0);
    await tester.pumpWidget(const SizedBox());
    expect(disposals, 1);
    focus.dispose();
  });

  for (final brightness in Brightness.values) {
    for (final social in [
      Social.google,
      Social.line,
      Social.naver,
      Social.vk,
    ]) {
      testWidgets('disabled $social has no opaque logo seam on $brightness', (
        tester,
      ) async {
        final boundaryKey = GlobalKey();
        final logoKey = GlobalKey();
        final color = socialLoginProviderData(social).backgroundColor;
        var taps = 0;
        Widget app(bool enabled) => MaterialApp(
          theme: ThemeData(brightness: brightness),
          home: Scaffold(
            body: Center(
              child: RepaintBoundary(
                key: boundaryKey,
                child: SizedBox(
                  width: 280,
                  child: SocialButton.custom(
                    social: social,
                    logo: ColoredBox(key: logoKey, color: color),
                    onPressed: enabled ? () => taps++ : null,
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpWidget(app(true));
        await tester.pumpAndSettle();
        final size = tester.getSize(find.byType(TextButton));
        await tester.pumpWidget(app(false));
        await tester.pumpAndSettle();
        final boundary =
            boundaryKey.currentContext!.findRenderObject()!
                as RenderRepaintBoundary;
        final center = boundary.globalToLocal(
          tester.getCenter(find.byKey(logoKey)),
        );
        final pixels = await _pixels(
          tester,
          boundary,
          center,
          Offset(center.dx, 8),
        );
        expect(pixels.$1, pixels.$2);
        expect(
          tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity,
          0.5,
        );
        expect(tester.getSize(find.byType(TextButton)), size);
        await tester.tap(find.byType(TextButton));
        expect(taps, 0);
        await tester.pumpWidget(app(true));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(TextButton));
        await tester.pumpAndSettle();
        expect(taps, 1);
      });
    }
  }

  testWidgets('logo state survives press hover focus and disabling', (
    tester,
  ) async {
    var mounts = 0;
    var disposals = 0;
    var enabled = true;
    late StateSetter update;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return SocialLoginButton(
                provider: Social.google,
                logo: _StatefulLogo(
                  onMount: () => mounts++,
                  onDispose: () => disposals++,
                ),
                onPressed: enabled ? () {} : null,
              );
            },
          ),
        ),
      ),
    );
    final press = await tester.startGesture(
      tester.getCenter(find.byType(TextButton)),
    );
    await tester.pump(kPressTimeout);
    await tester.pump(const Duration(milliseconds: 100));
    await press.up();
    await tester.pumpAndSettle();
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: const Offset(799, 599));
    await mouse.moveTo(tester.getCenter(find.byType(TextButton)));
    await tester.pumpAndSettle();
    await mouse.removePointer();
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    update(() => enabled = false);
    await tester.pumpAndSettle();
    update(() => enabled = true);
    await tester.pumpAndSettle();
    expect(mounts, 1, reason: 'Feedback must not replace the logo element');
    expect(disposals, 0);
  });

  testWidgets('quick tap still displays feedback without delaying callback', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SocialLoginButton(
            provider: Social.google,
            logo: const SizedBox(),
            onPressed: () => taps++,
          ),
        ),
      ),
    );
    await tester.tap(find.byType(TextButton));
    expect(taps, 1);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    final washes = tester.widgetList<ColoredBox>(find.byType(ColoredBox));
    expect(washes.any((box) => box.color.a > 0), isTrue);
    await tester.pumpAndSettle();
  });

  testWidgets(
    'loading preserves geometry and logo state while blocking input',
    (tester) async {
      final semantics = tester.ensureSemantics();
      var loading = false;
      var mounts = 0;
      var taps = 0;
      late StateSetter update;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                update = setState;
                return SocialLoginButton(
                  provider: Social.google,
                  locale: const Locale('ko'),
                  isLoading: loading,
                  logo: _StatefulLogo(
                    onMount: () => mounts++,
                    onDispose: () {},
                  ),
                  onPressed: () {
                    taps++;
                    setState(() => loading = true);
                  },
                );
              },
            ),
          ),
        ),
      );
      final before = tester.getSize(find.byType(TextButton));
      await tester.tap(find.byType(TextButton));
      await tester.pump();
      expect(taps, 1);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(tester.getSize(find.byType(TextButton)), before);
      expect(
        tester
            .widget<Visibility>(
              find.ancestor(
                of: find.byType(_StatefulLogo),
                matching: find.byType(Visibility),
              ),
            )
            .visible,
        isFalse,
      );
      final data =
          tester.getSemantics(find.byType(TextButton)).getSemanticsData();
      expect(data.hasAction(ui.SemanticsAction.tap), isFalse);
      expect(data.value, '로딩 중');
      await tester.tap(find.byType(TextButton));
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(taps, 1);
      update(() => loading = false);
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(_StatefulLogo), findsOneWidget);
      expect(mounts, 1);
      expect(tester.getSize(find.byType(TextButton)), before);
      semantics.dispose();
    },
  );

  testWidgets('VK hover and press wash logo and background together', (
    tester,
  ) async {
    final boundaryKey = GlobalKey();
    final logoKey = GlobalKey();
    final background = socialLoginProviderData(Social.vk).backgroundColor;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: RepaintBoundary(
              key: boundaryKey,
              child: SizedBox(
                width: 280,
                child: SocialLoginButton(
                  provider: Social.vk,
                  logo: ColoredBox(key: logoKey, color: background),
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ),
      ),
    );
    final boundary =
        boundaryKey.currentContext!.findRenderObject()!
            as RenderRepaintBoundary;
    final center = boundary.globalToLocal(
      tester.getCenter(find.byKey(logoKey)),
    );
    Future<(int, int)> colors() =>
        _pixels(tester, boundary, center, Offset(center.dx, center.dy - 18));
    final rest = await colors();
    expect(rest.$1, rest.$2);
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: const Offset(799, 599));
    await mouse.moveTo(tester.getCenter(find.byType(TextButton)));
    await tester.pumpAndSettle();
    final hover = await colors();
    await mouse.down(tester.getCenter(find.byType(TextButton)));
    await tester.pump(kPressTimeout);
    await tester.pump(const Duration(milliseconds: 200));
    final pressed = await colors();
    await mouse.up();
    await mouse.removePointer();
    await tester.pumpAndSettle();
    expect(
      hover.$1,
      hover.$2,
      reason: 'VK hover must not expose the logo background',
    );
    expect(hover.$1, isNot(rest.$1));
    expect(
      pressed.$1,
      pressed.$2,
      reason: 'VK press must not expose the logo background',
    );
    expect(pressed.$1, isNot(hover.$1));
  });

  for (final shape in SocialLoginButtonShape.values) {
    for (final logoShape in BoxShape.values) {
      testWidgets('press covers opaque $logoShape logo in $shape button', (
        tester,
      ) async {
        final boundaryKey = GlobalKey();
        final logoKey = GlobalKey();
        final background =
            socialLoginProviderData(Social.google).backgroundColor;
        var taps = 0;
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(splashFactory: InkRipple.splashFactory),
            home: Scaffold(
              body: Center(
                child: RepaintBoundary(
                  key: boundaryKey,
                  child: SizedBox(
                    width: shape == SocialLoginButtonShape.circle ? 48 : 280,
                    child: SocialLoginButton(
                      provider: Social.google,
                      shape: shape,
                      label: 'Login',
                      logo: DecoratedBox(
                        key: logoKey,
                        decoration: BoxDecoration(
                          color: background,
                          shape: logoShape,
                        ),
                      ),
                      onPressed: () => taps++,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        final boundary =
            boundaryKey.currentContext!.findRenderObject()!
                as RenderRepaintBoundary;
        final logoCenter = boundary.globalToLocal(
          tester.getCenter(find.byKey(logoKey)),
        );
        final outsideLogo = Offset(logoCenter.dx, logoCenter.dy - 16);
        Future<(int, int)> colors() async {
          final image = (await tester.runAsync(() => boundary.toImage()))!;
          final bytes =
              (await tester.runAsync(
                () => image.toByteData(format: ui.ImageByteFormat.rawRgba),
              ))!;
          int pixel(Offset point) => bytes.getUint32(
            (point.dy.floor() * image.width + point.dx.floor()) * 4,
          );
          final result = (pixel(logoCenter), pixel(outsideLogo));
          image.dispose();
          return result;
        }

        final resting = await colors();
        expect(resting.$1, resting.$2);
        final gesture = await tester.startGesture(
          tester.getCenter(find.byType(TextButton)),
        );
        // Advance the recognizer's documented press deadline, not wall time.
        await tester.pump(kPressTimeout);
        // Check the animation midpoint as well as its settled color.
        await tester.pump(const Duration(milliseconds: 100));
        final midpoint = await colors();
        expect(
          midpoint.$1,
          midpoint.$2,
          reason: 'Logo and background must animate together',
        );
        await tester.pump(const Duration(milliseconds: 100));
        final pressed = await colors();
        await gesture.up();
        await tester.pumpAndSettle();
        expect(taps, 1);
        expect(
          pressed.$2,
          isNot(resting.$2),
          reason: 'Press feedback must remain visible',
        );
        expect(
          pressed.$1,
          pressed.$2,
          reason: 'Opaque logo must not mask the press wash',
        );
        expect(await colors(), resting);
      });
    }
  }
}

Future<(int, int)> _pixels(
  WidgetTester tester,
  RenderRepaintBoundary boundary,
  Offset first,
  Offset second,
) async {
  return (await tester.runAsync(() async {
    final image = await boundary.toImage();
    final bytes = (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!;
    int pixel(Offset point) => bytes.getUint32(
      (point.dy.floor() * image.width + point.dx.floor()) * 4,
    );
    final result = (pixel(first), pixel(second));
    image.dispose();
    return result;
  }))!;
}

class _StatefulLogo extends StatefulWidget {
  const _StatefulLogo({required this.onMount, required this.onDispose});
  final VoidCallback onMount;
  final VoidCallback onDispose;

  @override
  State<_StatefulLogo> createState() => _StatefulLogoState();
}

class _StatefulLogoState extends State<_StatefulLogo> {
  @override
  void initState() {
    super.initState();
    widget.onMount();
  }

  @override
  void dispose() {
    widget.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SizedBox();
}

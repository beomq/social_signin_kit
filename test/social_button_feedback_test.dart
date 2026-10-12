import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:social_signin_kit/social_signin_kit.dart';

void main() {
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

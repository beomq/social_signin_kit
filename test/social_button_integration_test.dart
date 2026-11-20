import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:social_signin_kit/social_signin_kit.dart';

void main() {
  const button = SocialButton.custom(
    social: Social.google,
    logo: Icon(Icons.login),
    onPressed: _noop,
  );

  testWidgets('buttons and both lists size inside an AlertDialog', (
    tester,
  ) async {
    for (final content in [
      button,
      const SocialLoginButton(
        provider: Social.google,
        logo: Icon(Icons.login),
        onPressed: _noop,
      ),
      const SocialButtonList.vertical(items: [button]),
      const SocialButtonList.horizontal(items: [button]),
    ]) {
      await tester.pumpWidget(MaterialApp(home: AlertDialog(content: content)));
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.byType(TextButton)).width,
        greaterThanOrEqualTo(48),
      );
    }
  });

  testWidgets('a wide LINE logo and its label fit a narrow button', (
    tester,
  ) async {
    const logoKey = ValueKey('wide-logo');
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 160,
              child: SocialButton.custom(
                social: Social.line,
                logo: ColoredBox(key: logoKey, color: Colors.white),
                logoAspectRatio: 3.5,
                onPressed: _noop,
              ),
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    final buttonRect = tester.getRect(find.byType(TextButton));
    final logoRect = tester.getRect(find.byKey(logoKey));
    final labelRect = tester.getRect(find.byType(Text));
    expect(logoRect.width / logoRect.height, closeTo(3.5, 0.01));
    expect(logoRect.left, greaterThanOrEqualTo(buttonRect.left));
    expect(logoRect.right, lessThanOrEqualTo(buttonRect.right));
    expect(labelRect.top, greaterThanOrEqualTo(logoRect.bottom));
    expect(labelRect.bottom, lessThanOrEqualTo(buttonRect.bottom));
  });

  testWidgets('large text can show the complete default label', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder:
                (context) => MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: const TextScaler.linear(2)),
                  child: const Center(
                    child: SizedBox(
                      width: 280,
                      child: SocialButton.custom(
                        social: Social.facebook,
                        logo: Icon(Icons.login),
                        onPressed: _noop,
                      ),
                    ),
                  ),
                ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    const label = 'Continue with Facebook';
    final paragraph = tester.renderObject<RenderParagraph>(find.text(label));
    expect(
      paragraph.getBoxesForSelection(
        TextSelection(baseOffset: label.length - 1, extentOffset: label.length),
      ),
      isNotEmpty,
    );
    expect(tester.getSize(find.byType(TextButton)).height, greaterThan(48));
  });

  for (final useAppFocusNode in [false, true]) {
    testWidgets(
      'loading permits keyboard retry (app focus node: $useAppFocusNode)',
      (tester) async {
        final firstFocus = FocusNode();
        final buttonFocus = useAppFocusNode ? FocusNode() : null;
        addTearDown(firstFocus.dispose);
        if (buttonFocus != null) addTearDown(buttonFocus.dispose);
        late StateSetter update;
        var loading = false;
        var calls = 0;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  update = setState;
                  return Column(
                    children: [
                      TextButton(
                        focusNode: firstFocus,
                        onPressed: _noop,
                        child: const Text('First'),
                      ),
                      SocialButton.custom(
                        social: Social.google,
                        logo: const Icon(Icons.login),
                        focusNode: buttonFocus,
                        isLoading: loading,
                        onPressed: () => calls++,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
        firstFocus.requestFocus();
        await tester.pump();
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        expect(calls, 1);

        update(() => loading = true);
        await tester.pump();
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        expect(calls, 1);

        update(() => loading = false);
        await tester.pumpAndSettle();
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        expect(calls, 2);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('loading respects explicit focus changes and route navigation', (
    tester,
  ) async {
    final buttonFocus = FocusNode();
    final firstFocus = FocusNode();
    final otherFocus = FocusNode();
    addTearDown(buttonFocus.dispose);
    addTearDown(firstFocus.dispose);
    addTearDown(otherFocus.dispose);
    late StateSetter update;
    var loading = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return Column(
                children: [
                  TextButton(
                    focusNode: firstFocus,
                    onPressed: _noop,
                    child: const Text('First'),
                  ),
                  SocialButton.custom(
                    social: Social.google,
                    logo: const Icon(Icons.login),
                    focusNode: buttonFocus,
                    isLoading: loading,
                    onPressed: _noop,
                  ),
                  TextButton(
                    focusNode: otherFocus,
                    onPressed: _noop,
                    child: const Text('Other'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
    Future<void> focusButton() async {
      firstFocus.requestFocus();
      await tester.pump();
      buttonFocus.requestFocus();
      await tester.pump();
    }

    await focusButton();
    update(() => loading = true);
    await tester.pump();

    otherFocus.requestFocus();
    await tester.pump();
    firstFocus.requestFocus();
    await tester.pump();
    update(() => loading = false);
    await tester.pumpAndSettle();
    expect(firstFocus.hasPrimaryFocus, isTrue);

    // A form can focus its next field in the same frame as either transition.
    for (final moveOnStart in [true, false]) {
      await focusButton();
      update(() => loading = true);
      if (moveOnStart) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => otherFocus.requestFocus(),
        );
      }
      await tester.pump();
      update(() => loading = false);
      if (!moveOnStart) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => otherFocus.requestFocus(),
        );
      }
      await tester.pumpAndSettle();
      expect(
        otherFocus.hasPrimaryFocus,
        isTrue,
        reason: 'moveOnStart=$moveOnStart',
      );
    }

    await focusButton();
    update(() => loading = true);
    await tester.pump();
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.push<void>(
      MaterialPageRoute<void>(
        requestFocus: false,
        builder: (context) => const Scaffold(body: Text('Next screen')),
      ),
    );
    update(() => loading = false);
    await tester.pumpAndSettle();
    expect(find.text('Next screen'), findsOneWidget);
    expect(buttonFocus.hasPrimaryFocus, isFalse);
  });
}

void _noop() {}

# 에이전트 통합 프롬프트

다음 프롬프트는 미게시 로컬 패키지를 Flutter 앱에 연결할 때 사용합니다.
다른 컴퓨터에서는 패키지 경로만 실제 clone 경로로 바꾸세요.

35개 제공자 가운데 사용할 항목과 순서·배치·모양을 먼저 정하려면 정식
`landing/index.html` 선택기를 사용하세요. `?lang=en`과 `?lang=ko`로 언어를
바꿔도 선택 상태와 배치 설정은 유지됩니다. 선택기가 내보내는 텍스트에는 아래
공통 규칙과 함께 선택한 로고의 canonical 다운로드 URL, 출처, SHA-256,
라이선스, 공식/서드파티 구분, 앱 저장 경로, `pubspec` 항목, Dart 코드가
포함됩니다. JSON 매니페스트는 원본 형식을 그대로 기록하고, 필요한 경우 선택적
`archiveMember`·`archiveSha256`과
`rasterization { color?, width, height, preserveColors? }`도 보존합니다.
또한 `conditions`에서 식별 사용, 변형, 재배포 근거를 별도로 내보냅니다.
`official`은 파일 출처만 뜻하며 제공자 승인이나 재배포 허가를 뜻하지 않습니다.

선택기 전달문은 원본이 SVG이거나 아카이브 안에 있어도 다운로드가 PNG라고
가정하지 않습니다. 에이전트는 명시적 `rasterization`이 있는 SVG만 개발
환경의 기존 도구로 지정된 캔버스 PNG로 변환합니다. 직접 받은 PNG와 ZIP에서
추출한 PNG는 원본 바이트·크기·투명도·패딩을 그대로 보존하고 다시
리사이즈하거나 128px 캔버스에 재배치하지 않습니다. 기본값으로
`flutter_svg` 같은 런타임 의존성을 설치하지 않습니다.

```text
Integrate the unpublished local Flutter package `social_signin_kit` into the
current app.

Package path:
../social_signin_kit

Requirements:
1. Read the app's project instructions, pubspec, authentication entry points,
   asset conventions, and related tests before editing.
2. Add this local dependency without changing Flutter or Dart SDK constraints:

   dependencies:
     social_signin_kit:
       path: ../social_signin_kit

3. Use `fvm flutter` and `fvm dart` for commands. Don't use a pub.dev version or
   an unverified Git URL.
4. Import:

   import 'package:social_signin_kit/social_signin_kit.dart';

5. Use the current API:

   SocialButton(
     social: Social.notion,
     onPressed: isSigningIn ? null : startNotionSignIn,
   )

   `social` and `onPressed` are required. `onPressed: null` disables the button.
   The package doesn't own loading state and doesn't report authentication
   success.
6. The optional `logo` value is a String asset path in the consuming app:

   SocialButton(
     social: Social.google,
     logo: 'assets/brand/google.png',
     onPressed: startGoogleSignIn,
   )

   When `logo` is omitted, all 35 providers use PNGs bundled by the package.
   Google, Apple, Microsoft, Kakao, Naver, LINE, X, LinkedIn, Twitch, Spotify,
   and Bitbucket use reviewed provider-supplied originals. The other 24 use package adaptations rendered
   from pinned Simple Icons SVGs and are not official provider controls. No
   consuming-app asset setup is required for these defaults. Pass a permitted
   app asset path when the app has a different approved asset, and register
   only that override in the consuming app's pubspec.
7. Available shapes are:

   SocialButtonShape.rounded
   SocialButtonShape.pill
   SocialButtonShape.circle

   The standalone default is `rounded`. The default size is 48. `size` is the
   minimum labelled-button height and the circle diameter. Values below 48 keep
   a 48 logical pixel touch target. Labelled buttons can grow with text scaling.
8. Use lists for repeated buttons:

   SocialButtonList.vertical(
     spacing: 12,
     items: [
       SocialButton(
         social: Social.google,
         onPressed: startGoogleSignIn,
       ),
       SocialButton(
         social: Social.apple,
         onPressed: startAppleSignIn,
       ),
     ],
   )

   Vertical lists default to `rounded` and give items equal width. Horizontal
   lists default to `circle` and wrap onto another line. Both accept `shape`,
   `size`, `locale`, and `spacing`. Spacing defaults to 8. An explicitly
   circular item stays square in a vertical list.
9. Resolve shared values in this order:

   per-button value > list value > package default

10. Let the widget read the app locale unless this screen needs an explicit
    `locale`. Korean uses the Korean package label. Other locales fall back to
    English. Pass `label` when the app owns the wording or translation. Use
    `semanticLabel` only when the accessibility name must differ from the
    visible label.
11. Don't add `easy_localization` to this package. If the app already uses it,
    keep locale setup in the app:

    MaterialApp(
      locale: context.locale,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      home: SocialButton(
        social: Social.notion,
        label: 'auth.continue_with_notion'.tr(),
        onPressed: startNotionSignIn,
      ),
    )

12. Keep OAuth, OpenID, provider SDK calls, tokens, redirect handling, loading,
    duplicate-request prevention, and errors in the consuming app. The package
    only renders UI and invokes `onPressed`.
13. Treat provider colors, rounded or pill geometry, circle buttons, and
    interactive state styles as unofficial package choices. Use a provider's
    official complete button, SDK, generator, or QR surface when required.
14. Add or update focused app tests for the rendered provider, shape, locale,
    callback, disabled state, list layout, and asset path as relevant. Don't use
    fixed sleeps.
15. Run focused tests and `fvm flutter analyze`. Run the affected build when the
    app provides one. Report commands and exit codes without claiming that
    provider login works unless the real authentication flow was exercised.
16. Keep changes inside the consuming app's approved scope. Don't modify,
    publish, commit, or deploy the `social_signin_kit` package.

Before finishing, report:
- files changed
- provider, shape, size, and list layout used
- whether each logo used the package default or a caller-owned override
- tests, analysis, and build commands with exit codes
- authentication behavior actually exercised
- remaining asset-license, provider approval, app-review, and device checks
```

## 빠른 수동 확인

1. 좁은 화면과 넓은 화면에서 실제 로그인 화면을 엽니다.
2. 세로 목록은 같은 너비인지, 가로 목록은 공간이 부족할 때 줄바꿈되는지
   확인합니다.
3. `rounded`, `pill`, `circle` 중 사용한 모양과 크기를 확인합니다.
4. 한국어와 영어에서 기본 레이블을 확인합니다.
5. 활성 버튼의 콜백이 한 번 실행되는지 확인합니다.
6. 로딩 중 `onPressed: null`이 입력을 막는지 확인합니다.
7. 키보드 focus, 화면 읽기 이름, 원형 버튼 tooltip을 확인합니다.
8. 실제 인증 결과가 앱 인증 계층에서 오는지 확인합니다.

자동 테스트 통과, 사용자의 화면 확인, 제공자 승인, 운영 배포는 서로 다른
검증입니다.

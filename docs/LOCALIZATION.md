# 로컬라이제이션

패키지는 한국어와 영어 기본 레이블을 제공합니다. 별도 로컬라이제이션 패키지에
의존하지 않고 Flutter의 현재 `Locale`을 읽습니다.

## 기본 결정 순서

레이블과 locale은 다음 순서로 결정됩니다.

```text
버튼의 label
버튼의 locale
목록의 locale
앱의 현재 locale
영어 fallback
```

`Locale('ko')`와 `Locale('ko', 'KR')`는 한국어 레이블을 사용합니다. 그 외
언어는 영어 레이블을 사용합니다.

```dart
SocialButton(
  social: Social.kakao,
  locale: const Locale('ko'),
  onPressed: startKakaoSignIn,
)
```

## 앱 locale 자동 사용

보통 `locale`을 직접 전달할 필요가 없습니다. 위젯이
`Localizations`에서 앱의 현재 locale을 읽습니다.

```dart
MaterialApp(
  locale: currentLocale,
  supportedLocales: const [
    Locale('ko'),
    Locale('en'),
  ],
  home: SocialButton(
    social: Social.notion,
    onPressed: startNotionSignIn,
  ),
)
```

앱 언어가 바뀌어 위젯 트리가 다시 빌드되면 버튼 레이블도 새 locale에 맞게
바뀝니다.

## 목록 locale

같은 목록의 버튼에 하나의 locale을 적용할 수 있습니다.

```dart
SocialButtonList.vertical(
  locale: const Locale('ko'),
  items: [
    SocialButton(
      social: Social.google,
      onPressed: startGoogleSignIn,
    ),
    SocialButton(
      social: Social.notion,
      label: '워크스페이스 연결',
      onPressed: startNotionSignIn,
    ),
  ],
)
```

두 번째 항목의 `label`은 목록 locale보다 우선합니다.

## 앱 번역 문구 전달

앱이 지원하는 언어가 더 많거나 문구를 직접 관리한다면 `label`에 번역된
문자열을 전달하세요.

```dart
SocialButton(
  social: Social.github,
  label: appStrings.continueWithGitHub,
  onPressed: startGitHubSignIn,
)
```

이 문자열은 화면 레이블과 기본 접근성 이름에 사용되므로 짧고 명확하게
작성하세요. `circle`에서도 화면에는 보이지 않지만 tooltip과 접근성 이름으로
남습니다.

화면 문구와 다른 접근성 이름이 꼭 필요하면 `semanticLabel`을 전달합니다.

```dart
SocialButton(
  social: Social.github,
  label: 'GitHub로 계속',
  semanticLabel: '회사 GitHub 계정으로 로그인',
  onPressed: startGitHubSignIn,
)
```

`semanticLabel`은 접근성 이름과 `circle` tooltip에 사용되며 화면 레이블은
바꾸지 않습니다.

## `easy_localization`을 쓰는 앱

이 패키지는 `easy_localization`에 의존하지 않습니다. 소비 앱에서
`MaterialApp`에 locale과 delegate를 연결하고 번역된 `label`만 전달합니다.

```dart
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
```

따라서 패키지 사용만을 위해 `easy_localization`을 추가할 필요가 없습니다.

## 문구 선택 시 주의

- 패키지의 번역은 편의를 위한 기본값이며 제공자 승인 문구가 아닙니다.
- 제공자가 고정 CTA를 요구하면 공식 문구와 완성형 버튼을 우선하세요.
- `label`을 빈 문자열로 숨기지 말고 로고 전용 UI에는 `circle`을 사용하세요.
- 실제 인증 결과가 아닌 버튼 동작을 설명하는 문구를 사용하세요.

문구가 잘리거나 예상 언어가 나오지 않으면
[문제 해결](TROUBLESHOOTING.md)을 확인하세요.

# 이전 API에서 마이그레이션

초기 `0.1.0` API의 `SocialLoginButton`을 새 편의 API로 바꾸는 방법입니다.
기존 이름은 현재 호환 API로 export되므로 바로 깨지지는 않습니다. 새 목록,
문자열 로고 경로, 크기와 `pill` 모양을 사용하려면 아래처럼 옮기세요.

## 이름 변경

| 이전 | 현재 |
| --- | --- |
| `SocialLoginButton` | `SocialButton` |
| `SocialLoginProvider` | `Social` |
| `provider:` | `social:` |
| `SocialLoginButtonShape.rectangle` | `SocialButtonShape.rounded` |
| `SocialLoginButtonShape.circle` | `SocialButtonShape.circle` |

새 API에는 `SocialButtonShape.pill`과 `SocialButtonList`가 추가됐습니다.

## 가장 작은 변경

이전:

```dart
SocialLoginButton(
  provider: SocialLoginProvider.google,
  logo: Image.asset(
    'assets/social/google.png',
    fit: BoxFit.contain,
  ),
  onPressed: startGoogleSignIn,
)
```

현재:

```dart
SocialButton(
  social: Social.google,
  logo: 'assets/brand/google.png',
  onPressed: startGoogleSignIn,
)
```

현재 API의 `logo`는 필수 소비 앱 자산 경로 문자열입니다.
패키지에는 브랜드 이미지가 없으므로 앱이 파일을 취득하고
`flutter/assets`에 선언해야 합니다. 커스텀 위젯은 기존
`SocialLoginButton` API를 사용하세요.

```dart
SocialButton(
  social: Social.google,
  logo: 'assets/brand/google-mark.png',
  onPressed: startGoogleSignIn,
)
```

## 모양 변경

이전의 `rectangle`은 새 API에서 `rounded`입니다.

```dart
SocialButton(
  social: Social.microsoft,
  logo: 'assets/brand/microsoft.png',
  shape: SocialButtonShape.rounded,
  onPressed: startMicrosoftSignIn,
)
```

원형은 이름이 유지됩니다.

```dart
SocialButton(
  social: Social.apple,
  logo: 'assets/brand/apple.png',
  shape: SocialButtonShape.circle,
  onPressed: startAppleSignIn,
)
```

새 `pill`은 레이블이 있는 캡슐형 버튼입니다.

## 크기

이전 API는 공통 `48` 크기를 고정했습니다. 현재는 `size`로 높이 또는 원형
지름을 지정할 수 있습니다.

```dart
SocialButton(
  social: Social.naver,
  logo: 'assets/brand/naver.png',
  size: 56,
  onPressed: startNaverSignIn,
)
```

## 여러 버튼

직접 `Column`이나 `Row`로 간격과 모양을 반복 설정했다면 목록 API로 옮길 수
있습니다.

이전:

```dart
Column(
  children: [
    SocialLoginButton(
      provider: SocialLoginProvider.google,
      logo: googleLogo,
      onPressed: startGoogleSignIn,
    ),
    const SizedBox(height: 12),
    SocialLoginButton(
      provider: SocialLoginProvider.apple,
      logo: appleLogo,
      onPressed: startAppleSignIn,
    ),
  ],
)
```

현재:

```dart
SocialButtonList.vertical(
  spacing: 12,
  items: [
    SocialButton(
      social: Social.google,
      logo: 'assets/brand/google.png',
      onPressed: startGoogleSignIn,
    ),
    SocialButton(
      social: Social.apple,
      logo: 'assets/brand/apple.png',
      onPressed: startAppleSignIn,
    ),
  ],
)
```

세로 목록은 항목을 같은 너비로 맞춥니다. 가로 목록은 기본 `circle`과
`Wrap` 배치를 사용합니다.

## locale과 레이블

`locale`과 `label`의 역할은 유지됩니다. 목록에서 공통 locale을 지정할 수
있고, 개별 버튼의 `label`이 가장 우선합니다.

이전 API의 `semanticLabel`은 새 API에서도 사용할 수 있습니다. 화면 문구는
`label`, 화면 읽기 이름과 `circle` tooltip은 `semanticLabel`로 분리할 수
있습니다.

## 비활성과 로딩

비활성 방식은 그대로 `onPressed: null`입니다.

```dart
SocialButton(
  social: Social.notion,
  logo: 'assets/brand/notion.png',
  onPressed: isSigningIn ? null : startNotionSignIn,
)
```

새 API도 로딩 상태를 소유하지 않습니다. 기존 앱의 로딩과 오류 처리를
유지하세요.

## 마이그레이션 확인표

- import는 `package:social_signin_kit/social_signin_kit.dart` 하나로
  유지합니다.
- `SocialLoginButton`을 `SocialButton`으로 바꿉니다.
- `provider`를 `social`로 바꿉니다.
- `SocialLoginProvider`를 `Social`로 바꿉니다.
- `rectangle`을 `rounded`로 바꿉니다.
- `Image.asset` 위젯 대신 앱에서 선언한 필수 문자열 경로를 전달합니다.
- 반복된 세로와 가로 레이아웃을 목록 API로 바꿀지 결정합니다.
- 비활성, locale, 접근성 이름, 콜백을 실제 화면에서 확인합니다.
- 앱의 관련 테스트와 `fvm flutter analyze`를 실행합니다.

문제가 생기면 [문제 해결](TROUBLESHOOTING.md)을 확인하세요.

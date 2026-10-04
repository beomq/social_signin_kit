# social_signin_kit

Flutter 앱에서 35개 소셜 서비스의 로그인 버튼을 일관된 API로 표시하는
UI 패키지입니다. 버튼을 누르면 앱이 전달한 콜백만 실행합니다.
OAuth, 토큰, 네트워크 요청, 로딩 상태는 앱에서 관리합니다.

[랜딩페이지](https://beomq.github.io/social_signin_kit/landing/index.html) · [GitHub 저장소](https://github.com/beomq/social_signin_kit) · [pub.dev](https://pub.dev/packages/social_signin_kit)

> 이 패키지의 색상, 모양, 상태 스타일은 공식 인증을 뜻하지 않습니다.
> 패키지는 35개 제공자의 UI 스타일·한국어/영어 문구만 제공합니다.
> 브랜드 로고 이미지를 포함하지 않습니다. 앱에서 사용 권한을 확인한
> 이미지 경로를 필수 `logo`로 전달하세요. 외형은 패키지 프리셋이며
> 제공자의 승인된 로그인 컨트롤이나 인증 구현을 보장하지 않습니다.

## 로그인 화면 선택기

`landing/index.html`은 35개 제공자의 실제 로컬 로고를 보면서 소비 앱의
로그인 화면을 구성하는 정식 선택기입니다. `?lang=en`과 `?lang=ko`로 언어를
바꾸며 선택 상태와 배치 설정은 그대로 유지됩니다. 저장소 루트에서 정적 HTTP
서버를 실행한 뒤 `landing/`을 여세요. `file://`에서는 브라우저의 `fetch`
제한 때문에 `landing/logo-catalog.json`을 읽지 못할 수 있습니다.

선택기에서 다음을 한 번에 정할 수 있습니다.

- 사용할 제공자와 화면 표시 순서
- 세로/가로 목록
- `rounded`/`pill`/`circle` 모양
- 실제 로고를 사용한 미리보기
- 소비 앱의 명시적 로고 경로가 포함된 Dart 코드
- 에이전트용 작업 지시 텍스트와 JSON 매니페스트

내보낸 전달문은 현재 앱에서 이미 사용할 수 있는 패키지 의존성을
찾도록 지시합니다. 존재하지 않는 버전이나 GitHub URL을 만들지 않습니다. 또한 각 로고의 출처 페이지, canonical 다운로드 URL, 원본 형식,
SHA-256, 라이선스, 공식/서드파티 구분, 저장 경로를 포함합니다.
카탈로그의 `archiveMember`·`archiveSha256`과
`rasterization { color, width, height }`가 있으면 그대로 보존하며,
상대 다운로드 URL은 현재 랜딩 문서를 기준으로 해석합니다. localhost URL은
같은 머신에서만 유효하다고 표시하고 에이전트가 기존 변환 도구로 앱용 PNG를
만들도록 안내합니다. 내보낼 때 ZIP 다운로드 해시와 추출 멤버 해시를 별도
필드로 구분합니다. 래스터화는 명시적 메타데이터가 있는 SVG에만 적용합니다.
직접 받은 PNG와 ZIP에서 추출한 PNG는 크기·투명도·내부 패딩을 포함한 원본
바이트를 그대로 보존하며 128px 캔버스로 다시 배치하지 않습니다.
기본값으로 `flutter_svg` 같은 런타임 의존성을 추가하지 않습니다.

생성된 콜백 이름은 연결 위치를 보여주는 자리표시자입니다. 소비 앱의 기존
로그인 또는 연결 함수로 바꿔야 하며, 선택기는 OAuth·토큰·리다이렉트 코드를
생성하거나 원격 에이전트를 실행하지 않습니다.

선택기가 내보낸 Dart는 미리보기와 같은 언어를 재현하도록
`locale: const Locale('en')` 또는 `locale: const Locale('ko')`를 명시하고,
매니페스트와 에이전트 전달문에도 같은 locale을 기록합니다. 소비 앱의 현재
locale을 자동으로 상속하려면 통합할 때 이 명시적 `locale` 인자만 제거하세요.

## 빠른 시작

소비 앱의 `pubspec.yaml`에 패키지 의존성을 추가합니다.

```yaml
dependencies:
  social_signin_kit: ^0.1.0
```

로컬 clone을 사용하려면 위 버전 항목 대신 아래 경로 의존성을 사용합니다.
`/absolute/path/to/social_signin_kit`은 실제 clone 경로로 바꾸세요.
앱의 형제 디렉터리에 둘 필요는 없습니다.

```yaml
dependencies:
  social_signin_kit:
    path: /absolute/path/to/social_signin_kit
```

선택한 의존성을 저장한 뒤 앱 디렉터리에서 다음 명령을 실행합니다.

```sh
fvm flutter pub get
```

이 패키지를 추가하려고 앱의 Flutter 또는 Dart SDK 제약을 올리지 마세요.

## 앱에서 로고 제공하기

`SocialButton.logo`는 필수 소비 앱 이미지 자산 경로입니다. 앱의
`pubspec.yaml`에 선언하며 패키지 자산 경로나 자동 로고 대체가 없습니다.

```yaml
flutter:
  assets:
    - assets/brand/
```

패키지는 로고를 재색칠·자르지 않으며 `BoxFit.contain`으로 표시합니다.
라이트·다크 모드에서 필요한 파일을 앱이 직접 선택하세요. 가로 마크는
`logoAspectRatio`에 원본 너비/높이를 전달하면 일반 버튼에서 비율을 유지합니다.
기본값은 1이고 원형 버튼은 정사각형 슬롯 안에 전체 이미지를 표시합니다.
커스텀 위젯은 `SocialLoginButton(logo: widget, ...)`로 전달할 수 있습니다.

브랜드 파일의 사용 조건은 앱에서 별도로 확인해야 합니다.
[로고 조건과 기존 자산 기록](https://github.com/beomq/social_signin_kit/blob/main/docs/ASSETS.md)은
저장소 참고 자료이며 패키지 번들 또는 사용 허가가 아닙니다.

## 버튼 하나 사용하기

```dart
import 'package:flutter/material.dart';
import 'package:social_signin_kit/social_signin_kit.dart';

SocialButton(
  social: Social.notion,
  logo: 'assets/brand/notion.png',
  onPressed: startNotionSignIn,
)
```

기본값은 다음과 같습니다.

- 모양: `SocialButtonShape.rounded`
- 표시 모드: `SocialButtonAppearance.providerDefault`
- 높이와 원형 지름: `48`
- 로고: 앱에서 전달한 필수 이미지 자산 경로
- 언어: 현재 앱의 `Locale`, 한국어 외 언어는 영어

`size`가 `48`보다 작아도 최소 터치 영역은 48 logical pixel을 유지합니다.
레이블 버튼은 텍스트 배율에 따라 지정한 높이보다 커질 수 있습니다.

모양과 크기를 바꿀 수 있습니다.

```dart
SocialButton(
  social: Social.apple,
  logo: 'assets/brand/apple.png',
  onPressed: startAppleSignIn,
  shape: SocialButtonShape.pill,
  size: 56,
)
```

공식 출처로 확인된 제공자는 `light`/`dark` 표시 모드를 선택할 수 있습니다.
지원 목록은 `socialLoginProviderData(Social.notion).capabilities.appearances`로
확인할 수 있습니다. 외형 설정은 배경·문자·테두리에만 적용됩니다.
로고 경로와 색상은 앱의 책임이며 자동으로 교체하거나 색칠하지 않습니다.
지원되지 않은 외형을 요청하면 제공자 기본 외형으로 돌아가며 디버그에서
한 번 안내합니다. 프로파일·릴리스에서는 출력하지 않습니다. 앱이 명시한 `logo` 경로는 유지합니다.

```dart
SocialButton(
  social: Social.google,
  logo: 'assets/brand/google.png',
  appearance: SocialButtonAppearance.dark,
  onPressed: startGoogleSignIn,
)
```

`circle`은 화면 레이블을 숨기지만 tooltip과 접근성 이름은 유지합니다.

```dart
SocialButton(
  social: Social.github,
  logo: 'assets/brand/github.png',
  onPressed: startGitHubSignIn,
  shape: SocialButtonShape.circle,
)
```

형태 지원 상태는
`socialLoginProviderData(provider).capabilities.shapes`에서 확인합니다.
`unverified`는 금지가 아니라 패키지 맞춤 스타일이며 요청한 형태를 그대로
렌더링합니다. `restricted`도 런타임 금지가 아니라 제공자 규칙과 충돌한다는
경고용 메타데이터이며, 요청한 형태를 그대로 렌더링합니다. 현재 Kakao의
`pill`과 `circle`은 고정 12px 컨테이너 반경과 충돌하는 비공식 커스텀
표현이므로 출시 전 해당 제공자 규칙을 확인해야 합니다.

## 세로 목록

세로 목록은 기본적으로 `rounded` 모양을 사용하며, 같은 너비로 정렬됩니다.

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
    SocialButton(
      social: Social.notion,
      logo: 'assets/brand/notion.png',
      onPressed: startNotionSignIn,
    ),
  ],
)
```

목록의 공통 설정은 각 버튼에 기본값처럼 적용됩니다.

```dart
SocialButtonList.vertical(
  shape: SocialButtonShape.pill,
  appearance: SocialButtonAppearance.dark,
  size: 56,
  locale: const Locale('ko'),
  spacing: 8,
  items: [
    SocialButton(
      social: Social.kakao,
      logo: 'assets/brand/kakao.png',
      onPressed: startKakaoSignIn,
    ),
    SocialButton(
      social: Social.naver,
      logo: 'assets/brand/naver.png',
      onPressed: startNaverSignIn,
      size: 48,
    ),
  ],
)
```

설정 우선순위는 `각 버튼 > 목록 > 패키지 기본값`입니다. `appearance`도 같은
규칙을 따릅니다. 위 예제에서 Naver 버튼 크기만 `48`이고 나머지는 목록의
`56`을 사용합니다.

## 가로 목록

가로 목록은 기본적으로 `circle`을 사용하고, 공간이 부족하면 `Wrap`처럼 다음
줄로 넘어갑니다.

```dart
SocialButtonList.horizontal(
  spacing: 8,
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
    SocialButton(
      social: Social.notion,
      logo: 'assets/brand/notion.png',
      onPressed: startNotionSignIn,
    ),
  ],
)
```

## 언어와 문구

`locale`을 생략하면 앱의 현재 locale을 사용합니다. `ko`는 한국어 레이블을,
그 외 언어는 영어 레이블을 사용합니다.

```dart
SocialButton(
  social: Social.notion,
  logo: 'assets/brand/notion.png',
  onPressed: startNotionSignIn,
  label: '팀 Notion으로 계속',
)
```

`label`을 직접 전달하면 기본 번역보다 우선합니다. 앱이
`easy_localization`을 사용한다면 패키지 의존성을 추가하지 않고 앱에서
번역한 문자열만 넘깁니다.

```dart
MaterialApp(
  locale: context.locale,
  localizationsDelegates: context.localizationDelegates,
  supportedLocales: context.supportedLocales,
  home: SocialButton(
    social: Social.notion,
    logo: 'assets/brand/notion.png',
    label: 'auth.continue_with_notion'.tr(),
    onPressed: startNotionSignIn,
  ),
)
```

자세한 규칙은 [로컬라이제이션](https://github.com/beomq/social_signin_kit/blob/main/docs/LOCALIZATION.md)을 참고하세요.

## 비활성과 로딩

`onPressed: null`이면 버튼이 비활성화됩니다. 패키지는 `isLoading` 상태를
갖지 않습니다. 요청 중 상태와 중복 요청 방지는 앱이 관리합니다.

```dart
SocialButton(
  social: Social.naver,
  logo: 'assets/brand/naver.png',
  onPressed: isSigningIn ? null : startNaverSignIn,
)
```

로딩 표시가 필요하면 앱 화면에서 별도 진행 표시를 제공하세요. 일부 제공자는
공개된 상태·간격·크기 값을 렌더러에 반영하고, 나머지는 제공자 팔레트에서
패키지 상태를 계산합니다. 이 구현이 제공자의 완성형 컨트롤 인증을 보장하지는
않습니다.
자세한 내용은 [상태와 접근성](https://github.com/beomq/social_signin_kit/blob/main/docs/STATES.md)을 참고하세요.

## 지원 범위

- `Social`은 기존 34개 제공자와 `notion`을 포함합니다.
- 패키지는 UI 렌더링과 `onPressed` 호출만 담당합니다.
- 제공자 원본을 포함한 모든 자산의 실제 사용 조건과 인증 SDK, OAuth, 토큰, 오류
  화면, 로딩 상태는 앱 책임입니다.
- 공식 완성형 버튼이나 SDK 제어가 필수인 제공자는 해당 공식 구현을
  사용하세요.

## 상세 문서

- [API](https://github.com/beomq/social_signin_kit/blob/main/docs/API.md)
- [로컬라이제이션](https://github.com/beomq/social_signin_kit/blob/main/docs/LOCALIZATION.md)
- [에셋](https://github.com/beomq/social_signin_kit/blob/main/docs/ASSETS.md)
- [상태와 접근성](https://github.com/beomq/social_signin_kit/blob/main/docs/STATES.md)
- [문제 해결](https://github.com/beomq/social_signin_kit/blob/main/docs/TROUBLESHOOTING.md)
- [이전 API에서 마이그레이션](https://github.com/beomq/social_signin_kit/blob/main/docs/MIGRATION.md)
- [제공자별 출처와 한계](https://github.com/beomq/social_signin_kit/blob/main/docs/PROVIDER_GUIDE.md)
- [테마·형태 지원 근거](https://github.com/beomq/social_signin_kit/blob/main/research/theme-shape-support.md)
- [에이전트 통합 프롬프트](https://github.com/beomq/social_signin_kit/blob/main/docs/AGENT_SETUP.md)
- [웹 선택기 자산 계약](https://github.com/beomq/social_signin_kit/blob/main/docs/LANDING_ASSETS.md)

## 게시 준비와 검증

게시 전
`fvm flutter pub publish --dry-run`의 포함 파일과 경고를 확인하세요.
코드 전용 패키지는 브랜드 이미지·취득 기록을 배포하지 않습니다.
[게시 검증 기록](https://github.com/beomq/social_signin_kit/blob/main/docs/PUBLISHING.md)을 참고하세요.

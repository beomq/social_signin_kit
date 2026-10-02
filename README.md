# social_signin_kit

Flutter 앱에서 35개 소셜 서비스의 로그인 버튼을 일관된 API로 표시하는
미게시 UI 패키지입니다. 버튼을 누르면 앱이 전달한 콜백만 실행합니다.
OAuth, 토큰, 네트워크 요청, 로딩 상태는 앱에서 관리합니다.

[pub.dev 게시 예정 주소](https://pub.dev/packages/social_signin_kit) · [GitHub 생성 예정 저장소](https://github.com/beomq/social_signin_kit)
아직 게시되지 않았으므로 예정 링크는 현재 설치 가능한 릴리스를 뜻하지 않습니다.

> 이 패키지의 색상, 모양, 상태 스타일은 공식 인증을 뜻하지 않습니다.
> 35개 제공자 모두 정적 PNG를 포함하지만 출처가 다릅니다. Google, Apple,
> Microsoft, Kakao, Naver, LINE, X, LinkedIn, Twitch, Spotify, Bitbucket, GitHub는
> 검토된 제공자 원본이고, 나머지 23개 기본값은 고정된 Simple Icons SVG에서 만든
> 패키지용 단색 PNG입니다. `official`은 파일 출처만 뜻하며 제공자 승인이나
> 재배포 허가를 뜻하지 않습니다. 출시 전
> [제공자 자산 가이드](docs/PROVIDER_GUIDE.md)와 각 제공자의 최신 규칙을
> 확인하세요.

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

내보낸 전달문은 현재 앱에서 이미 사용할 수 있는 이 미게시 패키지 의존성을
찾도록 지시합니다. pub.dev 버전이나 게시되지 않은 GitHub URL을 만들지
않습니다. 또한 각 로고의 출처 페이지, canonical 다운로드 URL, 원본 형식,
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

소비 앱의 `pubspec.yaml`에 로컬 경로 의존성을 추가합니다.

```yaml
dependencies:
  social_signin_kit:
    path: ../social_signin_kit
```

다른 컴퓨터에서는 실제 clone 경로로 바꾸고 다음 명령을 실행합니다.

```sh
fvm flutter pub get
```

이 패키지를 추가하려고 앱의 Flutter 또는 Dart SDK 제약을 올리지 마세요.

## 기본 로고

`logo`를 생략하면 별도 앱 자산 설정 없이 패키지가 35개 제공자별
제공자별 번들 PNG를 사용합니다. 이 중 제공자 원본 12개는 다음과
같습니다.

| 제공자 | 패키지 자산 |
| --- | --- |
| Google | `assets/social/google.png` |
| Apple | `assets/social/apple.png` |
| Microsoft | `assets/social/microsoft.png` |
| Kakao | `assets/social/kakao.png` |
| Naver | `assets/social/naver.png` |
| LINE | `assets/social/line.png` |
| X | `assets/social/x.png` |
| LinkedIn | `assets/social/linkedin.png` |
| Twitch | `assets/social/twitch.png` |
| Spotify | `assets/social/spotify.png` |
| Bitbucket | `assets/social/bitbucket.png` |
| GitHub | `assets/original/github/GitHub_Invertocat_White.png` |

Notion을 포함한 나머지 23개 기본값은 고정된 Simple Icons SVG를
`foreground` 색상의 투명 128×128 PNG로 빌드한 패키지 기본값입니다.
Simple Icons 배포 파일은 제공자 원본이나 공식 로그인 컨트롤이 아니며,
저장소 라이선스와 개별 상표 조건은 별도로 확인해야 합니다. 앱에서 사용
권한을 확인한 다른 자산이 있다면 `logo`에 소비 앱의 문자열 에셋 경로를
전달할 수 있습니다.

```dart
SocialButton(
  social: Social.notion,
  logo: 'assets/brand/notion.png',
  onPressed: startNotionSignIn,
)
```

명시적 `logo`는 패키지 기본값보다 항상 우선하며 소비 앱 자산으로
해석됩니다. 지원 근거와 원본 해시는 [에셋 가이드](docs/ASSETS.md)와
[자산 매니페스트](assets/README.md)를 참고하세요.

## 버튼 하나 사용하기

```dart
import 'package:flutter/material.dart';
import 'package:social_signin_kit/social_signin_kit.dart';

SocialButton(
  social: Social.notion,
  onPressed: startNotionSignIn,
)
```

기본값은 다음과 같습니다.

- 모양: `SocialButtonShape.rounded`
- 표시 모드: `SocialButtonAppearance.providerDefault`
- 높이와 원형 지름: `48`
- 로고: 35개 제공자별 패키지 기본 PNG
- 언어: 현재 앱의 `Locale`, 한국어 외 언어는 영어

`size`가 `48`보다 작아도 최소 터치 영역은 48 logical pixel을 유지합니다.
레이블 버튼은 텍스트 배율에 따라 지정한 높이보다 커질 수 있습니다.

모양과 크기를 바꿀 수 있습니다.

```dart
SocialButton(
  social: Social.apple,
  onPressed: startAppleSignIn,
  shape: SocialButtonShape.pill,
  size: 56,
)
```

공식 출처로 확인된 제공자는 `light`/`dark` 표시 모드를 선택할 수 있습니다.
지원 목록은 `socialLoginProviderData(Social.notion).capabilities.appearances`로
확인할 수 있습니다. GitHub는 light에서 검정, dark에서 흰 공식 원본을 선택하며,
Google과 Microsoft는 컬러 원본을 유지합니다. 제공자별 지원·취득 경로는
[다운로드 가이드](DOWNLOAD_GUIDE.md)를 참고하세요.
Apple light는 공식 `color=white` 생성 endpoint의 흰 컨트롤·검은 글리프
원본을 사용하며, 기존 검정 PNG를 반전하거나 색칠하지 않습니다. 흰 Apple
스타일은 주변 배경과 충분한 대비를 확보해야 합니다. 지원하지 않는 모드를
요청하면 검증되지 않은 색을 만들지 않고 `providerDefault`로 결정됩니다.
디버그 모드에서는 제공자·요청 외형 조합마다 한 번 콘솔에 fallback 이유와
지원 목록을 표시합니다. 목록에서 상속받은 외형에도 동일하게 적용되며,
프로파일·릴리스에서는 출력하지 않습니다. 앱이 명시한 `logo` 경로는 유지합니다.

```dart
SocialButton(
  social: Social.google,
  appearance: SocialButtonAppearance.dark,
  onPressed: startGoogleSignIn,
)
```

`circle`은 화면 레이블을 숨기지만 tooltip과 접근성 이름은 유지합니다.

```dart
SocialButton(
  social: Social.github,
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
      onPressed: startGoogleSignIn,
    ),
    SocialButton(
      social: Social.apple,
      onPressed: startAppleSignIn,
    ),
    SocialButton(
      social: Social.notion,
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
      onPressed: startKakaoSignIn,
    ),
    SocialButton(
      social: Social.naver,
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
      onPressed: startGoogleSignIn,
    ),
    SocialButton(
      social: Social.apple,
      onPressed: startAppleSignIn,
    ),
    SocialButton(
      social: Social.notion,
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
    label: 'auth.continue_with_notion'.tr(),
    onPressed: startNotionSignIn,
  ),
)
```

자세한 규칙은 [로컬라이제이션](docs/LOCALIZATION.md)을 참고하세요.

## 비활성과 로딩

`onPressed: null`이면 버튼이 비활성화됩니다. 패키지는 `isLoading` 상태를
갖지 않습니다. 요청 중 상태와 중복 요청 방지는 앱이 관리합니다.

```dart
SocialButton(
  social: Social.naver,
  onPressed: isSigningIn ? null : startNaverSignIn,
)
```

로딩 표시가 필요하면 앱 화면에서 별도 진행 표시를 제공하세요. 일부 제공자는
공개된 상태·간격·크기 값을 렌더러에 반영하고, 나머지는 제공자 팔레트에서
패키지 상태를 계산합니다. 이 구현이 제공자의 완성형 컨트롤 인증을 보장하지는
않습니다.
자세한 내용은 [상태와 접근성](docs/STATES.md)을 참고하세요.

## 지원 범위

- `Social`은 기존 34개 제공자와 `notion`을 포함합니다.
- 패키지는 UI 렌더링과 `onPressed` 호출만 담당합니다.
- 제공자 원본을 포함한 모든 자산의 실제 사용 조건과 인증 SDK, OAuth, 토큰, 오류
  화면, 로딩 상태는 앱 책임입니다.
- 공식 완성형 버튼이나 SDK 제어가 필수인 제공자는 해당 공식 구현을
  사용하세요.

## 상세 문서

- [API](docs/API.md)
- [로컬라이제이션](docs/LOCALIZATION.md)
- [에셋](docs/ASSETS.md)
- [상태와 접근성](docs/STATES.md)
- [문제 해결](docs/TROUBLESHOOTING.md)
- [이전 API에서 마이그레이션](docs/MIGRATION.md)
- [제공자별 출처와 한계](docs/PROVIDER_GUIDE.md)
- [테마·형태 지원 근거](research/theme-shape-support.md)
- [에이전트 통합 프롬프트](docs/AGENT_SETUP.md)
- [웹 선택기 자산 계약](docs/LANDING_ASSETS.md)

## 게시 상태

이 패키지는 pub.dev에 게시되지 않았습니다. 커밋, 배포, 실제 인증 성공 여부는
버튼 렌더링과 별도로 확인해야 합니다.

# API

이 문서는 공개 위젯의 역할과 설정 우선순위를 설명합니다. 설치와 첫 예제는
[README](../README.md)를 먼저 보세요.

## `SocialButton`

```dart
SocialButton(
  social: Social.notion,
  logo: 'assets/brand/notion.png',
  onPressed: startNotionSignIn,
  shape: SocialButtonShape.rounded,
  appearance: SocialButtonAppearance.providerDefault,
  size: 48,
  locale: const Locale('ko'),
  label: 'Notion으로 계속',
)
```

| 인자 | 타입 | 설명 |
| --- | --- | --- |
| `social` | `Social` | 표시할 제공자, 필수 |
| `onPressed` | `VoidCallback?` | 앱의 인증 진입 콜백, `null`이면 비활성 |
| `logo` | `String` | 필수 소비 앱 이미지 자산 경로 |
| `logoAspectRatio` | `double` | 원본 너비/높이 비율, 기본 1; 원형은 정사각형 슬롯 |
| `shape` | `SocialButtonShape?` | `rounded`, `pill`, `circle` |
| `appearance` | `SocialButtonAppearance?` | `providerDefault`, `light`, `dark` |
| `size` | `double?` | 버튼 높이, `circle`에서는 지름 |
| `locale` | `Locale?` | 기본 레이블을 고를 locale |
| `label` | `String?` | 화면과 기본 접근성 이름에 사용할 앱 소유 문구 |
| `semanticLabel` | `String?` | 화면 문구와 다른 접근성 이름이 필요할 때 사용 |

`logo`는 필수 소비 앱 자산 경로이며 자동 선택·재색칠하지 않습니다.
단독 버튼의 선택 인자를 생략하면 다음 기본값을 사용합니다.

- `shape`: `SocialButtonShape.rounded`
- `appearance`: `SocialButtonAppearance.providerDefault`
- `size`: `48`
- `locale`: 가장 가까운 앱 locale, 없으면 영어
- `label`: 제공자와 locale에 맞는 패키지 기본 레이블

`onPressed`는 인증 성공 콜백이 아닙니다. 패키지는 콜백을 호출할 뿐이며 인증
결과를 알 수 없습니다.

지원하지 않는 `appearance`도 컴파일되지만 실제 표시는 `providerDefault`를
유지합니다. 디버그 콘솔에는 제공자·요청 외형 조합당 한 번 안내합니다.
프로파일·릴리스 로그는 없습니다. 지원 여부는 제공자 데이터의
`capabilities.appearances`로 확인합니다.

`size`는 양수이고 유한해야 합니다. 값이 `48`보다 작아도 최소 48 logical
pixel 터치 영역을 유지합니다. 레이블 버튼은 큰 텍스트가 잘리지 않도록 지정한
높이보다 커질 수 있습니다.

## `SocialButtonShape`

```dart
SocialButtonShape.rounded
SocialButtonShape.pill
SocialButtonShape.circle
```

- `rounded`: 모서리가 둥근 레이블 버튼입니다.
- `pill`: 양 끝이 둥근 레이블 버튼입니다.
- `circle`: 로고만 보이는 원형 버튼입니다. 결정된 레이블은 tooltip과 접근성
  이름에 사용됩니다.

모양은 패키지의 공통 UI 옵션입니다. 제공자 승인이나 브랜드 규격 준수를
뜻하지 않습니다.

## `SocialButtonAppearance`

```dart
SocialButtonAppearance.providerDefault
SocialButtonAppearance.light
SocialButtonAppearance.dark
```

- `providerDefault`: 기존 제공자 프리셋을 그대로 사용합니다.
- `light`, `dark`: 현재 제공자 데이터에 등록된 외형만 적용합니다.
  공식 로그인 컨트롤뿐 아니라 일반 브랜드 자산과 패키지 맞춤 스타일을
  근거로 한 외형도 포함되며, 제공자 승인을 뜻하지 않습니다.

현재 GitHub, Microsoft, X, LINE, Discord, LinkedIn, Slack, Twitch,
Spotify, Reddit, GitLab, Bitbucket, Telegram, Weibo, Kakao, Naver,
Google, Apple은 `light`와 `dark`를 지원합니다. PayPal은 `light`만
지원하며 나머지 16개는 `providerDefault`만 지원합니다.
로고는 외형과 별개이며, 앱에서 해당 모드에 사용할 파일을 직접 선택합니다.
지원하지 않는 제공자에 명시해도 검증되지 않은 팔레트를 만들지 않고
`providerDefault`로 결정됩니다. 단일 버튼의 명시값은 목록의 값을 덮어씁니다.

## 제공자 capability와 형태 fallback

```dart
final capabilities =
    socialLoginProviderData(Social.kakao).capabilities;
final status = capabilities.shapeSupport(SocialButtonShape.circle);
final effective =
    capabilities.effectiveShape(SocialButtonShape.circle);
```

`SocialButtonSupport`의 의미는 다음과 같습니다.

- `supported`: 공식 출처가 해당 형태를 문서화합니다.
- `restricted`: 공식 인증 컨트롤 규칙과 해당 형태가 충돌합니다.
- `unverified`: 공식 형태 규칙을 확인하지 못했습니다. 금지가 아니며 패키지
  맞춤 스타일로 요청한 형태를 렌더링합니다.

`shapeSupport`와 `shapeReasons`는 경고를 만들기 위한 근거 메타데이터입니다.
`effectiveShape`은 `supported`, `unverified`, `restricted` 상태와 무관하게
호출자가 요청한 형태를 반환합니다. 현재 Kakao의 `pill`과 `circle`은 12px
컨테이너 반경 규칙과 충돌하는 비공식 커스텀 표현이지만 런타임에서 금지하지
않습니다. Google의 원형 액션 버튼, Slack의 아이콘 전용 버튼, Apple의 로고
전용 생성 컨트롤처럼 근거가 있는 형태도 그대로 유지됩니다.

## `SocialButtonList.vertical`

```dart
SocialButtonList.vertical(
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
  shape: SocialButtonShape.rounded,
  appearance: SocialButtonAppearance.providerDefault,
  size: 48,
  locale: const Locale('ko'),
  spacing: 12,
)
```

세로 목록은 항목을 같은 너비로 정렬합니다. 목록의 기본 모양은
`rounded`입니다. 단, 개별 버튼이 `circle`을 명시하면 원형 크기를 유지합니다.

## `SocialButtonList.horizontal`

```dart
SocialButtonList.horizontal(
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
  spacing: 8,
)
```

가로 목록의 기본 모양은 `circle`입니다. 사용 가능한 가로 공간을 넘으면
`Wrap` 방식으로 다음 줄에 배치됩니다.

## 목록 공통 인자

| 인자 | 설명 |
| --- | --- |
| `items` | 렌더링할 `SocialButton` 목록 |
| `shape` | 항목이 따로 지정하지 않았을 때 쓸 모양 |
| `appearance` | 항목이 따로 지정하지 않았을 때 쓸 표시 모드 |
| `size` | 항목이 따로 지정하지 않았을 때 쓸 크기 |
| `locale` | 항목이 따로 지정하지 않았을 때 쓸 locale |
| `spacing` | 항목과 가로 줄 사이 간격, 기본값 `8` |

설정 우선순위는 항상 다음과 같습니다.

```text
각 SocialButton 설정 > SocialButtonList 설정 > 패키지 기본값
```

한 항목만 다른 크기나 모양을 써야 할 때 목록을 나누지 말고 해당 버튼에서
값을 지정하세요.

`size`는 양수이고 유한해야 하며, `spacing`은 0 이상인 유한한 값이어야
합니다. 부모가 가로로 무한한 제약을 주면 목록은 280 logical pixel을 사용하며
스크롤은 직접 만들지 않습니다.

## `Social`

지원 식별자는 기존 34개와 `notion`을 합한 35개입니다.

```text
facebook, github, microsoft, x, line, discord, linkedin, slack,
twitch, spotify, steam, reddit, dropbox, gitlab, bitbucket, paypal,
telegram, instagram, wechat, pinterest, snapchat, vk, weibo, qq,
epicGames, playstation, nintendo, xbox, zoom, kakao, naver, google,
apple, tiktok, notion
```

패키지는 브랜드 이미지와 번들 로고 메타데이터를 배포하지 않습니다.
`SocialLoginProviderData`는 제공자 문구·팔레트·지원 근거를 제공합니다.
앱에서 로고를 취득하고 자산 선언·사용 조건을 확인하세요.

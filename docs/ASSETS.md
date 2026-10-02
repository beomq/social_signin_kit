# 로고 에셋

`social_signin_kit`는 35개 제공자의 기본 PNG를 포함합니다. 12개는
provider-supplied 원본 기반이고 23개는 고정된 Simple Icons SVG에서 만든 패키지
기본값입니다. 소비 앱은 별도 자산 설정 없이 사용할 수 있습니다.

## 기본 번들

`logo`를 생략했을 때 다음 패키지 자산을
`package: 'social_signin_kit'`로 읽습니다.

| 제공자 | 경로 | 공식 제공 형태 |
| --- | --- | --- |
| Google | `assets/social/google.png` | standalone standard-color gradient G |
| GitHub default/dark | `assets/original/github/GitHub_Invertocat_White.png` | official white Invertocat PNG, byte-for-byte |
| GitHub light | `assets/original/github/GitHub_Invertocat_Black.png` | official black Invertocat PNG, byte-for-byte |
| Apple default/dark | `assets/social/apple.png` | generated black-button logo, 44@2x |
| Apple light | `assets/social/apple-light.png` | generated white-button logo with black glyph, 44@2x |
| Kakao | `assets/social/kakao.png` | `kakao_login_light.png`, PNG 4x |
| Naver | `assets/social/naver.png` | dark green icon, H56; dominant opaque source pixel `#05AC4F` |
| LINE | `assets/social/line.png` | desktop logo, 44dp@2x |
| Microsoft | `assets/social/microsoft.png` | separately supplied four-color symbol |
| X | `assets/social/x.png` | official archive `logo-white.png` |
| LinkedIn | `assets/social/linkedin.png` | official archive `InBug-White.png` |
| Twitch | `assets/social/twitch.png` | official archive flat white Glitch |
| Spotify | `assets/social/spotify.png` | official standalone black icon PNG, resized without recoloring |
| Bitbucket | `assets/social/bitbucket.png` | official app-icon PNG |

원본 URL, 아카이브 멤버, SHA-256은
[패키지 자산 매니페스트](../assets/README.md)에 있습니다. 런타임 파일은
직접 받은 PNG 또는 ZIP에서 추출한 PNG인 경우에만 보존 원본과 바이트가
같습니다. Spotify 원본 PNG는 바이트 그대로 보존하고, 런타임 PNG는 원색과
구성을 유지해 128×128로 줄였으므로 원본과 바이트가 같지 않습니다.

Google 런타임 PNG는 공식 커스텀 버튼 가이드가 직접 링크하는
`g-logo.png`와 바이트가 같습니다. 이전 no-text square PNG는 독립 로고가
아니라 테두리와 흰 배경을 포함한 완성형 icon-mode 버튼이어서 런타임
매핑에서 제외했으며, 원본과 ZIP 해시는 조사 기록에 보존했습니다.

## 기본 48px 버튼의 로고 발자국

대부분의 투명 심볼은 24 logical pixels로 표시합니다. 원본 파일을 자르거나
다시 패딩하지 않고 다음 provider-supplied 캔버스와 최소·보호 여백을
예외로 유지합니다.

| 제공자 | 렌더링 캔버스 | 이유 |
| --- | ---: | --- |
| Google | 20 | Android/Web 커스텀 버튼 도표의 고정 G 크기 |
| Microsoft | 21 | 제공된 21×21 심볼 원본 |
| LINE | 30 | 공식 44dp 캔버스의 내부 말풍선 여백 보존 |
| Spotify | 24 | 21px 디지털 최소치 이상, 12px 외부 여백 유지 |
| Kakao | 48 | 192px 원본의 내부 패딩을 유지해 심볼을 약 22px로 표시 |
| Naver | 45 | 224px 원본 내부 N을 공식 최소 16px 이상으로 표시 |
| Apple | 44 | 생성 endpoint의 44pt 캔버스 보존 |

Apple light는 검정 원본을 색칠하거나 반전한 파일이 아닙니다. 공식 생성
endpoint의 `color=white` 응답을 바이트 그대로 보존하며, 흰 컨트롤과 검은
Apple 글리프를 포함합니다. Apple 지침에 따라 주변 배경과 충분한 대비를
확보해야 합니다.

Slack 20px와 VK 28px는 각 provider 버튼 규격을 유지합니다. 다른 기본
로고는 24px이며 버튼 `size`를 키워도 자동으로 확대하지 않아 35개 목록의
가시 무게가 갑자기 달라지지 않습니다.

의존성을 추가하거나 패키지 자산이 바뀐 뒤 다음 명령으로 에셋 목록을
갱신하세요.

```sh
fvm flutter pub get
```

## 경로 직접 지정

앱이 별도로 허용받은 자산을 쓰거나 기본 자산을 바꾸려면 `logo`에 소비 앱의
경로를 전달합니다.

```dart
SocialButton(
  social: Social.notion,
  logo: 'assets/brands/notion/mark.png',
  onPressed: startNotionSignIn,
)
```

`logo`는 파일 시스템 경로나 URL이 아니라 Flutter 앱 에셋 경로입니다.
명시적 경로에는 package key를 붙이지 않습니다.

GitHub는 공식 흰색·검정색 원본을 외형에 따라 직접 선택하며 반전하거나
재색칠하지 않습니다. 공식 출처라는 사실은 패키지 재배포 권한이나 맞춤 인증
버튼 승인을 뜻하지 않습니다. 남아 있는 `assets/social/github.png`와
Simple Icons GitHub SVG는 현재 런타임 매핑이 아닌 이전 파일입니다.

## 나머지 23개 기본값

Notion을 포함한 나머지 23개도
`assets/social/<id>.png`를 기본값으로 갖습니다. 이 파일들은 pinned Simple
Icons SVG를 패키지 foreground 색상으로 래스터화한 식별용 기본값이며
provider-supplied 자산이나 공식 로그인 컨트롤이 아닙니다. Simple Icons
저장소 라이선스, 개별 아이콘 저작권, 상표 식별 사용, 변형, 패키지 재배포는
각각 별도 조건입니다.

완성형 버튼, SDK, 생성기, QR 제어만 제공되는 서비스는 작은 로고 슬롯 때문에
그 표면을 잘라내지 않았습니다. 29개 전수 판단은
[공식 원본 교체 매트릭스](../research/logo-catalog-plan.md#기존-thirdparty-29개-전수-교체-매트릭스)에
기록했습니다.

## 자산 선택

1. [제공자 자산 가이드](PROVIDER_GUIDE.md)에서 공식 출처와 제한을 확인합니다.
2. 현재 플랫폼과 제품에 허용된 로고 또는 공식 제어를 고릅니다.
3. 원본 비율, 보호 여백, 대비 규칙을 확인합니다.
4. 실제 버튼 크기에서 흐림, 잘림, 낮은 대비가 없는지 봅니다.
5. 출시 직전에 제공자 문서와 사용 조건을 다시 확인합니다.

공식 완성형 버튼, 워드마크, QR 로그인 화면은 작은 로고 슬롯에 넣을 자산이
아닙니다. 제공자가 완성형 제어를 요구하면 `SocialButton` 대신 공식 SDK,
생성기 또는 제공 자산을 사용하세요.

## Notion

Notion의 공식 [Authorization 문서][notion-auth]에서 public connection이
OAuth 2.0을 사용한다는 사실과 공식 권한 승인 화면을 확인할 수 있습니다.
하지만 재사용 가능한 공식 로그인 로고 파일이나 커스텀 버튼 시각 규격은 해당
문서에서 확인되지 않았습니다.

따라서 Notion 로고를 임의로 추출하거나 재생성하지 마세요. 출시 대상에 쓸 수
있는 자산과 권한을 Notion의 현재 공식 채널에서 별도로 확인해야 합니다.

[notion-auth]: https://developers.notion.com/guides/get-started/authorization

## 자주 생기는 에셋 오류

### `Unable to load asset`

- 패키지 기본값이라면 `fvm flutter pub get` 후 앱을 다시 시작하고 패키지 빌드
  자산에 해당 경로가 있는지 확인합니다.
- 명시적 `logo`라면 소비 앱 파일명과 대소문자, `pubspec.yaml` 등록을
  확인합니다.

### 로고가 흐리거나 잘림

- 작은 래스터 이미지를 확대하지 말고 제공자가 허용한 충분한 해상도를
  사용합니다.
- 로고 파일 자체에 과도한 투명 여백이 없는지 확인합니다.
- 완성형 버튼이나 긴 워드마크를 로고 슬롯에 넣지 않습니다.

### 색상이 공식 버튼과 다름

패키지 프리셋은 여러 제공자에 공통 구조를 적용한 비공식 스타일입니다.
제공자 공식 규격이 필요하면 해당 제공자의 완성형 버튼을 사용하세요.

## 책임 범위

파일을 내려받을 수 있다는 사실만으로 상표 사용 권한이 생기지는 않습니다.
자산 라이선스, 파트너 약관, 앱 심사, 지역별 표시 규칙은 소비 앱 담당자가
확인해야 합니다.

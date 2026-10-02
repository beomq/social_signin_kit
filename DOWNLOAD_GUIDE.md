# 공식 소셜 로그인 로고 획득 가이드

이 문서는 `landing/logo-catalog.json`에 등록된 35개 제공자의 공식 로고를 어디서, 어떤 상태로, 어떤 파일까지 얻을 수 있는지 정리한다. 획득 계획과 실제 appearance 연결 상태를 함께 기록하며, 공식 컨트롤과 공통 패키지 표면을 구분한다.

최초 조사 기준일은 2026-09-30이며 appearance 원본 검증·통합 기준일은 2026-10-01이다. URL과 파일 내용은 바뀔 수 있으므로 실제 취득 시점에 응답 형식, 파일 서명, 해시, 약관을 다시 확인해야 한다. 이 문서에 적힌 해시는 조사 당시 받은 바이트의 관찰값이지 영구 보증값이 아니다.

## 먼저 구분할 것

로고 작업에는 서로 다른 세 가지 판단이 있다.

1. **다운로드 가능 여부**: 공식 페이지나 공식 CDN에서 파일을 받을 수 있는가.
2. **사용 가능 여부**: 로그인 식별, 미디어 보도, 파트너 마케팅처럼 해당 제공자가 허용한 맥락에 맞는가.
3. **재배포 가능 여부**: 받은 파일을 라이브러리나 패키지에 넣어 제3자에게 다시 배포해도 되는가.

다운로드 성공은 사용 허가나 재배포 허가가 아니다. `official`이라는 표현도 출처가 제공자라는 뜻일 뿐, 이 패키지나 특정 버튼 디자인을 제공자가 승인했다는 뜻이 아니다.

Simple Icons는 기존 카탈로그 상태를 설명할 때만 참고할 수 있다. 공식 자산 획득이 막혔다는 이유로 모든 제공자에 Simple Icons를 일괄 대체 경로로 쓰지 않는다.

## 에이전트 공통 절차

1. 아래의 **공식 출처**를 먼저 연다. 직접 URL만 단독으로 신뢰하지 않는다.
2. `직접` 경로는 리디렉션을 허용한 GET으로 내려받고 HTTP 성공 여부, `Content-Type`, 파일 시그니처를 확인한다. ZIP은 `50 4b`, PNG는 `89 50 4e 47`, PSD는 `38 42 50 53`으로 시작하는지 본다.
3. 응답이 HTML, 로그인 페이지, 만료 안내, 예시 타일이면 이미지 파일로 저장하지 않는다.
4. ZIP은 원본 ZIP을 먼저 보관하고, 아래에 적힌 **정확한 멤버 경로**를 추출한다. 아카이브 해시와 멤버 해시는 서로 다른 값으로 측정한다.
5. SVG나 PNG를 변환할 때는 비율, 색, 여백, 투명도를 유지한다. 제공자 지침이 허용하지 않은 재채색, 도형 재작성, 일부 크롭은 하지 않는다.
6. 브라우저, 인증, 파트너 경로는 임시 다운로드 URL을 추측하거나 저장하지 않는다. 사용자가 직접 로그인하거나 약관을 확인해야 하면 그 단계에서 멈추고 필요한 행동을 정확히 알린다.
7. 취득 후 원본과 변환본을 구분한다. 원본 파일, 출처 URL, 확인일, 측정 해시, 선택한 멤버, 적용한 변환을 함께 기록한다.
8. 배포 전에는 제공자 약관에서 로그인 사용과 패키지 재배포가 각각 허용되는지 다시 판정한다. 명시가 없으면 `미확인`으로 남긴다.

[download-plan.json](download-plan.json)은 이 문서의 기계 판독용 동반 산출물이다. 35개 ID가 모두 있으며, 조사 결과 취득 자동화가 가능한 항목은 23개다. 다만 `automaticAppInstallAllowed`는 35개 모두 `false`다. 공식 파일을 자동으로 받을 수 있다는 사실만으로 앱 설치, 패키지 포함, 재배포 권한을 추론하지 않았기 때문이다. 자동화는 이 계획의 상태, URL, 멤버, 해시, 차단 사유가 이 문서와 일치하는지 확인한 뒤 실행해야 한다. 이 가이드는 `download-plan.json`을 수정하지 않는다.

## 상태 용어

| 상태 | 의미 |
| --- | --- |
| 직접 | 조사 당시 공식 경로에서 바이너리 GET과 파일 형식을 확인했다. |
| 서명 갱신 | 공식 랜딩에서 매번 새로운 만료성 다운로드 링크를 얻어야 한다. |
| 브라우저 | 공개 페이지에서 사람이 다운로드 동작을 해야 하며 안정적인 직접 URL은 확인하지 못했다. |
| 인증 | 앱, 계정, 파트너 권한 또는 약관 동의가 있어야 다음 단계로 갈 수 있다. |
| 권한 확인 | 파일은 받을 수 있지만 현재 용도나 재배포 허가는 별도로 확인해야 한다. |
| 미검증 | 확인한 공개 표면에서 적합한 파일을 입증하지 못했다. 자산이 없다는 뜻은 아니다. |

## 제공자별 획득 경로

### 1. Facebook (`facebook`)

- **상태와 공식 출처**: 서명 갱신. [Facebook 로고 리소스](https://www.meta.com/brand/resources/facebook/logo/)와 [Facebook Login 버튼 문서](https://developers.facebook.com/docs/facebook-login/web/login-button/)를 함께 확인한다.
- **실제 획득**: 로고 리소스 페이지에서 현재 `Facebook-Brand-Asset-Pack.zip` 다운로드 동작을 실행해 새 서명 URL을 얻는다. 조사 때 서명된 요청은 ZIP으로 성공했지만 서명 없는 CDN 경로는 `403 Bad URL hash`였다. 서명 URL을 문서나 자동화에 고정하지 않는다.
- **선택**: `Facebook Brand Asset Pack/Logo/Primary Logo/Facebook_Logo_Primary.png`를 쓴다. 조사 당시 ZIP과 멤버 모두 PNG로 확인됐다.
- **외형과 변환**: 현재의 완성된 파란 원형 `f` 마크를 유지한다. 재채색, 형태 재작성, 마크 일부 크롭은 하지 않는다. 크기 조절이 필요하면 비율과 투명 배경을 보존한다.
- **사용과 재배포**: 일반 브랜드 팩 다운로드와 Facebook Login용 컨트롤 사용은 같은 허가가 아니다. 로그인 식별은 해당 로그인 문서를 따르고, 재사용 패키지에 로고를 포함할 권리는 별도로 확인한다.
- **에이전트 절차**: 공식 랜딩을 브라우저로 열고 다운로드 링크를 새로 얻은 뒤 ZIP 시그니처를 검사한다. 정확한 멤버를 추출하고 원본을 보존한다. 만료 URL을 `download-plan.json`의 영구 URL로 저장하지 않는다.

### 2. GitHub (`github`)

- **상태와 공식 출처**: 직접, 권한 확인. [GitHub Logos](https://github.com/logos)와 [OAuth 앱 인증 문서](https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/authorizing-oauth-apps)를 확인한다.
- **실제 획득**: [GitHub_Logos.zip](https://brand.github.com/GitHub_Logos.zip)을 내려받는다. 조사 당시 공식 ZIP 응답과 아카이브를 확인했다.
- **선택**: 어두운 버튼에는 `GitHub Logos/PNG/GitHub_Invertocat_White.png`, 밝은 버튼에는 `GitHub Logos/PNG/GitHub_Invertocat_Black.png`를 쓴다. 두 원본을 검증하고 외형별 Flutter·랜딩·manifest에 연결했다. 사용자 제공 검정 파일도 공식 멤버와 바이트가 동일하다.
- **외형과 변환**: Invertocat의 원래 검정 또는 흰색 외형을 바꾸지 않는다. 비율을 유지한 리사이즈 외에 재채색이나 재구성은 하지 않는다.
- **사용과 재배포**: GitHub는 통합 식별 예시를 제공하지만 로고 사용에 사전 서면 허가가 필요한 경우도 명시한다. OAuth 식별과 범용 패키지 재배포를 같은 권한으로 보지 않는다.
- **에이전트 절차**: ZIP을 직접 받고 시그니처를 확인한 뒤 정확한 멤버를 추출한다. 선택한 배경과 흰색 마크의 대비를 확인하고, 배포 권한 판정은 별도 기록으로 남긴다.

### 3. Microsoft (`microsoft`)

- **상태와 공식 출처**: 직접. [Microsoft 앱 브랜딩 지침](https://learn.microsoft.com/en-us/entra/identity-platform/howto-add-branding-in-apps)을 기준으로 한다.
- **실제 획득**: 문서가 연결하는 [Microsoft 심볼 PNG](https://learn.microsoft.com/en-us/entra/identity-platform/media/howto-add-branding-in-apps/ms-symbollockup_mssymbol_19.png)를 내려받는다. 조사 당시 PNG 응답을 확인했다.
- **선택**: 문서의 21px 심볼을 사용한다. 전체 밝은색 또는 어두운색 로그인 컨트롤이 필요한 경우 같은 공식 문서의 완성 컨트롤을 선택한다.
- **외형과 변환**: 네 색 심볼을 그대로 유지한다. 색, 사각형 배열, 비율을 바꾸지 않는다. 확대가 필요하면 흐림을 확인하고 공식 고해상도 대안이 있는지 먼저 본다.
- **사용과 재배포**: 제공된 심볼은 앱 로그인 식별용이다. 이 파일을 범용 로고 묶음으로 다시 배포하는 권리까지 자동으로 생기지 않는다.
- **에이전트 절차**: 직접 PNG를 저장하고 파일 시그니처를 검사한다. 별도 크롭 없이 공식 심볼을 쓰고, 최종 버튼은 Microsoft 지침의 간격과 대비를 따른다.

### 4. X (`x`)

- **상태와 공식 출처**: 직접. [X Brand Toolkit](https://about.x.com/en/who-we-are/brand-toolkit)과 [X 인증 개요](https://docs.x.com/fundamentals/authentication/overview.md)를 확인한다.
- **실제 획득**: [x-logo.zip](https://about.x.com/content/dam/about-twitter/x/brand-toolkit/x-logo.zip)을 내려받는다.
- **선택**: 어두운 배경에는 `logo-white.png`를 쓴다. 조사에서 이 멤버와 ZIP을 각각 확인했다.
- **외형과 변환**: 흰색 X 마크의 비율과 여백을 유지한다. 재채색, 왜곡, 외곽선 추가는 하지 않는다.
- **사용과 재배포**: 툴킷 다운로드는 X 브랜드 지침 적용을 전제로 한다. 인증 버튼 사용과 패키지 재배포는 별도로 명시되지 않았다.
- **에이전트 절차**: ZIP 시그니처를 확인하고 `logo-white.png`를 정확히 추출한다. 원본 PNG를 보존한 뒤 비율 유지 리사이즈만 한다.

### 5. LINE (`line`)

- **상태와 공식 출처**: 직접. [LINE Login 버튼 가이드](https://developers.line.biz/en/docs/line-login/login-button/)와 [사용 지침](https://terms2.line.me/LINE_Developers_Guidelines_for_Login_Button)을 따른다.
- **실제 획득**: [LINE_Login_Button_Image.zip](https://vos.line-scdn.net/line-developers/docs/media/line-login/login-button/LINE_Login_Button_Image.zip)을 내려받는다.
- **선택**: 데스크톱 44dp 2배 자산은 `Line_Login_Button_Image/images/DeskTop/2x/44dp/line_88.png`다. 다른 해상도나 상태가 필요하면 아카이브의 동일 계열 멤버를 지침과 맞춰 고른다.
- **외형과 변환**: 선택한 공식 멤버를 그대로 쓴다. 내부 여백, 색, 상태 표현을 바꾸지 않는다.
- **사용과 재배포**: 이 자산은 LINE Login 목적에 한정된 제공물이다. 범용 로고 패키지 재배포 권한은 별도로 적혀 있지 않다.
- **에이전트 절차**: ZIP을 저장하고 정확한 멤버를 추출한다. 원본을 보존하며 버튼 크기와 화면 배율에 맞는 공식 변형을 선택한다.

### 6. Discord (`discord`)

- **상태와 공식 출처**: 직접. [Discord Branding](https://discord.com/branding)과 [OAuth2 문서](https://discord.com/developers/docs/topics/oauth2)를 확인한다.
- **실제 획득**: [검증된 독립 흰색 심볼 ZIP](https://cdn.discordapp.com/assets/content/80af2c38f13b4a7d2cb3572e1220f6e958d3c3aedccc7c7d3ddc9832f6b3d725.zip)을 내려받는다. 조사 당시 HTTP 200, ZIP 15,876바이트, 아카이브 SHA-256 `80af2c38f13b4a7d2cb3572e1220f6e958d3c3aedccc7c7d3ddc9832f6b3d725`를 확인했다.
- **선택**: `Discord_Symbol_White/Discord-Symbol-White.png`를 쓴다. 멤버 SHA-256 관찰값은 `64dce9107da58318880721df9d0603c3cee3683a3322bf36f3dedb75edd1c81d`다.
- **외형과 변환**: 흰색 독립 심볼을 Discord 맥락이 드러나는 라벨과 함께 쓴다. 비율 유지 리사이즈 외에는 바꾸지 않는다.
- **사용과 재배포**: 공개 디지털 사용 안내가 OAuth 버튼이나 패키지 재배포를 포괄한다고 단정하지 않는다.
- **에이전트 절차**: 반드시 위 ZIP을 쓴다. Branding 페이지의 `Symbol.svg`는 그리드, X 표시, `1/3` 치수가 들어간 제작 예시라 로그인 슬롯용 심볼이 아니다. 해당 임베디드 specimen은 거부하고 ZIP의 독립 PNG만 추출한다.

### 7. LinkedIn (`linkedin`)

- **상태와 공식 출처**: 직접. [LinkedIn 브랜드 다운로드](https://brand.linkedin.com/downloads)와 [Sign In with LinkedIn 문서](https://learn.microsoft.com/en-us/linkedin/consumer/integrations/self-serve/sign-in-with-linkedin-v2)를 확인한다.
- **실제 획득**: [in-logo.zip](https://content.linkedin.com/content/dam/me/business/en-us/amp/xbu/linkedin-revised-brand-guidelines/logos/in-logo.zip)을 내려받는다.
- **선택**: 파란 배경 또는 어두운 배경에는 `in-logo/InBug-White.png`를 쓴다. 다른 배경에는 공식 팩 안의 대응 색상 자산을 선택한다.
- **외형과 변환**: `in` Bug의 색상, 모서리, 비율을 변경하지 않는다.
- **사용과 재배포**: 다운로드 시 LinkedIn Brand와 User Agreement가 적용된다. 다운로드 가능하다는 사실만으로 패키지 재배포를 허용받은 것은 아니다.
- **에이전트 절차**: ZIP과 멤버를 확인하고 배경별 공식 변형을 고른다. 재채색으로 변형을 만들지 않는다.

### 8. Slack (`slack`)

- **상태와 공식 출처**: 인증. [Sign in with Slack 문서](https://docs.slack.dev/authentication/sign-in-with-slack/)와 [Slack 브랜드 지침](https://slack.com/brand-guidelines)을 기준으로 한다.
- **실제 획득**: [버튼 생성기](https://api.slack.com/sign-in-with-slack-button-generator)는 조사 브라우저에서 `Looks like you don't have any apps yet.`와 `Create an App`만 보였다. 앱을 만들고 선택한 뒤 생성해야 한다. [공식 연결 DAM](https://salesforce.widencollective.com/c/yn6bxnam)은 `Slack Media Kit Logos`와 로그인 화면까지만 공개됐다.
- **선택**: 앱 생성기의 결과 또는 DAM 인증 후 제공되는 공식 멤버를 그 자리에서 확인한다. 공개 상태에서는 파일명, 형식, 멤버를 확정하지 않는다.
- **외형과 변환**: Slack 문서는 지침을 지킨 맞춤 버튼을 허용하지만, 공식 로고 원본을 임의로 재채색하거나 재구성해도 된다는 뜻은 아니다.
- **사용과 재배포**: 로그인 컨트롤 생성 허용과 원본 로고 파일의 패키지 재배포는 다른 문제다. DAM 로그인 뒤 표시되는 조건을 확인한다.
- **에이전트 절차**: 사용자의 Slack 앱과 인증 상태가 없으면 자동 다운로드를 멈춘다. 앱 생성 또는 DAM 로그인 단계를 안내하고, 임시 URL이나 제3자 로고를 추측해 대신 저장하지 않는다.

### 9. Twitch (`twitch`)

- **상태와 공식 출처**: 직접. [Twitch 브랜드](https://brand.twitch.com/)와 [상표 정책](https://www.twitch.tv/p/en/legal/trademark/)을 확인한다.
- **실제 획득**: [Twitch-Brand.zip](https://brand.twitch.com/uploads/Twitch-Brand.zip)을 내려받는다.
- **선택**: 보라색 또는 어두운 배경에는 `Twitch Brand/Twitch Logos/02. Glitch/04. White/glitch_flat_white.png`를 쓴다.
- **외형과 변환**: 흰색 Glitch의 모양을 바꾸지 않는다. 회전, 외곽선, 재채색을 하지 않는다.
- **사용과 재배포**: 브랜드 아카이브 공개와 제3자 마케팅 승인, 인증 패키지 재배포는 별도 판단이다.
- **에이전트 절차**: ZIP에서 정확한 흰색 Glitch 멤버를 추출하고 원본을 보존한다. 적용 전 상표 정책에서 현재 용도를 확인한다.

### 10. Spotify (`spotify`)

- **상태와 공식 출처**: 직접. [Spotify 디자인 지침](https://developer.spotify.com/documentation/design), [인증 개요](https://developer.spotify.com/documentation/web-api/concepts/authorization), [미디어 키트](https://newsroom.spotify.com/media-kit/logo-and-brand-assets/)를 함께 본다.
- **실제 획득**: 검정 독립 로고는 [Spotify_Primary_Logo_RGB_Black.png](https://storage.googleapis.com/pr-newsroom-wp/1/2023/05/Spotify_Primary_Logo_RGB_Black.png)에서 받을 수 있다. 전체 원본은 [2024-Spotify-Brand-Assets.zip](https://storage.googleapis.com/pr-newsroom-wp/1/2023/05/2024-Spotify-Brand-Assets.zip)이다.
- **선택**: 녹색 또는 밝은 표면에는 검정 로고를 쓴다. 아이콘은 최소 21px, 전체 로고는 최소 70px 기준을 지킨다. 공간이 충분하면 전체 로고를 우선한다.
- **외형과 변환**: 원색과 투명도를 보존한다. 런타임 크기가 필요하면 투명 정사각 캔버스 안에서 비율 유지 리사이즈만 하고 로고 부분을 잘라내지 않는다.
- **사용과 재배포**: 개발자 통합 자산은 Spotify Developer Terms를 따른다. 범용 패키지 재배포 권한은 별도로 확인한다.
- **에이전트 절차**: 단일 PNG 또는 ZIP을 내려받고 파일 시그니처를 확인한다. 배경에 맞는 공식 색상을 선택하며 임의 반전은 하지 않는다.

### 11. Steam (`steam`)

- **상태와 공식 출처**: 직접, 완전한 컨트롤 전용. [Steam OpenID 웹사이트 문서](https://partner.steamgames.com/doc/features/auth#website)를 기준으로 한다.
- **실제 획득**: [큰 테두리 버튼](https://shared.fastly.steamstatic.com/community_assets/images/steamworks_docs/english/sits_large_border.png), [큰 무테 버튼](https://shared.fastly.steamstatic.com/community_assets/images/steamworks_docs/english/sits_large_noborder.png), [작은 버튼](https://shared.fastly.steamstatic.com/community_assets/images/steamworks_docs/english/sits_small.png) 중 하나를 쓴다. 큰 테두리 버튼은 조사 당시 공식 PNG로 확인됐다.
- **선택**: 화면의 크기와 테두리 필요 여부에 맞춰 완성된 컨트롤 전체를 고른다.
- **외형과 변환**: 버튼 전체를 비율 유지로 표시한다. 로고 부분만 잘라 아이콘으로 만들면 안 된다.
- **사용과 재배포**: 제공자는 Steam 로그인으로 연결하는 제3자 사이트에 완성 컨트롤 사용을 안내한다. 로고 조각의 별도 재배포나 크롭은 확인되지 않았다.
- **에이전트 절차**: 아이콘 전용 요청이면 `공식 독립 아이콘 미확인`으로 막는다. 완성 버튼을 받을 때만 직접 PNG를 저장하고 전체 이미지를 사용한다.

### 12. Reddit (`reddit`)

- **상태와 공식 출처**: 직접, 권한 확인. [Reddit 브랜드](https://redditinc.com/brand)와 [상표 사용 정책](https://www.redditinc.com/policies/trademark-use-policy)을 확인한다.
- **실제 획득**: [Reddit_Logo.png](https://redditinc.com/hubfs/Reddit%20Inc/Content/Brand%20Page/Reddit_Logo.png)을 내려받는다. 조사에서 헤더 예시가 아니라 `The Reddit logo` 섹션의 실제 Snoo 마크임을 확인했다.
- **선택**: 공식 OrangeRed와 원래 둘러싸인 Snoo 구성을 유지한다.
- **외형과 변환**: 마크를 재채색하거나 예시 이미지에서 다시 크롭하지 않는다. 필요하면 원본 PNG를 비율 유지로 축소한다.
- **사용과 재배포**: 현행 브랜드 지침 또는 별도 허가가 필요하다. OAuth 식별용 패키지 재배포는 명시되지 않았다.
- **에이전트 절차**: 직접 PNG를 저장하고 시그니처를 확인한다. 페이지의 장식용 그림과 다운로드 자산을 혼동하지 않는다.

### 13. Dropbox (`dropbox`)

- **상태와 공식 출처**: 브라우저. [Dropbox 로고 지침](https://brand.dropbox.com/logo)과 [OAuth 가이드](https://developers.dropbox.com/oauth-guide)를 확인한다.
- **실제 획득**: 공식 페이지가 연결하는 [Brand Partner Toolkit](https://www.dropbox.com/scl/fo/6qjduc7j5ujf09f75w1p7/AFc217w49gnfwVNr64Bd1_A?rlkey=tkqw8jcoi7f24voc6577vakky&dl=0)을 브라우저로 열고 `Logos` 다음 `Dropbox`, `Glyph`로 이동해 `Glyph_128.png` 또는 SVG를 내려받는다. `dl=1`은 조사 당시 바이너리가 아니라 HTML을 반환했다.
- **선택**: 작은 로그인 슬롯에는 `Glyph_128.png`를 우선한다. 벡터가 필요하면 같은 폴더의 SVG를 직접 선택한다.
- **외형과 변환**: 공식 글리프를 변경하지 않는다. SVG를 PNG로 바꿀 때는 비율, 색, 투명 배경을 유지한다.
- **사용과 재배포**: 브랜드 지침은 로고 구성을 설명하지만 재사용 패키지 재배포 권한을 명시하지 않는다.
- **에이전트 절차**: 브라우저 다운로드를 사용한다. 공유 URL에 `dl=1`을 붙여 직접 파일이라고 가정하지 말고, 받은 응답이 실제 PNG 또는 SVG인지 검사한다.

### 14. GitLab (`gitlab`)

- **상태와 공식 출처**: 직접, 권한 확인. [GitLab Press Kit](https://about.gitlab.com/press/press-kit/)과 [상표 지침](https://handbook.gitlab.com/handbook/marketing/brand-and-product-marketing/brand/brand-activation/trademark-guidelines/)을 확인한다.
- **실제 획득**: [gitlab-logo-500-rgb.png](https://about.gitlab.com/images/press/gitlab-logo-500-rgb.png)을 내려받는다. 조사 당시 380 x 380 PNG를 확인했다.
- **선택**: RGB 원본 로고를 쓴다. 단색 변형이 필요하면 Press Kit 안의 공식 변형만 선택한다.
- **외형과 변환**: 원래 색과 비율을 유지한다. 현재 파일을 임의 단색으로 바꾸지 않는다.
- **사용과 재배포**: GitLab 상표 지침은 명시된 예외 밖의 로고 사용을 제한한다. 다운로드 성공만으로 로그인 버튼이나 패키지 재배포가 허용되지 않는다.
- **에이전트 절차**: 직접 PNG를 저장한 뒤 현재 용도가 지침의 허용 범위인지 확인한다. 불명확하면 권한 확인 상태로 남긴다.

### 15. Bitbucket (`bitbucket`)

- **상태와 공식 출처**: 직접. [Atlassian Logos](https://atlassian.design/foundations/logos/)와 [Bitbucket OAuth 2.0](https://developer.atlassian.com/cloud/bitbucket/oauth-2/)을 확인한다.
- **실제 획득**: [bitbucket_app.zip](https://atlassian.design/assets/599d0f58b052/logos/bitbucket_app.zip)을 내려받는다.
- **선택**: `Bitbucket/PNG@2x/Bitbucket_icon.png`를 쓴다.
- **외형과 변환**: 공식 앱 아이콘을 그대로 사용한다. 비율 유지 리사이즈 외에는 바꾸지 않는다.
- **사용과 재배포**: Atlassian이 문서화한 앱 로고 맥락과 범용 로그인 패키지 재배포는 같지 않다.
- **에이전트 절차**: ZIP과 정확한 멤버를 확인해 추출한다. 임의 컨테이너나 배경을 로고 일부라고 추론해 추가하지 않는다.

### 16. PayPal (`paypal`)

- **상태와 공식 출처**: 직접, 변형 제한, 권한 확인. [PayPal 미디어 리소스](https://newsroom.paypal-corp.com/media-resources)와 [Log in with PayPal](https://developer.paypal.com/docs/log-in-with-paypal/)을 함께 확인한다.
- **실제 획득**: [PayPal-Monogram-Logo-2024.zip](https://newsroom.paypal-corp.com/download/PayPal-Monogram-Logo-2024.zip)을 내려받는다.
- **선택**: `Monogram/PayPal-Monogram-FullColor-RGB.png`는 투명한 fullcolor 모노그램이며 흰 배경에서만 쓴다. 조사된 검정과 흰색 대안은 3840 x 2160 불투명 캔버스였고 독립 whiteglyph가 아니었다.
- **외형과 변환**: fullcolor 모노그램을 파란 버튼 위에 올리거나 흰색으로 반전하지 않는다. 타일에서 글리프만 크롭하지 않는다. 현재 선택지가 파란 버튼이라면 필요한 whiteglyph는 **unavailable** 상태다.
- **사용과 재배포**: 뉴스룸 미디어 로고를 받을 수 있다는 사실은 OAuth 로그인 UI나 패키지 재배포 허가가 아니다.
- **에이전트 절차**: 흰색 버튼으로 설계를 바꿀 수 있을 때만 fullcolor 투명 PNG를 후보로 쓴다. 파란 버튼을 유지해야 하면 자동화를 멈추고 PayPal이 제공하는 현재 로그인 자산 또는 서면 허가를 다시 확인한다.

### 17. Telegram (`telegram`)

- **상태와 공식 출처**: 직접, 권한 확인. 로그인 동작은 [Telegram Login Widget](https://core.telegram.org/widgets/login), 로고 ZIP은 [Telegram Screenshots](https://telegram.org/tour/screenshots)의 `Download Telegram Logos`에서 확인한다.
- **실제 획득**: 조사에서 확인한 [공식 Telegram 로고 ZIP](https://telegram.org/file/464001088/1/bI7AJLo7oX4.287931.zip/374fe3b0a59dc60005)을 내려받는다. 당시 ZIP SHA-256은 `8b1924b30790b3557cd1a76c4028403035dae386f282aaa3d741c5bc5a03d8a7`였다.
- **선택**: `Logo.png`를 쓴다. 조사 당시 멤버 PNG SHA-256은 `f91e9d7c30894cb0f00196581d4cc8867dd1139b2b1455de2c58071103475ca8`이었다.
- **외형과 변환**: 공식 로고 색과 비율을 유지한다. 필요하면 투명 배경을 보존한 비율 유지 리사이즈만 한다.
- **사용과 재배포**: 이 ZIP은 공식 일반 미디어 로고다. Telegram Login용 정적 자산 허가나 패키지 재배포 허가를 입증하지 않는다. 로그인 위젯 JS도 PNG 다운로드가 아니다.
- **에이전트 절차**: ZIP과 멤버를 검증해 원본을 저장한다. 로그인 용도와 재배포는 별도 권한 항목으로 남기고, 위젯 스크립트를 로고 파일로 오인하지 않는다.

### 18. Instagram (`instagram`)

- **상태와 공식 출처**: 서명 갱신, 약관 동의. [Instagram 브랜드 리소스](https://www.meta.com/brand/resources/instagram/instagram-brand/)와 [Instagram Login API](https://developers.facebook.com/docs/instagram-platform/instagram-api-with-instagram-login/)를 확인한다.
- **실제 획득**: 브랜드 페이지에서 현재 약관 확인과 다운로드 동작을 거쳐 새 서명 ZIP URL을 얻는다. 조사 당시 해당 방식의 ZIP은 성공했지만 URL은 만료될 수 있으므로 고정하지 않는다.
- **선택**: 어두운색 또는 강한 색 배경에는 `01 Static Glyph/02 White Glyph/Instagram_Glyph_White.png`를 쓴다.
- **외형과 변환**: 흰색 Glyph의 형태, 여백, 비율을 유지한다. 재채색이나 크롭을 하지 않는다.
- **사용과 재배포**: 약관 동의 후 다운로드했다는 사실과 Instagram Login UI 또는 패키지 재배포 허가는 별도다.
- **에이전트 절차**: 사용자가 약관을 확인할 수 있는 브라우저에서 새 링크를 얻는다. ZIP 시그니처와 정확한 멤버를 검사하며 서명 URL을 영구 경로로 저장하지 않는다.

### 19. WeChat (`wechat`)

- **상태와 공식 출처**: 정적 로고 미검증. [WeChat Login 문서](https://developers.weixin.qq.com/doc/oplatform/en/Website_App/WeChat_Login/Wechat_Login.html)와 [WeChat 브랜드 페이지](https://wechat.design/brand/main-brand)를 확인한다.
- **실제 획득**: 로그인 문서는 [wxLogin.js](https://res.wx.qq.com/connect/zh_CN/htmledition/js/wxLogin.js)를 통해 QR 로그인 UI를 렌더링한다. 이것은 정적 로고 파일이 아니다. 조사한 브랜드 페이지에는 다운로드 컨트롤이 보이지 않았다.
- **선택**: 현재 입증된 공식 경로는 QR 로그인 컨트롤이다. 독립 PNG, SVG, 정확한 파일 멤버는 확정하지 않는다.
- **외형과 변환**: QR 위젯을 쓸 때는 제공된 렌더링과 허용된 CSS 범위만 따른다. 페이지 내 로고나 예시 이미지를 크롭하지 않는다.
- **사용과 재배포**: 임베드된 QR 컨트롤 사용과 독립 로고 재배포는 다른 권한이다.
- **에이전트 절차**: 정적 아이콘 요청이면 `공식 정적 다운로드 미확인`으로 멈춘다. Simple Icons나 페이지 스크린샷으로 자동 대체하지 않는다.

### 20. Pinterest (`pinterest`)

- **상태와 공식 출처**: 인증. [Pinterest 브랜드 지침](https://business.pinterest.com/en/brand-guidelines/)과 [인증 문서](https://developers.pinterest.com/docs/getting-started/authentication/)를 확인한다.
- **실제 획득**: 브랜드 페이지가 연결한 [외부 자산 관리 포털](https://www.pinterest-assets.com/asset-management/2THWMKDBK3GQ?WS=AssetManagement&Flat=y&FR_=1&W=1504&H=694)을 연다. 조사 당시 HTTP 응답은 HTML이었고 브라우저에는 로그인과 등록 장벽이 보였다.
- **선택**: 권한을 얻은 뒤 포털이 제공하는 PNG 또는 EPS 중 실제 로그인 맥락에 맞는 공식 P 마크를 선택한다. 공개 상태에서는 파일명을 추정하지 않는다.
- **외형과 변환**: 포털 원본을 유지한다. 브랜드 페이지의 예시 화면에서 로고를 잘라내지 않는다.
- **사용과 재배포**: 자산 포털 접근과 OAuth용 재배포 허가는 별도다. 앱 자체 브랜딩과 Pinterest 식별을 혼동하지 않는다.
- **에이전트 절차**: 로그인 또는 등록이 필요하다고 사용자에게 알리고 멈춘다. guessed CDN URL이나 제3자 파일을 만들지 않는다.

### 21. Snapchat (`snapchat`)

- **상태와 공식 출처**: 인증 또는 갱신 필요. [Login Kit](https://developers.snap.com/snap-kit/login-kit/overview), [앱 리뷰 브랜드 지침](https://developers.snap.com/snap-kit/app-review/brand-guidelines), [Snap 브랜드 지침](https://www.snap.com/en-US/brand-guidelines)을 확인한다.
- **실제 획득**: 공식 브랜드 페이지가 연결한 Snap Vault 공유는 조사 당시 만료 링크와 로그인 화면을 보였다. 공개 직접 URL은 확인되지 않았다.
- **선택**: 갱신된 공식 공유나 인증된 Vault에서 Login Kit용 Ghost 자산을 직접 확인해 고른다. 파일명과 형식을 미리 단정하지 않는다.
- **외형과 변환**: 공식 Ghost 원본을 유지한다. 지침 PDF나 예시 화면을 로고 파일로 쓰지 않는다.
- **사용과 재배포**: Login Kit 통합 사용과 일반 로고 패키지 재배포를 구분한다.
- **에이전트 절차**: 공유 갱신 또는 사용자 로그인을 요청한다. 접근 전에는 자동 다운로드 경로를 만들지 않고 상태를 `authenticated`로 남긴다.

### 22. VK (`vk`)

- **상태와 공식 출처**: 문서 추출. [VK ID 맞춤 버튼 문서](https://id.vk.ru/about/business/go/docs/ru/vkid/latest/vk-id/connection/elements/custom-button/custom-button-web)와 [VK ID Web SDK](https://github.com/VKCOM/vkid-web-sdk)를 확인한다.
- **실제 획득**: 맞춤 버튼 문서의 28 x 28 인라인 SVG 코드를 그대로 복사한다. 별도 PNG URL을 추측하지 않는다.
- **선택**: 흰색 VK 마크와 `#0077ff` 버튼 조합을 쓴다. 문서의 44px 버튼 높이와 8px 모서리 규칙을 따른다.
- **외형과 변환**: 인라인 SVG의 path와 흰색 fill을 유지한다. PNG가 꼭 필요하면 원본 SVG를 투명 배경에 렌더링하고 시각적으로 원본과 비교한다.
- **사용과 재배포**: SDK와 맞춤 버튼 마크업 제공은 추출한 정적 로고의 범용 재배포 허가와 같지 않다.
- **에이전트 절차**: 공식 코드 블록에서 SVG 전체를 저장하고 XML 파싱이 되는지 확인한다. 렌더링 전후 색과 비율을 비교하며 path를 단순화하지 않는다.

### 23. Weibo (`weibo`)

- **상태와 공식 출처**: 직접. [Weibo 로그인 버튼](https://open.weibo.com/widget/loginbutton.php), [Connect 로그인](https://open.weibo.com/wiki/Connect/login), [Weibo 식별 페이지](https://open.weibo.com/wiki/%E5%BE%AE%E5%8D%9A%E6%A0%87%E8%AF%86/en)를 확인한다.
- **실제 획득**: [LOGO_64x64.png](https://www.sinaimg.cn/blog/developer/wiki/LOGO_64x64.png)을 내려받는다. 2011년 계열의 오래된 공식 페이지지만 조사 당시 PNG는 실제로 응답했다.
- **선택**: 제공된 64 x 64 원본을 쓴다.
- **외형과 변환**: 원본 색과 비율을 유지한다. 저해상도를 무리하게 확대하지 않는다.
- **사용과 재배포**: 개발자 식별 맥락은 확인됐지만 독립 패키지 재배포 허가는 확인되지 않았다.
- **에이전트 절차**: 직접 PNG를 저장하고 시그니처를 확인한다. 오래된 공식 자산이라는 점과 확인일을 기록한다.

### 24. QQ (`qq`)

- **상태와 공식 출처**: PSD 직접 획득 성공, PNG 변환 미검증. [QQ 시각 자산 다운로드](https://wiki.connect.qq.com/%e8%a7%86%e8%a7%89%e7%b4%a0%e6%9d%90%e4%b8%8b%e8%bd%bd), [QQ 로그인 버튼 문서](https://wiki.connect.qq.com/%e6%94%be%e7%bd%aeqq%e7%99%bb%e5%bd%95%e6%8c%89%e9%92%ae_oauth2-0), [QQ 브랜드](https://qq.design/brand/BrandDesign/Logo)를 확인한다.
- **실제 획득**: [03_qq_symbol.psd](https://tangram-1251316161.file.myqcloud.com/qqconnect/icon/03_qq_symbol.psd)를 내려받는다. 부모의 20초 요청은 timeout이었지만 worker와 부모의 60초 재시도는 HTTP 200, PSD 560,940바이트, SHA-256 `8120ebad7c9ea0e3fa53cd2eb19ffecd14998c3140715858bf30c5553e8a1a3b`로 성공했다.
- **선택**: 독립 심볼은 PSD 안에서 레이어, 캔버스, 투명도를 사람이 확인한 뒤 정한다. 대안인 [Connect_logo_7.png](https://qzonestyle.gtimg.cn/qzone/vas/opensns/res/img/Connect_logo_7.png)는 완성 로그인 컨트롤이다.
- **외형과 변환**: PSD의 레이어 트리와 투명도, 올바른 PNG 내보내기는 아직 입증되지 않았다. 완성 컨트롤에서 펭귄만 크롭하면 안 된다.
- **사용과 재배포**: 공식 다운로드와 로그인 컨트롤 사용은 확인할 수 있지만 독립 심볼 패키지 재배포는 명시되지 않았다.
- **에이전트 절차**: PSD는 긴 네트워크 제한으로 저장하고 PSD 시그니처를 확인한다. Photoshop 또는 PSD를 정확히 읽는 도구로 레이어를 열어 시각 검수한 뒤 PNG를 내보낸다. 그 검수가 없으면 `PNG export unverified`로 남긴다.

### 25. Epic Games (`epicGames`)

- **상태와 공식 출처**: 좁은 미검증. [Epic Account Services Auth Interface](https://dev.epicgames.com/docs/epic-account-services/auth/auth-interface)와 [Epic 약관](https://www.epicgames.com/site/en-US/tos)을 확인한다.
- **실제 획득**: 공개 인증 문서는 열렸지만 재사용 가능한 로그인 아트워크 다운로드는 확인하지 못했다. 내비게이션의 Epic 로고는 다운로드 자산이 아니다.
- **선택**: 공개 파일명, 형식, 멤버를 확정하지 않는다. Epic 개발자 또는 파트너 계정 안에서 제공되는 인증 자산과 조건이 있는지 확인해야 한다.
- **외형과 변환**: 공식 파일을 얻기 전에는 변환하지 않는다. 사이트 로고나 스크린샷을 크롭하지 않는다.
- **사용과 재배포**: 이번 조사는 공개 경로에서 자산을 입증하지 못했을 뿐, 모든 자산이 항상 partner-only이거나 존재하지 않는다고 주장하지 않는다.
- **에이전트 절차**: 공개 Auth 문서에서 시작해 계정에 허용된 개발자 리소스를 확인한다. 다운로드 컨트롤과 적용 약관을 실제로 본 뒤에만 경로를 기록한다.

### 26. PlayStation (`playstation`)

- **상태와 공식 출처**: 좁은 미검증, 파트너 경로 확인 필요. [저작권 및 상표 공지](https://www.playstation.com/en-us/legal/copyright-and-trademark-notice/)와 [PlayStation Partners](https://partners.playstation.net/)를 확인한다.
- **실제 획득**: 공개 법무 페이지의 패밀리 마크는 로그인 다운로드 키트가 아니다. 파트너 포털은 로그인 경로까지 확인됐고 실제 자산은 인증 후 확인해야 한다.
- **선택**: 공개 상태에서 파일명이나 변형을 확정하지 않는다. 파트너 포털에서 로그인 UI용으로 명시된 자산만 선택한다.
- **외형과 변환**: 공식 로그인 자산을 받기 전에는 페이지 로고를 저장하거나 변환하지 않는다.
- **사용과 재배포**: 공개 약관은 마크 복제에 명시적 서면 동의를 요구할 수 있다. 다만 이번 관찰만으로 모든 취득이 절대적으로 파트너 전용이라고 확대하지 않는다.
- **에이전트 절차**: 사용자에게 파트너 계정 로그인이 필요함을 알린다. 인증 뒤 다운로드와 사용 조건을 확인할 때까지 상태를 `unverified`로 유지한다.

### 27. Nintendo (`nintendo`)

- **상태와 공식 출처**: 좁은 미검증, 개발자 접근 필요. [Nintendo Developer Portal](https://developer.nintendo.com/)과 [등록 및 접근 절차](https://developer.nintendo.com/the-process), [네트워크 서비스 가이드라인](https://www.nintendo.co.jp/networkservice_guideline/en/index.html)을 확인한다.
- **실제 획득**: 포털은 등록, 로그인, NDA와 약관, 추가 접근 신청 절차를 안내한다. 공개 일반 Nintendo Account 로그인 아트워크는 확인하지 못했다.
- **선택**: 권한이 부여된 개발자 리소스에서 정확한 로그인 자산을 확인한 뒤 선택한다. 공개 파일명이나 멤버를 추정하지 않는다.
- **외형과 변환**: 자산을 받기 전에는 Nintendo 워드마크나 사이트 헤더를 대신 사용하지 않는다.
- **사용과 재배포**: 공개 경로 미확인은 자산 부재나 영구적인 partner-only를 뜻하지 않는다. 접근 후 약관이 허용하는 범위만 사용한다.
- **에이전트 절차**: 등록과 계약이 필요한 외부 행동임을 알리고 멈춘다. 사용자가 접근을 완료한 뒤 공식 다운로드와 권한을 다시 기록한다.

### 28. Xbox (`xbox`)

- **상태와 공식 출처**: 인증 경로. [Xbox 문서](https://learn.microsoft.com/en-us/xbox/), [브랜딩 및 마케팅 자산 접근 문서](https://learn.microsoft.com/en-us/gaming/game-publishing/resources/managed-support/how-to-access-branding-and-marketing-assets), [Microsoft 상표 지침](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks)을 확인한다.
- **실제 획득**: Xbox Brand Assets 경로는 조사 당시 Microsoft 계정 로그인으로 이동했다. 공개 상태에서 재사용 가능한 로그인 자산 바이너리는 확인되지 않았다.
- **선택**: Partner Center 또는 허용된 계정 안에서 로그인용으로 표시된 자산을 확인한 뒤 고른다.
- **외형과 변환**: 공개 문서의 장식 이미지나 Xbox 로고를 크롭하지 않는다.
- **사용과 재배포**: 많은 Xbox 로고와 아이콘 사용에는 라이선스가 필요하다고 Microsoft가 밝힌다. 이번 결과를 모든 자산의 절대 부재로 확대하지 않는다.
- **에이전트 절차**: 사용자에게 Microsoft 계정 또는 Partner Center 접근이 필요하다고 알린다. 인증 전에는 파일 URL과 권한을 추측하지 않는다.

### 29. Zoom (`zoom`)

- **상태와 공식 출처**: 확인한 표면 blank, 미검증. [Zoom OAuth 문서](https://developers.zoom.us/docs/integrations/oauth/)와 [Zoom Brand Portal](https://brand.zoom.us/)을 확인한다.
- **실제 획득**: 조사 브라우저에서 브랜드 포털은 1440 x 900의 빈 화면으로 렌더링됐고 `Skip to main content`만 감지됐다. 안정적인 바이너리 URL이나 실제 다운로드 컨트롤을 확인하지 못했다.
- **선택**: 기능이 정상인 브라우저 또는 필요한 계정으로 Brand Portal의 Logo Library를 열어 실제 멤버를 확인해야 한다.
- **외형과 변환**: 파일을 확인하기 전에는 미디어 키트나 페이지 헤더를 로그인 아이콘으로 대신 쓰지 않는다.
- **사용과 재배포**: checked blank는 자산 absence가 아니다. 공개 패키지 재배포 조건도 확인되지 않았다.
- **에이전트 절차**: 포털을 다른 정상 브라우저나 승인된 계정으로 다시 확인한다. 빈 렌더를 `파일 없음`으로 기록하지 않고 `checked blank`로 남긴다.

### 30. Kakao (`kakao`)

- **상태와 공식 출처**: 직접, 완전한 컨트롤. [Kakao Login 디자인 가이드](https://developers.kakao.com/docs/en/kakaologin/design-guide)와 [리소스 도구](https://developers.kakao.com/tool/resource/login)를 확인한다.
- **실제 획득**: [Kakao Login.zip](https://developers.kakao.com/tool/download/Kakao%20Login.zip)을 내려받는다. 조사 당시 ZIP과 선택 멤버를 독립 확인했다.
- **선택**: `Kakao Login/PNG @4x/kakao_login_light.png`를 쓴다. 이 멤버는 밝은 Kakao Login 완성 컨트롤이다.
- **외형과 변환**: 완성 컨트롤 전체를 사용한다. 말풍선 마크만 아이콘으로 크롭하면 안 된다.
- **사용과 재배포**: Kakao Login 지침에 맞춘 로그인 사용과 범용 패키지 재배포는 별도다.
- **에이전트 절차**: ZIP에서 정확한 멤버를 추출하고 원본 전체 이미지를 보존한다. 아이콘 전용 요구라면 `공식 독립 아이콘 경로 미확인`으로 막는다.

### 31. Naver (`naver`)

- **상태와 공식 출처**: 직접. [Naver Login BI 가이드](https://developers.naver.com/docs/login/bi/bi.md)를 기준으로 한다.
- **실제 획득**: [NAVER_login_KR.zip](https://developers.naver.com/inc/devcenter/downloads/bi/NAVER_login_KR.zip)을 내려받는다.
- **선택**: `NAVER_login_KR/NAVER_login_Dark_KR_green_icon_H56.png`를 쓴다.
- **외형과 변환**: 멤버의 내부 여백을 그대로 보존한다. 여백 제거, 재채색, 글자와 아이콘 분리는 하지 않는다.
- **사용과 재배포**: Naver Login BI 목적과 제한된 맞춤 범위는 확인되지만 blanket 재배포 권한은 명시되지 않았다.
- **에이전트 절차**: ZIP과 정확한 멤버를 확인해 추출한다. 자동 트림 기능을 끄고 원본 캔버스 그대로 저장한다.

### 32. Google (`google`)

- **상태와 공식 출처**: 직접. [Google Identity 브랜딩 지침](https://developers.google.com/identity/branding-guidelines)을 따른다.
- **실제 획득**: [표준색 G PNG](https://developers.google.com/static/identity/images/g-logo.png)를 내려받는다.
- **선택**: 밝은색과 어두운색 버튼 모두 공식 표준색 G를 쓰고, 버튼 배경과 테두리는 지침의 각 변형을 따른다.
- **외형과 변환**: 그라디언트 색과 비율을 유지한다. 보통 20 논리 픽셀 영역에 비례 축소하며 단색화하지 않는다.
- **사용과 재배포**: 지침에 맞는 맞춤 `Sign in with Google` 버튼 사용은 허용되지만, 그 밖의 사용이나 독립 로고 재배포는 별도 동의가 필요할 수 있다.
- **에이전트 절차**: 직접 PNG를 저장하고 원본 색을 보존한다. 버튼 전체 간격, 라벨, 테두리도 공식 지침과 대조한다.

### 33. Apple (`apple`)

- **상태와 공식 출처**: 생성형 직접 경로. [다른 플랫폼의 Sign in with Apple](https://developer.apple.com/documentation/signinwithapple/incorporating-sign-in-with-apple-into-other-platforms)과 [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/sign-in-with-apple)을 확인한다.
- **실제 획득**: 검정 컨트롤 자산은 [color=black endpoint](https://appleid.cdn-apple.com/appleid/button/logo?size=44&color=black&border=false&border_radius=8&scale=2), 흰색 컨트롤 자산은 [color=white endpoint](https://appleid.cdn-apple.com/appleid/button/logo?size=44&color=white&border=false&border_radius=8&scale=2)에서 생성한다.
- **선택**: 어두운 변형에는 `color=black`, 밝은 변형에는 `color=white` 응답을 각각 쓴다. 여기서 `color`는 글리프 색이 아니라 생성되는 컨트롤 배경 변형을 뜻한다.
- **외형과 변환**: 두 응답은 서로 다른 공식 생성물이다. 하나를 반전해 다른 변형을 만들지 않는다. 크기, 테두리, 모서리 파라미터도 Apple 요구 범위 안에서 지정한다.
- **사용과 재배포**: 생성 엔드포인트는 문서화된 임베딩을 위한 것이다. 더 넓은 상표 라이선스나 범용 패키지 재배포를 뜻하지 않는다.
- **에이전트 절차**: 필요한 변형마다 공식 엔드포인트를 별도로 호출하고 PNG 시그니처를 확인한다. 응답 원본과 사용한 파라미터를 함께 기록한다.

### 34. TikTok (`tiktok`)

- **상태와 공식 출처**: 직접, 완전한 컨트롤, 권한 확인. [TikTok 디자인 지침](https://developers.tiktok.com/doc/getting-started-design-guidelines)과 [TikTok Brand Book 법무 안내](https://tiktokbrandbook.com/d/HhXfjVK1Poj9/legal)를 확인한다.
- **실제 획득**: 공식 문서가 제공하는 [logo-pack.zip](https://sf16-va.tiktokcdn.com/obj/eden-va2/uvzhqeh7nuhd/tt4d/logo-pack.zip)을 내려받는다.
- **선택**: `Dev Portal Logo Pack/TikTok Button Pack/TikTok - Button PNG/Button_Black.png`를 쓴다. 조사 당시 315 x 44의 완성 버튼으로 확인됐다.
- **외형과 변환**: 완성 컨트롤 전체를 쓴다. TikTok 마크만 잘라 일반 아이콘으로 만들면 안 된다.
- **사용과 재배포**: 공식 다운로드가 성공했어도 TikTok 법무 안내의 사전 서면 허가 조항은 별도로 남는다. 패키지 배포 승인을 추론하지 않는다.
- **에이전트 절차**: ZIP과 정확한 멤버를 검증한다. 아이콘 전용 요청이면 자동 변환을 중단하고 사용 권한과 독립 자산을 다시 확인한다.

### 35. Notion (`notion`)

- **상태와 공식 출처**: 공개 브라우저 수동 다운로드. [Notion 공식 Media Kit](https://notion.notion.site/Media-Kit-205535b1d9c4440497a3d7a2ac096286)와 [Notion 인증 가이드](https://developers.notion.com/guides/get-started/authorization)를 확인한다.
- **실제 획득**: Media Kit 페이지의 `NotionLogoFiles.zip 168.2 KiB` 블록을 브라우저에서 클릭해 내려받는다. 조사 화면에서 `Media Kit`, Notion 설명, ZIP 이름과 크기, `press@makenotion.com`을 확인했다. 안정적인 직접 첨부 URL은 검증하지 않았다.
- **선택**: ZIP을 실제로 받은 뒤 멤버 목록과 미리보기를 보고 현재 로그인 표면에 맞는 공식 흰색 또는 검정 마크를 고른다. 확인 전에는 멤버명을 만들지 않는다.
- **외형과 변환**: 공식 멤버의 비율, 테두리, 글자 구성을 유지한다. 다운로드 전 페이지 미리보기를 크롭하지 않는다.
- **사용과 재배포**: 공개 Media Kit 다운로드는 일반 미디어 사용 경로다. OAuth 버튼 허가나 패키지 재배포 권한을 입증하지 않는다.
- **에이전트 절차**: 브라우저로 ZIP 블록을 직접 클릭하고 받은 파일이 ZIP인지 검사한다. 임시 첨부 URL을 영구 경로로 기록하지 않으며, 아카이브 해시와 멤버 선택은 실제 다운로드 후 새로 측정한다.

## 미확인 상태를 해소하는 순서

1. 먼저 공식 출처에서 현재 다운로드 컨트롤과 약관을 다시 확인한다.
2. 앱 또는 파트너 인증이 필요한 경우 사용자가 로그인한 뒤 자산 이름, 형식, 다운로드 동작, 적용 약관을 기록한다.
3. 파일을 받으면 바이너리 형식과 실제 외형을 모두 본다. 확장자만 맞는 HTML이나 예시 이미지는 거부한다.
4. 독립 아이콘이 아니라 완성 컨트롤만 제공되면 컨트롤 전체를 사용하거나 아이콘 요구를 미충족으로 남긴다.
5. PSD처럼 변환 결과가 검증되지 않은 원본은 시각 검수와 투명도 확인 전까지 자동 PNG 경로로 승격하지 않는다.
6. 사용 또는 재배포 허가가 불명확하면 제공자의 브랜드 또는 파트너 담당 경로로 확인한다. 확인 전에는 `허용`으로 기록하지 않는다.

## 연구 근거

- [35개 제공자 안내와 공식 출처](docs/PROVIDER_GUIDE.md)
- [35개 기계 판독 다운로드 계획](download-plan.json)

로컬 조사 로그와 내부 QA 기록은 공개 저장소에 포함하지 않습니다.

이 근거들은 취득 당시의 관찰을 기록한다. 실제 배포 판단은 최신 제공자 약관과 필요한 승인 결과를 기준으로 다시 내려야 한다.


## 2026-10-01 실제 appearance 통합 및 지원 한계

기본값 35개(부모가 이미 적용한 GitHub 기본값 포함)와 앱의 명시적 `logo` override는 그대로 유지했다. `SocialButtonAppearanceStyle.asset`으로 explicit light/dark만 원본 PNG를 선택한다. X·Discord·LinkedIn·Twitch·Spotify는 서로 다른 검정/흰색/컬러 원본이며 GitLab·Telegram·Reddit·Bitbucket·Weibo는 검증한 동일 컬러 원본을 공유한다. 내부 흰 요소·색상·전체 캔버스·여백·컨테이너를 유지한다. Bitbucket 원본은 파랑이 아니라 #94C748/#101214이다.

LINE과 Kakao는 밝은/어두운 페이지에서도 기존 공식 녹색/노랑 컨테이너를 유지한다. Naver light는 #03A94D, dark는 #05AC4F 원본을 선택한다. 이름만으로 심볼 색을 해석하지 않는다. PayPal은 투명 FullColor monogram을 light에만 연결한다. FullColor-Black/White는 불투명 배경 타일이므로 dark 흰 glyph 대체품으로 쓰지 않는다. 미구현 dark 요청은 기존 기본값으로 돌아가며, 이는 권리나 표면 사용을 금지하는 정책이 아니다.

패키지 표면 지원과 공식 인증 컨트롤 승인은 서로 다른 값이다. `asset.variants`는 35개 모두 providerDefault/light/dark 전체 객체를 제공하고 실제 Flutter 선택 경로·PNG 해시·source·download·archiveSha256/member·conditions·implemented·authControlApproved를 담는다. 기본 파생 PNG에는 실제 미리보기 PNG의 sha256과 원본 SVG의 sourceSha256/sourceFormat을 별도 기록한다. `download-plan.json`의 `variants`는 획득 후보, `appearanceVariants`는 현재 선택 경로다. 미지원 요청도 fallback 경로를 명시한다. `official`은 원본 출처이고 인증 규격 승인이나 재배포 허가가 아니다.

Slack·Steam·Google·TikTok의 complete-auth-control PNG는 `assets/original/<id>/` 아래 전체 원본으로 보존하고 획득 계획에 기록했다. common 로고 슬롯에 넣거나 glyph를 잘라 쓰지 않는다. Slack의 기존 standalone light 파생 PNG와 dark 흰 tint는 남아 있는 명시적 한계이며 새 공식 variant로 포장하지 않는다. TikTok horizontal wordmark와 Spotify full logo도 좁은 glyph 슬롯으로 크롭하지 않는다.

Meta Facebook/Instagram은 측정된 exact member/hash가 있지만 현재 랜딩의 약관 체크박스와 최신 서명 URL 갱신을 거쳐야 한다. 이 통합에서는 설치하지 않았다. 공개 팩이 없다는 뜻이 아니다. Dropbox·Pinterest·Snapchat·Notion 등 수동 원본도 부재라고 단정하지 않고 기존 연구의 다음 획득 단계를 유지한다. QQ PSD와 VK inline SVG는 PNG 출력이 미검증이다.

| 제공자 | 실제 light 선택 | 실제 dark 선택 | 공식 획득 상태 | 한계/다음 확인 |
| --- | --- | --- | --- | --- |
| `facebook` | 기본값 fallback (원본 미해결) | 기본값 fallback (원본 미해결) | signed-refresh | 검정 원본은 이번 팩에서 검증하지 못했다. 매번 공식 랜딩에서 서명 URL 갱신; 표시되는 약관을 따른다. |
| `github` | `assets/original/github/GitHub_Invertocat_Black.png` | `assets/original/github/GitHub_Invertocat_White.png` | archive | 측정된 대비 원본 확보; 인증 컨트롤·재배포 승인 별도 |
| `microsoft` | `assets/social/microsoft.png` | `assets/social/microsoft.png` | direct | 검정/흰 심볼 대안을 검증하지 않았다. 색상 원본을 배경에 맞춰 tint하지 않는다. |
| `x` | `assets/original/x/logo-black.png` | `assets/original/x/logo-white.png` | archive | 측정된 대비 원본 확보; 인증 컨트롤·재배포 승인 별도 |
| `line` | `assets/original/line/line_88.png` | `assets/original/line/line_88.png` | archive | 독립 검정/컬러 LINE 심볼 대안을 이 인증 팩에서 검증하지 않았다. 흰 심볼을 흰 페이지에 단독 표시하지 않는다. |
| `discord` | `assets/original/discord/Discord-Symbol-Black.png` | `assets/original/discord/Discord-Symbol-White.png` | archive | 측정된 대비 원본 확보; 인증 컨트롤·재배포 승인 별도 |
| `linkedin` | `assets/original/linkedin/LI-In-Bug.png` | `assets/original/linkedin/InBug-White.png` | archive | 측정된 대비 원본 확보; 인증 컨트롤·재배포 승인 별도 |
| `slack` | `assets/social/slack-light.png` | `assets/social/slack.png` | authenticated | 생성기 앱 생성/선택 및 DAM 인증 후 standalone 원본 확인 필요. 현 Slack dark logoColor white tint는 부모 보고의 기존 제한이며 공식 dark 파일 취득으로 간주하지 않는다. |
| `twitch` | `assets/original/twitch/glitch_flat_black-ops.png` | `assets/original/twitch/glitch_flat_white.png` | archive | 측정된 대비 원본 확보; 인증 컨트롤·재배포 승인 별도 |
| `spotify` | `assets/original/spotify/Spotify_Primary_Logo_RGB_Black.png` | `assets/original/spotify/Spotify_Primary_Logo_RGB_White.png` | direct | 측정된 대비 원본 확보; 인증 컨트롤·재배포 승인 별도 |
| `steam` | 기본값 fallback (원본 미해결) | 기본값 fallback (원본 미해결) | direct | 독립 black/white/color Steam 심볼은 이 공식 인증 문서의 취득 경로에서 미검증. 제공된 컨트롤을 가상 light/dark 쌍으로 재분류하지 않는다. |
| `reddit` | `assets/original/reddit/Reddit_Logo.png` | `assets/original/reddit/Reddit_Logo.png` | direct | 공식 페이지가 연결한 Reddit Lingo Logo Library에서 검정/흰 standalone 파일은 아직 바이트/멤버 미검증. 공개 기본 PNG 존재와 다른 변형의 부재를 동일시하지 않는다. |
| `dropbox` | 기본값 fallback (원본 미해결) | 기본값 fallback (원본 미해결) | browser | 기존 브라우저 증거에는 Logos → Dropbox → Glyph → Glyph_128.png → Download가 있다. dl=1 GET은 HTML이었다. 브라우저로 실제 원본을 저장해 PNG·색상·해시 확인 필요; 검정/흰 대안 여부도 미확인. |
| `gitlab` | `assets/original/gitlab/gitlab-logo-500-rgb.png` | `assets/original/gitlab/gitlab-logo-500-rgb.png` | direct | 이 press-kit 다운로드 목록에서 독립 black/white 심볼의 바이트는 확인하지 않았다. 컬러를 평면 흰색으로 tint하지 않는다. |
| `bitbucket` | `assets/original/bitbucket/Bitbucket_icon.png` | `assets/original/bitbucket/Bitbucket_icon.png` | archive | 기존 계획의 blue 설명은 실제 원본과 불일치. 현재 ZIP/멤버 해시는 기존 값과 같고 SVG와 PNG는 #94C748 및 #101214다. 별도 흰 standalone 앱 아이콘은 미검증. |
| `paypal` | `assets/original/paypal/PayPal-Monogram-FullColor-RGB.png` | 기본값 fallback (원본 미해결) | archive | 공식 흰 standalone glyph의 직접 파일 경로 미확인. 3840x2160 불투명 타일을 크롭하거나 반전해 대체하지 않는다. |
| `telegram` | `assets/original/telegram/Logo.png` | `assets/original/telegram/Logo.png` | archive | 독립 검정/흰 variant는 이 공식 media ZIP에서 검증하지 않았다. 흰 비행기를 추출하거나 컬러 원형을 제거하지 않는다. |
| `instagram` | 기본값 fallback (원본 미해결) | 기본값 fallback (원본 미해결) | signed-refresh | 최신 서명 URL은 공식 랜딩에서 매번 갱신하고 필요한 약관을 따른다. |
| `wechat` | 기본값 fallback (원본 미해결) | 기본값 fallback (원본 미해결) | unverified | 기존 공식 wechat.design/brand/download 표면에서 파일 다운로드 제어를 확인하지 못했다. QR SDK는 사용 가능성 별도이며 white/black/color 원본 존재 여부는 결론 내리지 않는다. |
| `pinterest` | 기본값 fallback (원본 미해결) | 기본값 fallback (원본 미해결) | authenticated | 기존 https://www.pinterest-assets.com/asset-management/2THWMKDBK3GQ 포털은 Login/Register, GET HTML. 로그인 후 red/black/white 원본 PNG/EPS 및 멤버·해시 확인 필요; 현재는 예상 명칭이지 검증 파일이 아니다. |
| `snapchat` | 기본값 fallback (원본 미해결) | 기본값 fallback (원본 미해결) | authenticated | 기존 공식 Snap Vault 링크는 만료/Login. 최신 공유 링크와 필요한 인증 후 Ghost 색상 원본 확인. 가이드 PDF나 예시 타일은 원본 로고 대신 채택하지 않는다. |
| `vk` | 기본값 fallback (원본 미해결) | 기본값 fallback (원본 미해결) | inline-source | 직접 이미지 URL이 아닌 문서 inline 코드. 기존 SVG 추출 해시는 있으나 PNG export 및 검정/컬러 원본은 미검증. |
| `weibo` | `assets/original/weibo/LOGO_64x64.png` | `assets/original/weibo/LOGO_64x64.png` | direct | 해당 공식 developer 경로에서 독립 검정/흰 원본은 미검증. 검정 요소가 어두운 배경에 묻히면 임의 흰색 tint 대신 공식 대안 확보 필요. |
| `qq` | 기본값 fallback (원본 미해결) | 기본값 fallback (원본 미해결) | direct | 기존 GET200 PSD 560940B는 확인됐지만 레이어/투명도/변형·PNG export는 미검증. 원본 PSD를 열어 전체 캔버스와 레이어를 확인한 뒤 색상·출력 해시 검증 필요. |
| `epicGames` | 기본값 fallback (원본 미해결) | 기본값 fallback (원본 미해결) | unverified | 확인한 공개 인증 문서에서 재사용 가능한 black/white/color 로그인 artwork를 입증하지 못했다. 공식 브랜드 자산 경로나 승인된 파일 제공이 필요; partner-only라고 단정하지 않는다. |
| `playstation` | 기본값 fallback (원본 미해결) | 기본값 fallback (원본 미해결) | permission | partners.playstation.net의 Join/Sign In 표면까지 확인. 실제 원본 pack·색상·로그인 용도 미검증. 승인된 공식 파일 취득 후 검사하며 법률 페이지의 family mark를 대신 복사하지 않는다. |
| `nintendo` | 기본값 fallback (원본 미해결) | 기본값 fallback (원본 미해결) | unverified | developer.nintendo.com/the-process 등록 이후 자료 내용 미조사. 공개 재사용 로그인 로고 파일과 black/white/color 변형 미검증; 자산 부재나 partner-only를 추론하지 않는다. |
| `xbox` | 기본값 fallback (원본 미해결) | 기본값 fallback (원본 미해결) | authenticated | 기존 Brand Assets 경로는 Microsoft account login, 개발 파트너 계정/GDK Agreement 필요. 보호 자료 안에 특정 로그인 팩이 있는지는 미검증. |
| `zoom` | 기본값 fallback (원본 미해결) | 기본값 fallback (원본 미해결) | unverified | 기존 Frontify Brand Center가 빈 화면/안정 바이너리 링크 미확립. 정상 브라우저의 Logo Library 및 약관 재확인 필요. 빈 캡처를 로고 부재 증거로 쓰지 않는다. |
| `kakao` | `assets/original/kakao/kakao_login_light.png` | `assets/original/kakao/kakao_login_light.png` | archive | 공식 pack에서 대응 dark/white standalone 로그인 심볼은 미검증. 노랑 배경·내부 여백·반경 제거 금지. |
| `naver` | `assets/original/naver/NAVER_login_Light_KR_green_icon_H56.png` | `assets/original/naver/NAVER_login_Dark_KR_green_icon_H56.png` | archive | Light green #03A94D와 Dark green #05AC4F는 실제 원본 차이. 재색칠로 맞추지 않는다. icon 컨테이너를 로고 슬롯용으로 크롭하지 않는다. |
| `google` | `assets/social/google.png` | `assets/social/google.png` | direct | 측정된 대비 원본 확보; 인증 컨트롤·재배포 승인 별도 |
| `apple` | `assets/social/apple-light.png` | `assets/social/apple.png` | direct | 측정된 대비 원본 확보; 인증 컨트롤·재배포 승인 별도 |
| `tiktok` | 기본값 fallback (원본 미해결) | 기본값 fallback (원본 미해결) | archive | 이번 취득 pack에서 standalone 로그인 glyph는 미검증. 흑/백 horizontal wordmark는 가로 10001px 전체 로고이며 24px glyph로 크롭 금지. |
| `notion` | 기본값 fallback (원본 미해결) | 기본값 fallback (원본 미해결) | browser | 기존 브라우저에서 NotionLogoFiles.zip 168.2KiB 첨부 확인. 클릭 다운로드 후 ZIP signature, black/white/color 멤버 및 해시 확인 필요. 공개 팩 존재는 확인됐으므로 부재라고 쓰지 않는다. |

### 직접 검증과 장애 확인 순서

1. `landing/logo-catalog.json`의 asset.variants에서 선택한 preview와 Flutter appearanceStyles 경로가 같은지 확인한다. providerDefault에는 기존 경로가 유지되고 앱 logo override에는 package 키와 tint가 없어야 한다.
2. 공식 랜딩/필요한 동의·서명 갱신 → HTTP/ZIP 또는 PNG signature → exact member → 연구 SHA-256 → 원본 색·alpha·전체 캔버스 → 인증 지침·권리 순서로 확인한다. 실제 바이트 해시가 다르면 파일 변경부터 조사하고 임의 재색칠로 맞추지 않는다.
3. `fvm flutter test`, `fvm flutter analyze`로 기본값·선택 경로·무재색칠·카탈로그 35개 매트릭스를 검증한다. 랜딩 브라우저 QA/빌드는 부모 작업에서 별도로 수행하며 이 트랙의 QA 완료로 대신하지 않는다.

원본 획득은 curl과 ZIP member 추출뿐이며 SVG/PSD 변환, crop, tint, inversion을 새로 수행하지 않았다. 파일 크기를 줄이기 위한 리샘플도 하지 않았다. 사용자가 직접 확인한 이해와 운영·법적 준비는 이 자동 검증과 별개다.

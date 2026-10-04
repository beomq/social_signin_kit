# 문제 해결

문제가 생기면 에셋, API 이름, 앱 상태, locale 순서로 확인하세요.

## 로고 이미지가 표시되지 않음

패키지는 브랜드 이미지를 제공하지 않습니다. `logo`는 소비 앱의 필수
이미지 경로이며 앱의 `flutter/assets` 선언과 대소문자를 확인하세요.
로딩 오류는 해당 경로와 앱 자산 선언 안내를 포함합니다.

## 버튼 너비가 서로 다름

같은 너비의 레이블 버튼은 `SocialButtonList.vertical`에 넣으세요.

```dart
SocialButtonList.vertical(
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
```

부모가 무한 너비를 주는 가로 스크롤 영역에서는 목록에 유한한 너비를 먼저
제공해야 합니다.

## 가로 버튼이 화면 밖으로 나감

`SocialButtonList.horizontal`은 공간이 부족하면 다음 줄로 넘어갑니다. 직접
`Row`를 만들었다면 목록 위젯으로 바꾸거나 앱에서 스크롤 정책을 정하세요.

## 목록 설정이 한 버튼에 적용되지 않음

각 버튼의 값이 목록 값보다 우선합니다.

```text
각 버튼 > 목록 > 패키지 기본값
```

해당 `SocialButton`에 `shape`, `size`, `locale`이 지정돼 있는지 확인하세요.

## 한국어 대신 영어가 표시됨

- 앱의 현재 locale이 실제로 `ko`인지 확인합니다.
- 버튼이나 목록에 영어 locale을 직접 전달했는지 봅니다.
- `label`을 직접 전달했다면 그 값이 항상 최우선입니다.
- `MaterialApp`의 locale 설정과 delegate 구성을 확인합니다.

패키지는 한국어가 아닌 모든 언어에서 영어로 fallback합니다. 더 많은 언어는
앱에서 번역한 `label`을 전달하세요.

## 버튼을 눌러도 로그인되지 않음

이 패키지는 인증을 구현하지 않습니다. 다음 순서로 확인하세요.

1. `onPressed`가 `null`이 아닌지 확인합니다.
2. 콜백 진입 여부를 앱 디버거로 확인합니다.
3. 앱의 OAuth, OpenID 또는 SDK 호출이 시작되는지 봅니다.
4. redirect URI와 플랫폼 설정을 확인합니다.
5. 토큰 교환과 오류 처리를 앱 인증 계층에서 확인합니다.

버튼이 렌더링됐다는 사실은 인증 설정이나 성공을 증명하지 않습니다.

## 버튼이 계속 비활성 상태임

`onPressed: null`이면 비활성입니다. 로딩 중 콜백을 `null`로 바꿨다면 성공과
실패 경로 모두에서 앱의 로딩 상태를 해제하는지 확인하세요.

## 로딩 표시가 없음

패키지에는 `isLoading`이 없습니다. 앱 상태로 진행 표시를 렌더링하고 요청
중에는 `onPressed: null`을 전달하세요. 예제는
[상태와 접근성](STATES.md)에 있습니다.

## 원형 버튼의 제공자를 구분하기 어려움

`circle`은 화면 레이블이 없으므로 정확한 로고와 레이블이 모두 필요합니다.
화면 읽기 도구와 tooltip에서 이름이 확인되는지 검사하세요. 로고만으로
구분하기 어려운 화면은 `rounded` 또는 `pill`을 사용합니다.

## 공식 버튼과 모양이 다름

공통 프리셋은 공식 버튼 복제품이 아닙니다. 색상 근거가 공식 출처에 연결된
경우에도 공통 모양과 상태 스타일은 패키지 선택입니다. 제공자 규칙이 완성형
버튼을 요구하면 [제공자 자산 가이드](PROVIDER_GUIDE.md)의 공식 구현을
사용하세요.

## 이전 이름을 찾을 수 없음

새 API는 `SocialButton`, `Social`, `SocialButtonShape`를 사용합니다.
`SocialLoginButton` 또는 `SocialLoginProvider` 오류가 나면
[마이그레이션](MIGRATION.md)을 참고하세요.

## 확인 명령

소비 앱의 변경 범위에 맞는 테스트와 분석을 실행합니다.

```sh
fvm flutter test
fvm flutter analyze
```

명령 통과와 실제 인증 성공은 별개입니다. 실제 화면에서 활성, 비활성, locale,
버튼 콜백과 인증 흐름을 따로 확인하세요.

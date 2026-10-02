# 상태와 접근성

버튼은 Flutter의 버튼 상태에 따라 활성, hover, focus, pressed, disabled
스타일을 표시합니다. 이 스타일은 사용성과 일관성을 위한 패키지 선택이며
제공자 공식 인증이나 브랜드 규격을 뜻하지 않습니다.

## 상태

| 상태 | 동작 |
| --- | --- |
| 활성 | 제공자 프리셋의 배경, 전경, 테두리를 사용 |
| hover | 팔레트 명도에 맞춘 8% overlay 표시 |
| focus | 팔레트 명도에 맞춘 12% overlay와 전경색 테두리 표시 |
| pressed | 누르는 동안 팔레트 명도에 맞춘 12% overlay 표시 |
| disabled | 제공자 팔레트에서 파생한 색상 적용, 콜백 호출 안 함 |

제공자 메타데이터에 공식 색상 출처가 있더라도 hover, focus, pressed,
disabled 조합까지 공식 승인을 받았다는 뜻은 아닙니다. 자세한 출처는
[제공자 자산 가이드](PROVIDER_GUIDE.md)를 확인하세요.

## 비활성 색상 계산

모든 제공자를 같은 회색으로 바꾸지 않습니다. 패키지는 각 제공자의 기본
팔레트에서 불투명한 비활성 색상을 계산합니다.

- 배경: 기본 배경에서 합성된 전경색 방향으로 8% 혼합
- 전경: 합성된 전경색에서 기본 배경 방향으로 12% 혼합
- 테두리: 제공자 테두리가 있으면 그 색, 없으면 합성된 전경색과 비활성
  배경의 중간색
- 로고: 앱이 제공한 원본을 tint하거나 흐리게 만들지 않음

Kakao처럼 투명도가 있는 전경색은 먼저 기본 배경 위에 합성합니다. 이렇게
계산한 색상과 8%, 12% 비율은 패키지 선택입니다. 제공자의 공식 disabled
상태 규격이 아닙니다.

## 비활성

`onPressed`에 `null`을 전달하면 버튼이 비활성화됩니다.

```dart
SocialButton(
  social: Social.google,
  onPressed: canStartSignIn ? startGoogleSignIn : null,
)
```

별도의 `enabled` 인자는 필요하지 않습니다. 상태의 단일 기준을
`onPressed`로 두면 화면 표시와 실제 입력 차단이 어긋나지 않습니다.

## 로딩

패키지는 `isLoading`을 제공하지 않습니다. 인증 요청의 수명과 결과를 모르는
UI 패키지가 로딩을 소유하면 중복 요청, 오류 복구, 화면 전환 시점이 앱 상태와
어긋날 수 있기 때문입니다.

```dart
Column(
  children: [
    SocialButton(
      social: Social.notion,
      onPressed: isSigningIn ? null : startNotionSignIn,
    ),
    if (isSigningIn) const LinearProgressIndicator(),
  ],
)
```

앱은 다음을 함께 관리해야 합니다.

- 요청 시작부터 완료 또는 실패까지의 로딩 상태
- 요청 중 `onPressed: null` 처리
- 오류 메시지와 재시도
- 화면 이탈 뒤 상태 정리
- 같은 요청의 중복 실행 방지

## 접근성 이름

`rounded`와 `pill`은 기본적으로 보이는 레이블을 접근성 이름으로 사용합니다.
`circle`은 레이블을 화면에서 숨기지만 tooltip과 접근성 이름은 유지합니다.
`semanticLabel`을 전달하면 접근성 이름과 tooltip만 바뀝니다.

```dart
SocialButton(
  social: Social.notion,
  shape: SocialButtonShape.circle,
  label: 'Notion 워크스페이스 연결',
  onPressed: startNotionSignIn,
)
```

앱에서 `label`을 바꿀 때는 다음을 확인하세요.

- 어떤 제공자와 동작인지 알 수 있는가
- 인증 성공을 미리 단정하지 않는가
- 번역 후에도 짧고 명확한가
- 같은 화면의 다른 원형 버튼과 구분되는가

## 키보드와 화면 읽기 도구 확인

1. Tab 또는 플랫폼의 focus 이동으로 버튼에 접근합니다.
2. focus 표시가 배경과 구분되는지 확인합니다.
3. Enter 또는 Space로 활성 버튼의 콜백이 한 번 실행되는지 확인합니다.
4. 비활성 버튼은 포인터와 키보드 입력에 반응하지 않는지 확인합니다.
5. 화면 읽기 도구가 제공자와 동작을 포함한 이름을 읽는지 확인합니다.
6. `circle` 버튼에 포인터를 올렸을 때 tooltip이 표시되는지 확인합니다.

## 크기

`size`는 버튼 높이이며 `circle`에서는 지름입니다. 기본값은 `48`입니다.
크기를 바꿀 때는 로고의 가독성뿐 아니라 터치 영역, 텍스트 배율, focus 표시를
함께 확인하세요.

```dart
SocialButton(
  social: Social.apple,
  size: 56,
  onPressed: startAppleSignIn,
)
```

앱의 접근성 기준이나 제공자 최소 크기와 충돌하면 더 큰 값을 사용하거나 공식
제어로 교체하세요.

`size`가 `48`보다 작아도 실제 터치 영역은 최소 48 logical pixel입니다.
레이블 버튼은 텍스트 배율에 따라 지정한 높이보다 커질 수 있으므로 큰 글자
설정에서도 확인하세요.

# pub.dev 코드 전용 게시 준비

사용자 선택에 따라 공개 패키지는 35종 스타일·문구·지원 근거만 제공합니다.
브랜드 이미지 파일, 자동 로고 매핑, 파일 취득 기록은 게시에서 제외합니다.

## 런타임 계약

- `SocialButton.logo`는 소비 앱의 필수 이미지 자산 경로입니다.
- 로고는 `BoxFit.contain`으로 표시하며 외형에 따라 자동 교체·재색칠하지 않습니다.
- `logoAspectRatio`는 기본 1이며 일반 버튼에서 원본 너비/높이를 전달합니다.
  원형 슬롯은 전체 이미지를 정사각형 안에 표시합니다.
- 위젯 로고를 받는 기존 `SocialLoginButton` API는 유지합니다.
- 예제는 자체 중립 데모 이미지를 사용하며 실제 브랜드 로고나 승인된 버튼이 아닙니다.

## 검증과 제한

코드 전용 수정 후 Flutter 3.29.0과 3.29.2에서 루트 58·예제 7개 테스트와
양쪽 분석이 통과했습니다. 번들 파일 검증은 앱 자산 로딩·무색조·외형별
경로 유지·명시적 비율 검증으로 바뀌었습니다. 최소 SDK 웹 빌드도 성공했습니다.
1280px·390px에서 중립 로고 예제를 직접 확인했습니다. 원격 CI는 아직 실행하지 않았습니다.

게시 스냅샷은 약 10MB이고 브랜드 PNG/SVG 및 미사용 데모 파일이 없습니다.
예제 실행에 필요한 Noto Sans KR 3개 폰트와 OFL 라이선스를 포함합니다.
최종 dry-run은 경고 0개, exit 0입니다. 기존 예제 테마의 CupertinoIcons
폰트 경고는 빌드에 남아 있으며 예제에 해당 아이콘 사용은 없습니다.

작업 디렉터리의 dry-run은 미커밋 파일을 경고합니다. Git 없는 동일 파일
스냅샷에서 게시 포함 파일과 경고 0개를 확인하고, 실제 게시 전 커밋 후 다시 검사합니다.
테스트 통과, dry-run 통과, 앱에서 사용할 이미지 권한, 실제 업로드 승인은 별개입니다.

## 이미지 사용 조건

코드 전용 배포는 미확인 로고 파일의 재배포를 피하는 범위입니다.
최종 앱이 브랜드 이미지를 쓰는 조건을 대신 해결하지는 않습니다.

- [Slack Brand](https://slack.com/terms-of-service/slack-brand)는 로고·자산 배포를 제한합니다.
- [TikTok Design](https://developers.tiktok.com/doc/getting-started-design-guidelines)은 사전 서면 허가를 요구합니다.
- [QQ Visual assets](https://wiki.connect.qq.com/%E8%A7%86%E8%A7%89%E7%B4%A0%E6%9D%90%E4%B8%8B%E8%BD%BD)는 앱 개발용 소재의 다른 제품 번들·전파를 제한합니다.
- [Simple Icons CC0](https://raw.githubusercontent.com/simple-icons/simple-icons/d4e6ba93e48f178898707f0145ec285f28b64b38/LICENSE.md)는 브랜드 상표권을 허가하지 않습니다.

## 직접 확인

`fvm spawn 3.29.0 analyze`, `fvm spawn 3.29.0 test`를 루트·예제에서
실행하고 3.29.2에서도 반복합니다. 예제 웹 빌드는
`fvm spawn 3.29.0 build web --release`, 사전 검사는
`fvm flutter pub publish --dry-run`입니다. 실제 업로드는 별도 사용자 지시 후 진행합니다.

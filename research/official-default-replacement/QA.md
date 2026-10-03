# 공식 기본 로고 16종 교체 검증

## 적용

공식 기본값 28종, Simple Icons 기본값 7종. 교체 16종은
`replacement-receipts.json`의 원본·런타임·SHA-256을 따른다.
14종은 원본 PNG와 바이트가 같고, QQ는 PSD 전체 composite를 PNG로 변환,
Steam은 공식 사이트 전체 SVG를 2배 크기 투명 PNG로 렌더링했다.
Steam은 EPS에서 독립 심볼을 잘라내지 않았다. Zoom과 Steam의 일반 버튼은
전체 비율에 맞는 로고 폭을 사용하며 원형 슬롯에서는 전체 로고를 축소한다.

## 실행 결과

- 루트 `fvm flutter test --reporter expanded`: 66개 통과.
- 루트 `fvm flutter analyze`: No issues found.
- example 테스트 6개와 analyze 통과, release web build exit 0.
- Dart LSP 오류 없음. JSON/JS LSP는 Biome 미설치로 실행 불가;
  JSON 실제 파싱, `node --check landing/chooser.js`, `git diff --check` 통과.
- 기본·라이트·다크 105개 로고 파일 SHA-256 전부 카탈로그와 일치.
- Chrome 390·1280px에서 16종 × 세 외형 이미지 decode 성공,
  페이지 가로 넘침 없음. Steam 79.42×24, Zoom 106.61×24px 표시 확인.
- 실제 생성 JSON 16종의 preview 파일 SHA-256 일치. 공식 PNG에 Simple Icons용
  rasterization/recolor 지시 없음. ZIP에는 아카이브 해시와 추출 멤버 기록.
- `landing/qa/official-preview-390.png`, `official-preview-1280.png`,
  `official-lower-390.png`, `official-wide-marks-390.png` 실제 화면 확인.

테스트의 기존 12종 공식성·기본색·Slack tint 기대값은 변경된 동작에 맞게 갱신했다.
새 회귀 테스트는 가로 로고 비율과 원형 전체 슬롯 표시를 검증한다.

## 한계

공식 파일 출처 확인은 인증 UI 승인·패키지 재배포 허가가 아니다.
일부 서명된 다운로드 주소는 만료될 수 있어 공식 페이지와 원본 해시를 함께 보존한다.
출시 전 조건 확인 항목은 유지한다. 나머지 7종은 자동 교체하지 않았으며
`remaining-seven.md`에 사용자 계정·승인과 파일 검증의 다음 순서를 구분했다.
위 결과는 로컬 구현·검증 시점의 기록이다. 커밋·푸시·Pages 재배포는
사용자의 별도 게시 요청에 따라 진행하며 배포 결과는 GitHub Actions에서 확인한다.

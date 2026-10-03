# 공식 기본 로고 교체: 남은 7종

기준: 2026-10-03 KST, 교체 전 제품 커밋 `5bbfef7`. 아래는 기존 조사 기록의 대조이며, 새 다운로드·로그인·신청은 실행하지 않았다. 각 항목의 공식 진입점과 실제 확인 범위를 표에 기록했다.

**실제로 사용 가능한 공식 원본을 검증하기 전까지 기본 Simple Icons는 변경하지 않는다.** 원본의 내용·형식·로그인 화면 적합성과 사용·패키지 재배포 조건은 별도로 확인한다. 공식 사이트 표시 자산은 의도된 배포 키트가 아니며, 공개 페이지·HTTP 200·다운로드 버튼만으로 파일 취득이나 사용 허가를 주장하지 않는다.

우선순위는 공개 라이브러리 다운로드 확인 → 기술적 조회 문제 해결 → 사용자 승인·계정 절차 순서다. 같은 단계에서는 이미 확인된 화면·경로가 구체적인 항목을 먼저 처리한다.

| 순위 / 제공자 | 공식 진입점 / 라이브러리·자료 경로 | 현재 검증 상태 | 권장 다음 조치 |
|---|---|---|---|
| 1. reddit | [Brand](https://redditinc.com/brand) / [Lingo](https://redditbrand.lingoapp.com/s/Logo-d9x3n2/) | `site-asset-only`. 사이트 lockup SVG 8,568B만 취득. Lingo 로고 섹션과 `public`, `downloadsRestricted false` 확인; 실제 다운로드 동작은 클릭하지 않았고 결과 URL·파일 미검증. | 공개 라이브러리에서 필요한 심볼의 다운로드 동작과 원본을 확인. 상업 프로젝트 연락 안내는 별도 검토; 공개 접근을 승인으로 해석하지 않음. |
| 2. vk | [VK brand](https://vk.com/brand) / [공식 다운로드 동작](https://vk.cc/logo) → [현재 Mail Cloud 폴더](https://cloud.mail.ru/public/TfKk/QGyS93cW7) | `action-unverified`. JSON은 오류 페이지와 원본 미검증을 기록. 보고서는 브라우저에서 PDF-print·PNG-digital·SVG-vector 폴더, 347KB 다운로드 표시와 버튼 클릭을 기록하지만 파일 취득은 확인하지 못함. 이전 Dropbox 링크는 비활성. | 현재 공개 폴더의 다운로드 결과를 확인하고 원본 형식을 검사. 이미 클릭한 사실과 취득 성공을 구분하며 이전 Dropbox 경로를 재사용하지 않음. |
| 3. playstation | [SIE Asset Library](https://sonyinteractive.com/en/news/asset-library/) / 같은 페이지의 Logo 필터·개별 Download·선택 ZIP 동작 | `site-asset-only`. 라이브러리 경로는 존재하나 REST `Invalid nonce` 403 및 브라우저 비활성 필터로 다운로드 미완료. 공식 footer PS 심볼 SVG 3,291B만 취득; 로그인 요구는 관찰되지 않음. | 공개 라이브러리의 필터·nonce 문제를 기술적으로 확인한 뒤 의도된 배포 원본을 검증. footer SVG를 키트로 승격하지 않으며 권리 조건은 별도 확인. |
| 4. wechat | [WeDesign 브랜드 도구](https://wechat.design/tool/brand) / [브랜드 가이드](https://wechat.design/brand/main-brand) → [로고 자료 문서](https://doc.weixin.qq.com/doc/w3_ARkAeQa6AC0CYsJWhKbQoqn2LFwnB?scode=AJEAIQdfAAoiR11wBrARkAeQa6AC0) | `format-unverified`. client-icon ZIP 6,229,635B 취득; JPG 홍보 이미지와 안내 PDF이며 독립 로고 팩이 아님. AI·PSD·PNG 제공 안내는 있으나 문서 HTML shell만 확인; 내부 원본과 로그인 필요 여부 미확인. | 문서 내부의 실제 로고 파일 연결·형식을 기술적으로 확인. 로그인 필요를 미리 단정하지 않고 홍보 이미지의 출처표시 상업 이용 문구를 로고 팩 권한에 확대하지 않음. |
| 5. pinterest | [Brand guidelines](https://business.pinterest.com/brand-guidelines/) / [Asset library](https://www.pinterest-assets.com/Package/2THWMKDBK3GQ) | `approval-route`. P badge EPS·고해상도 PNG 라이브러리와 절차 안내 확인. 자산 선택·직접 다운로드·요청 제출·파일 취득은 미실행. 다운로드 버튼이 없는 항목은 cart → 사용 목적 → Request All Items → 검토 후 승인 이메일 절차. | 먼저 선택 항목의 공개 다운로드 가능 여부 확인. 요청·외부 파트너 등록이 필요하면 사용자 행동으로 분리하고, 승인 링크가 생긴 뒤 파일 검증은 기술 작업으로 진행. |
| 6. xbox | [접근 안내](https://learn.microsoft.com/en-us/xbox/game-publishing/resources/managed-support/how-to-access-branding-and-marketing-assets) / [Xbox brand assets 포털](https://developer.microsoft.com/en-us/games/resources/xbox-brand-assets/) | `login-route`. 안내는 Partner Center 계정 요구. 포털 GET 200은 Microsoft 로그인 HTML이며 파일이 아님. 인증 미시도; 개별 심볼·워드마크·ZIP 및 포털 내부 조건 미검증. | 계정·접근 자격과 로그인은 사용자 행동으로 처리. 접근 후 원본 조회·취득·검증을 기술 작업으로 분리하며 팬사이트 조건을 일반 상업 앱 허가로 해석하지 않음. |
| 7. nintendo | [Press Center](https://press.nintendo.com/) / [로그인 진입점](https://press.nintendo.com/User/LogIn) — 내부 자산 라이브러리 URL 미확인 | `login-route`. GET 200이 로그인 화면으로 이동; 등록·이메일 활성화 필요. 등록·로그인·파일 취득 미실행; 내부 기업 로고 제공 여부도 미검증. 헤더 SVG는 사이트 표시 자산이며 인증서 체인 오류로 취득 확인 실패. | 등록·활성화·로그인은 사용자 행동으로 분리. 접근 후 실제 로고 제공 여부와 원본·조건 확인; 로그인 전 파일 존재를 확정하지 않고 TLS 검증을 우회하지 않음. |

## 대조에서 발견한 차이

- **VK:** 보고서는 브라우저 폴더·347KB 표시·버튼 클릭을 추가로 기술하지만 JSON `raw`에는 오류 페이지 기록만 있다. 두 기록 모두 실제 파일 취득 성공은 입증하지 않는다.
- **`downloadURL`의 의미:** Reddit은 사이트 표시 SVG, Xbox는 로그인 포털, WeChat은 홍보 ZIP, VK는 리디렉션 동작이다. 이 필드를 곧바로 교체용 공식 로고 파일 목록으로 사용하면 안 된다.
- **Nintendo:** 보고서에는 생략된 헤더 SVG 인증서 오류와 로그인 뒤 기업 로고 제공 여부 미검증이 JSON에 있다. 사이트 로고도 취득 완료로 기록하지 않는다.

공개 다운로드 동작의 완료·원본 검증은 여전히 후속 작업이다. 승인 요청·가입·로그인·약관 제출 같은 사용자 행동과 기술적 조회·다운로드 결과 검증은 서로 다른 단계이며, 이 문서는 어느 쪽도 대신 실행하거나 허가를 확정하지 않는다.

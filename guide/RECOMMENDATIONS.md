# 추천 플러그인 / 기능

현재 설정을 기준으로 **Go / Python / JSON / YAML / SQL** 을 자주 다루는 개발자가
추가로 도입하면 생산성이 크게 올라갈 만한 플러그인들을 우선순위 순으로 정리했습니다.

> 분류 표기
> - 우선도: ★★★ 강력 추천 / ★★ 추천 / ★ 선택
> - 카테고리는 `lua/plugins/<카테고리>/` 위치 기준 (없으면 신규 생성)
>
> 현재 이미 갖춰진 기능과 중복되는 항목은 제외했습니다.
> (예: `nvim-cmp`, `null-ls`, `lazygit` 등)

---

## 1. SQL 작업을 위한 DB 통합 ★★★

**플러그인:** `vim-dadbod` + `vim-dadbod-ui` + `vim-dadbod-completion`
**카테고리:** `lua/plugins/db/` (신규)

- nvim 안에서 PostgreSQL / MySQL / SQLite / Redis 등에 직접 접속해 쿼리 실행
- `.sql` 파일을 열고 `<CR>` 으로 커서 위치 쿼리만 실행, 결과 버퍼로 출력
- 테이블/스키마 트리뷰, 쿼리 히스토리, 즐겨찾기 쿼리 저장 지원
- `dadbod-completion` 으로 SQL LSP 없이도 테이블/컬럼명 자동완성

**왜 필요한가:** 현재 SQL 은 `sqlfluff` 포매터만 있어 "쿼리 실행" 이 안 됩니다.
DataGrip / DBeaver 를 띄우는 컨텍스트 스위칭이 사라집니다.

---

## 2. Python 디버거 (DAP) ★★★ ✅ 도입 완료

**플러그인:** `mfussenegger/nvim-dap-python`
**위치:** `lua/plugins/debug/dap.lua` (기존 nvim-dap dependencies 에 통합)

- 기존 `nvim-dap` + `nvim-dap-ui` 인프라에 Python 어댑터를 dependency 로 추가
- `debugpy` 는 `mason-tool-installer` 가 자동 설치 (extras/lang/python.lua)
- 테스트 러너로 `pytest` 사용
- 단축키: `<leader>dpt` (메서드), `<leader>dpc` (클래스), `<leader>dps` (선택 영역, Visual)

---

## 3. 테스트 러너 통합 (Neotest) ★★★

**플러그인:** `nvim-neotest/neotest` + `neotest-go` + `neotest-python`
**카테고리:** `lua/plugins/test/` (신규)

- 트리뷰로 프로젝트 내 모든 테스트 표시, 한 줄에서 실행 / 실패 표시 / 결과 출력
- 테스트 위 `<leader>tr` 로 단일 테스트만 실행, `<leader>tf` 로 파일 전체 실행
- `nvim-dap` 와 자동 연동되어 "디버깅 모드로 테스트 실행" 가능
- Go 의 `testify`, Python 의 `pytest` 모두 인식

**왜 필요한가:** 터미널에서 `go test ./...`, `pytest` 반복 입력 사이클이 없어집니다.
Coverage gutter 까지 함께 보고 싶다면 `andythigpen/nvim-coverage` 를 함께 도입.

---

## 4. Ruff (Python 린터/포매터) ★★★

**플러그인:** `ruff` LSP (Mason 으로 설치) — `astral-sh/ruff`
**카테고리:** `extras/lang/python.lua` 에 추가

- Rust 로 작성된 초고속 린터. flake8, isort, pyupgrade 등 100+ 규칙 통합
- pyright 와 함께 사용 (pyright = 타입체크, ruff = 린트/import 정렬/포맷)
- `black` 과 `isort` 를 ruff 하나로 대체 가능 → 의존성 단순화

**왜 필요한가:** 현재 Python 린터가 없고, `black + isort` 조합은 ruff 하나로
빠르게 대체할 수 있습니다 (벤치마크상 10~100배 빠름).

---

## 5. JSON / YAML 스키마 자동화 ★★★

**플러그인:** `b0o/SchemaStore.nvim`
**카테고리:** `extras/lang/ops.lua` 에 통합

- JSON/YAML 파일에 대해 `schemastore.org` 의 600+ 스키마를 자동 매칭
- `package.json`, `tsconfig.json`, `.github/workflows/*.yaml`, `docker-compose.yml` 등
  파일명 기반으로 자동 검증 + 자동완성
- 현재 `yamlls` 가 `schemaStore.enable = true` 로 활성화돼 있지만,
  jsonls 측에는 적용돼 있지 않아 SchemaStore.nvim 으로 양쪽 일원화 가능

**왜 필요한가:** GitHub Actions, Helm chart, k8s manifest 등을 작성할 때
오타 / 누락 필드를 즉시 잡아냅니다.

---

## 6. K8s/YAML 스키마 선택기 ★★

**플러그인:** `someone-stole-my-name/yaml-companion.nvim`
**카테고리:** `extras/lang/ops.lua` 에 통합

- 현재 열려 있는 YAML 파일의 적용 스키마를 lualine 에 표시
- `<leader>cs` 로 텔레스코프 UI 띄워 다른 스키마 (Argo CD / Kustomize / Helm 등) 수동 선택
- 한 디렉토리에 여러 종류 매니페스트가 섞여 있을 때 유용

---

## 7. 진단/검색 결과 통합 패널 (Trouble) ★★★

**플러그인:** `folke/trouble.nvim`
**카테고리:** `lua/plugins/editor/`

- LSP diagnostic / quickfix / location list / telescope 결과를 하나의 패널로
- `<leader>xx` 로 워크스페이스 전체 에러 확인, 점프
- TODO 코멘트 / 심볼 references 도 같은 UI 로 표시

**왜 필요한가:** 현재는 `:lua vim.diagnostic.setloclist()` 같은 명령에 의존.
대형 프로젝트에서 에러 한눈에 파악 / 일괄 수정 워크플로우가 빨라집니다.

---

## 8. 함수 컨텍스트 sticky header ★★

**플러그인:** `nvim-treesitter/nvim-treesitter-context`
**카테고리:** `lua/plugins/editor/` (treesitter.lua 옆)

- 현재 커서가 들어 있는 함수/메서드/클래스 시그니처를 화면 상단에 고정 표시
- 긴 Go 메서드, Python 클래스 안에서 "어느 함수인지" 확인하려 스크롤 올릴 필요 없음
- YAML 의 deeply nested key path 표시에도 매우 유용

---

## 9. 빠른 모션 (Flash) ★★

**플러그인:** `folke/flash.nvim`
**카테고리:** `lua/plugins/editor/`

- `s` 로 화면 내 두 글자 검색 → label 점프 (vim-sneak / leap 의 후속)
- treesitter 노드 단위 선택 (`S` → `if`, `function`, `class` 등 노드 즉시 선택)
- 검색어 입력 중 실시간 라벨 표시, 매우 빠른 jump

**왜 필요한가:** `f`/`t` + `;`/`,` 반복보다 한 번에 도달. JSON/YAML 같은 들여쓰기
파일에서 특정 키로 점프할 때 압도적입니다.

---

## 10. 코드 split / join (treesj) ★★

**플러그인:** `Wansmer/treesj`
**카테고리:** `lua/plugins/editor/`

- treesitter 기반으로 한 줄 ↔ 여러 줄 변환
  - Go: `Foo{A: 1, B: 2}` ↔ 여러 줄
  - Python: `def foo(a, b, c)` ↔ 여러 줄
  - JSON/YAML: 인라인 객체 ↔ 펼침
- `<leader>m` 단일 키로 토글

---

## 11. 심볼 아웃라인 ★★

**플러그인:** `stevearc/aerial.nvim` 또는 `hedyhli/outline.nvim`
**카테고리:** `lua/plugins/editor/`

- 사이드바에 현재 파일의 함수/메서드/struct 트리 표시
- 클릭 / `<CR>` 로 점프
- Go interface, Python class hierarchy, YAML 키 트리, JSON path 모두 지원

**왜 필요한가:** 1000 줄 넘는 파일에서 telescope `lsp_document_symbols` 보다
상시 표시되는 사이드바가 더 빠릅니다.

---

## 12. HTTP / REST 클라이언트 ★★

**플러그인:** `mistweaverco/kulala.nvim` 또는 `rest-nvim/rest.nvim`
**카테고리:** `lua/plugins/tools/` (신규)

- `.http` 파일에 요청 작성 → `<leader>rr` 로 실행 → JSON 응답을 nvim 버퍼로
- 환경변수 / 변수 치환 / 인증 헤더 템플릿 지원
- Postman / Insomnia 대체

**왜 필요한가:** Go/Python 백엔드 API 개발 시 매번 curl / Postman 으로 컨텍스트
스위칭하는 비용 제거. 응답 JSON 을 nvim 안에서 jq/treesitter 로 분석 가능.

---

## 13. 빠른 파일 북마크 (Harpoon 2) ★★

**플러그인:** `ThePrimeagen/harpoon` (branch: harpoon2)
**카테고리:** `lua/plugins/file/`

- 자주 오가는 파일 4~5 개를 핀 등록 → `<leader>1`, `<leader>2` … 로 즉시 이동
- 프로젝트별 핀 자동 저장
- telescope 보다 빠른, 관용적인 multi-file 워크플로우

**왜 필요한가:** Go/Python 작업 중 보통 "메인 + 테스트 + config + sql" 4~5개
파일을 왕복하는데, telescope 검색보다 1키 점프가 압도적.

---

## 14. 세션 관리 ★

**플러그인:** `folke/persistence.nvim` 또는 `rmagatti/auto-session`
**카테고리:** `lua/plugins/editor/`

- 디렉토리별로 열려 있던 버퍼 / 윈도우 / 탭 자동 저장 / 복원
- nvim 종료 후 다시 켰을 때 작업 상태 그대로

---

## 15. 인라인 검색/치환 (Spectre) ★

**플러그인:** `nvim-pack/nvim-spectre`
**카테고리:** `lua/plugins/search/`

- 프로젝트 전역 find & replace UI (정규식, 대소문자, 단어 경계)
- preview → 선택적으로 적용
- telescope `live_grep` + `:%s` 보다 안전한 일괄 변경

---

## 16. 도큐먼테이션 자동 생성 (Neogen) ★

**플러그인:** `danymat/neogen`
**카테고리:** `lua/plugins/editor/`

- 함수 위에서 `:Neogen` → 언어별 docstring 템플릿 자동 삽입
- Go: godoc 형식, Python: google/numpy/sphinx 스타일 선택 가능
- Lua/TypeScript/Rust 등도 지원

---

## 17. CSV 뷰어 ★

**플러그인:** `hat0uma/csvview.nvim`
**카테고리:** `lua/plugins/editor/`

- `.csv` / `.tsv` 파일을 컬럼 정렬된 표로 가상 렌더링 (파일은 변경 안 함)
- DB 쿼리 결과 export 확인용으로 좋음

---

## 18. Markdown 코드블록 LSP (otter.nvim) ★

**플러그인:** `jmbuhr/otter.nvim`
**카테고리:** `lua/plugins/editor/`

- README.md / 노트 안의 ```python, ```go, ```sql 코드블록에도 LSP / 자동완성 작동
- 기술 문서 작성 / Jupyter 스타일 노트 워크플로우에 유용

---

## 19. URL 오프너 (gx 강화) ★

**플러그인:** `chrishrb/gx.nvim`
**카테고리:** `lua/plugins/editor/`

- nvim 0.10 의 `gx` 는 URL 만 지원. 이 플러그인은 GitHub 이슈 (#123),
  go.mod 패키지명, npm 패키지, Jira 티켓 등도 브라우저에서 열어줌

---

## 20. 컬러 미리보기 (선택) ★

**플러그인:** `brenoprata10/nvim-highlight-colors` 또는 `NvChad/nvim-colorizer.lua`
**카테고리:** `lua/plugins/ui/`

- `#ff8800`, `rgb(...)`, tailwind class 등을 해당 색상으로 인라인 하이라이트
- CSS / theme 작업 시 유용 (Go/Python 위주 백엔드라면 우선도 낮음)

---

# 도입 우선순위 요약

| 순위 | 플러그인 | 효과 |
|---|---|---|
| 1 | vim-dadbod (UI/completion) | SQL 워크플로우 nvim 안으로 흡수 |
| 2 | ✅ nvim-dap-python | Python 디버깅 가능 (도입 완료) |
| 3 | neotest + adapters | Go/Python 테스트 사이클 단축 |
| 4 | ruff (LSP) | Python 린트/포맷 통합 |
| 5 | SchemaStore.nvim | JSON/YAML 자동 검증 강화 |
| 6 | trouble.nvim | 진단 / quickfix 통합 패널 |
| 7 | treesitter-context | 긴 함수 / nested YAML 가독성 |
| 8 | flash.nvim | 화면 내 점프 속도 향상 |
| 9 | aerial.nvim | 심볼 아웃라인 |
| 10 | harpoon2 | 자주 쓰는 파일 1키 점프 |

---

# 다음 단계 제안

위 목록 중 도입할 플러그인을 알려주시면, 프로젝트 규칙
(`CLAUDE.PLUGINS.md`, `CLAUDE.STRUCT.md`, 파일명 규칙, keymaps 분리,
guide cheatsheet 작성)을 따라 **한 번에 하나씩** 추가 작업을 진행하겠습니다.

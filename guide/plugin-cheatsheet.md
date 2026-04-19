# 플러그인 치트시트

플러그인별 사용법과 단축키를 정리한 문서.
`<leader>kg` 로 키워드 검색 가능.

`<leader>` = `Space`

---

## 목차

- [editor] autopairs — 괄호 자동완성
- [editor] Comment.nvim — 주석 토글
- [editor] indent-blankline — 들여쓰기 가이드
- [editor] todo-comments — TODO 하이라이팅
- [editor] vim-table-mode — Markdown 테이블 정렬
- [editor] render-markdown — Markdown 렌더링
- [editor] treesitter — 문법 하이라이팅
- [editor] nvim-ufo — 코드 폴딩
- [editor] vim-visual-multi — 멀티커서
- [search] telescope — 퍼지 검색
- [file] neo-tree — 파일 탐색기
- [git] gitsigns — Git 변경 표시
- [git] neogit — Git TUI
- [git] diffview — Diff 뷰어
- [lsp] lspconfig — LSP 연결
- [lsp] mason — LSP/도구 설치
- [lsp] blink.cmp — 자동완성
- [lsp] conform — 포매터
- [lsp] nvim-lint — 린터
- [debug] nvim-dap — 디버깅
- [lang:go] gomodifytags — Go struct 태그 자동 편집
- [ui] bufferline — 버퍼 탭
- [ui] lualine — 상태바
- [ui] which-key — 단축키 힌트
- [ui] toggleterm — 터미널
- [ui] colorscheme — 테마
- [input] im-select — 입력기 자동전환
- [ai] claudecode — Claude Code 통합

---

## [editor] windwp/nvim-autopairs

키워드: 괄호 따옴표 자동닫기 자동완성 bracket quote auto close pair

괄호, 따옴표를 입력하면 닫는 쌍을 자동으로 추가한다.
treesitter 연동으로 문자열/주석 내부에서는 자동완성을 비활성화한다.

| 동작         | 결과                                       |
|--------------|--------------------------------------------|
| `(` 입력     | `[괄호]` `()` — 커서가 가운데 위치           |
| `"` 입력     | `[따옴표]` `""`                              |
| `{` 입력     | `[괄호]` `{}`                                |
| `)` 입력     | `[괄호]` 이미 `)` 가 있으면 커서만 이동      |
| `(` + `<CR>` | `[괄호]` 자동 들여쓰기와 함께 괄호 펼쳐짐    |

별도 단축키 없음. Insert 모드에서 자동 동작.

---

## [editor] numToStr/Comment.nvim

키워드: 주석 코멘트 토글 comment toggle gcc 줄주석 블록주석

단축키 하나로 코드 주석을 토글한다. 언어별 주석 문법을 자동 감지한다.

| 단축키      | 모드   | 설명                                    |
|-------------|--------|-----------------------------------------|
| `<leader>/` | Normal | `[주석]` 현재 줄 주석 토글 (빠른 토글)    |
| `<leader>/` | Visual | `[주석]` 선택 영역 주석 토글 (빠른 토글)  |
| `gcc`       | Normal | `[주석]` 현재 줄 주석 토글                |
| `gbc`       | Normal | `[주석]` 현재 줄 블록 주석 토글           |
| `gc3j`      | Normal | `[주석]` 현재 줄 포함 아래 3줄 주석 토글  |
| `gcip`      | Normal | `[주석]` 현재 단락 주석 토글              |
| `gc`        | Visual | `[주석]` 선택 영역 줄 주석 토글           |
| `gb`        | Visual | `[주석]` 선택 영역 블록 주석 토글         |

---

## [editor] lukas-reineke/indent-blankline.nvim

키워드: 들여쓰기 인덴트 가이드라인 수직선 indent guide scope

들여쓰기 레벨을 수직선(`│`)으로 시각화한다.
커서가 위치한 현재 스코프를 다른 색상으로 강조 표시한다.

별도 단축키 없음. 파일을 열면 자동 표시.

---

## [editor] folke/todo-comments.nvim

키워드: TODO FIXME NOTE HACK WARN PERF TEST 할일 버그 주의

코드 내 특수 키워드를 색상으로 하이라이팅하고 telescope로 검색한다.

**지원 키워드**

| 키워드             | 색상   | 설명           |
|--------------------|--------|----------------|
| `TODO`             | 노란색 | 나중에 할 일   |
| `FIXME` / `FIX`    | 빨간색 | 버그 수정 필요 |
| `NOTE` / `INFO`    | 파란색 | 참고 사항      |
| `HACK`             | 주황색 | 임시 방편 코드 |
| `WARN` / `WARNING` | 주황색 | 주의 필요      |
| `PERF`             | 보라색 | 성능 개선 필요 |
| `TEST`             | 초록색 | 테스트 관련    |

| 단축키 / 명령어                      | 설명                            |
|--------------------------------------|---------------------------------|
| `]t`                                 | `[TODO]` 다음 TODO로 이동        |
| `[t`                                 | `[TODO]` 이전 TODO로 이동        |
| `<leader>ft`                         | `[TODO]` 프로젝트 전체 TODO 검색 |
| `:TodoTelescope keywords=TODO,FIXME` | `[TODO]` 특정 키워드만 필터링    |
| `:TodoQuickFix`                      | `[TODO]` quickfix 목록으로 표시  |

---

## [editor] dhruvasagar/vim-table-mode

키워드: 마크다운 테이블 정렬 표 table markdown align realign

Markdown 테이블 정렬 플러그인. 수동 호출 방식.

| 단축키 / 명령어         | 설명                                            |
|-------------------------|-------------------------------------------------|
| `<leader>mf`            | `[마크다운]` 현재 markdown 파일의 모든 테이블 재정렬 |
| `:MarkdownTableRealign` | `[마크다운]` 현재 markdown 파일의 모든 테이블 재정렬 |

> 저장 시 자동 정렬은 비활성화. `<leader>mf` 로 명시적 호출.

---

## [editor] MeanderingProgrammer/render-markdown.nvim

키워드: 마크다운 렌더링 미리보기 markdown render preview 체크박스 헤더

Neovim 버퍼 내에서 Markdown을 직접 렌더링한다.
헤더, 코드블록, 체크박스, 테이블, 인용구를 아이콘과 색상으로 표현.

| 단축키       | 설명                         |
|--------------|------------------------------|
| `<leader>mr` | `[마크다운]` Markdown 렌더링 토글 |

.md 파일을 열면 자동 렌더링. `<leader>mr` 로 비활성화/활성화 전환.

---

## [editor] nvim-treesitter/nvim-treesitter

키워드: 문법 하이라이팅 구문강조 파서 syntax highlight parser AST

AST 기반으로 정확한 문법 하이라이팅, 코드 폴딩, 들여쓰기를 제공한다.

**자동 설치 파서**: lua, vim, vimdoc, query, markdown, markdown_inline,
go, gomod, gosum, gowork, python, yaml, json, bash, dockerfile, sql, make

| 명령어                         | 설명                                  |
|--------------------------------|---------------------------------------|
| `:TSInstall <언어>`            | `[파서]` 특정 언어 파서 수동 설치       |
| `:TSUpdate`                    | `[파서]` 설치된 파서 전체 업데이트      |
| `:checkhealth nvim-treesitter` | `[파서]` 파서 설치 상태 확인            |
| `:InspectTree`                 | `[구문분석]` 현재 버퍼의 AST 구조 확인 |
| `:Inspect`                     | `[구문분석]` 커서 위치 highlight 그룹   |

---

## [editor] kevinhwang91/nvim-ufo

키워드: 폴딩 접기 펼치기 fold unfold collapse expand peek

LSP + treesitter 기반 코드 폴딩. 접힌 줄 수와 미리보기를 제공한다.

| 단축키       | 설명                            |
|--------------|---------------------------------|
| `za`         | `[폴딩]` 현재 fold 토글           |
| `zo`         | `[폴딩]` 현재 fold 열기           |
| `zc`         | `[폴딩]` 현재 fold 닫기           |
| `zR`         | `[폴딩]` 파일 내 모든 fold 열기   |
| `zM`         | `[폴딩]` 파일 내 모든 fold 닫기   |
| `zr`         | `[폴딩]` fold 레벨 한 단계 열기   |
| `zm`         | `[폴딩]` fold 레벨 한 단계 닫기   |
| `<leader>zp` | `[폴딩]` 접힌 블록 내용 미리보기  |

---

## [editor] mg979/vim-visual-multi

키워드: 멀티커서 다중커서 동시편집 multi cursor multiple select 변수 일괄변경

VSCode 스타일의 멀티커서 편집 플러그인.
여러 위치에 동시에 커서를 배치하고 동시 편집이 가능하다.

| 단축키     | 설명                                             |
|------------|--------------------------------------------------|
| `<C-n>`    | `[멀티커서]` 현재 단어 선택 / 다음 매칭 추가 선택  |
| `<C-Down>` | `[멀티커서]` 아래로 커서 추가                      |
| `<C-Up>`   | `[멀티커서]` 위로 커서 추가                        |
| `\\A`      | `[멀티커서]` 현재 단어의 모든 매칭에 커서 생성     |
| `\\/`      | `[멀티커서]` 정규식 검색 후 커서 배치              |
| `\\gS`     | `[멀티커서]` 정규식 매칭 위치에 커서 생성          |
| `<Tab>`    | `[멀티커서]` 커서 모드 ↔ 확장 모드 전환            |
| `q`        | `[멀티커서]` 현재 매칭 건너뛰기                    |
| `Q`        | `[멀티커서]` 현재 커서 제거                        |
| `n` / `N`  | `[멀티커서]` 다음 / 이전 매칭으로 이동             |
| `<Esc>`    | `[멀티커서]` 멀티커서 모드 종료                    |

**사용 예시: 변수명 일괄 변경**
1. 변경할 단어 위에 커서를 놓고 `<C-n>`
2. `<C-n>` 반복으로 변경할 위치를 추가 선택 (건너뛰려면 `q`)
3. `c` 로 변경 모드 진입 → 새 텍스트 입력 → `<Esc>`

**사용 예시: 여러 줄의 임의 위치에 커서 배치**
1. 원하는 위치에서 `<C-Down>` / `<C-Up>` 으로 커서 추가
2. `i` 또는 `a` 로 Insert 모드 진입 → 동시 편집

---

## [search] nvim-telescope/telescope.nvim

키워드: 검색 찾기 파일찾기 텍스트검색 grep fuzzy find search 퍼지

파일, 코드, Git 이력, LSP 심볼 등 모든 것을 퍼지 검색으로 찾는다.

**사전 요구사항**: `brew install fd ripgrep`

| 단축키       | 설명                                   |
|--------------|----------------------------------------|
| `<leader>ff` | `[검색]` 파일 찾기                       |
| `<leader>fg` | `[검색]` 텍스트 실시간 검색 (live grep)  |
| `<leader>fw` | `[검색]` 커서 위치 단어 검색             |
| `<leader>fb` | `[검색]` 열린 버퍼 목록                  |
| `<leader>fr` | `[검색]` 최근 파일 목록                  |
| `<leader>fh` | `[검색]` 도움말 검색                     |
| `<leader>ft` | `[검색]` 프로젝트 전체 TODO 검색         |
| `<leader>tc` | `[검색]` 테마 선택 (실시간 미리보기)     |
| `<leader>ks` | `[검색]` 등록된 단축키 검색              |

**telescope 창 내부 단축키**

| 단축키            | 설명                                  |
|-------------------|---------------------------------------|
| `<C-n>` / `<C-p>` | `[검색]` 다음 / 이전 결과로 이동       |
| `<C-x>`           | `[검색]` 수평 분할로 파일 열기         |
| `<C-v>`           | `[검색]` 수직 분할로 파일 열기         |
| `<C-t>`           | `[검색]` 새 탭으로 파일 열기           |
| `<C-u>` / `<C-d>` | `[검색]` 미리보기 창 스크롤            |
| `<C-q>`           | `[검색]` 결과를 quickfix 목록으로 전송 |
| `<Tab>`           | `[검색]` 다중 선택 토글                |
| `<Esc>`           | `[검색]` telescope 닫기                |

---

## [file] nvim-neo-tree/neo-tree.nvim

키워드: 파일탐색기 사이드바 디렉토리 트리 파일생성 삭제 이동 복사 file explorer tree sidebar

프로젝트 디렉토리 구조를 트리 형태로 사이드바에 표시한다.

| 단축키       | 설명                                     |
|--------------|------------------------------------------|
| `<leader>ee` | `[파일탐색]` 파일 탐색기 열기 / 닫기       |
| `<leader>E`  | `[파일탐색]` 파일 탐색기 포커스            |
| `<leader>er` | `[파일탐색]` 현재 파일 위치를 탐색기에서 표시 |
| `<leader>eb` | `[파일탐색]` 열린 버퍼 목록 탐색기         |
| `<leader>ge` | `[파일탐색]` Git 상태 탐색기 토글          |

**neo-tree 창 내부 단축키**

| 단축키       | 설명                                      |
|--------------|-------------------------------------------|
| `<CR>` / `o` | `[파일탐색]` 파일 열기 / 디렉토리 펼치기    |
| `l`          | `[파일탐색]` 파일 열기 / 디렉토리 펼치기 (vim) |
| `h`          | `[파일탐색]` 디렉토리 접기 (vim)            |
| `S`          | `[파일탐색]` 수직 분할로 파일 열기          |
| `s`          | `[파일탐색]` 수평 분할로 파일 열기          |
| `t`          | `[파일탐색]` 새 탭으로 파일 열기            |
| `P`          | `[파일탐색]` 파일 미리보기 (팝업)           |
| `a`          | `[파일탐색]` 파일 / 디렉토리 생성           |
| `d`          | `[파일탐색]` 파일 / 디렉토리 삭제           |
| `r`          | `[파일탐색]` 이름 변경                      |
| `y`          | `[파일탐색]` 파일 경로 복사                 |
| `c`          | `[파일탐색]` 파일 복사                      |
| `m`          | `[파일탐색]` 파일 이동                      |
| `q`          | `[파일탐색]` 탐색기 닫기                    |
| `R`          | `[파일탐색]` 디렉토리 새로고침              |
| `H`          | `[파일탐색]` 숨김 파일 표시 / 숨김 토글     |
| `/`          | `[파일탐색]` 파일명 검색 (필터)             |
| `<BS>`       | `[파일탐색]` 상위 디렉토리로 이동           |
| `E`          | `[파일탐색]` 모든 디렉토리 펼치기           |
| `C`          | `[파일탐색]` 모든 디렉토리 접기             |
| `<` / `>`    | `[파일탐색]` 이전 / 다음 source 전환        |

---

## [git] lewis6991/gitsigns.nvim

키워드: git 변경 추가 수정 삭제 hunk blame gutter 라인표시

에디터 좌측 gutter에 변경된 라인을 표시하고, hunk 단위로 조작한다.

| 단축키       | 설명                           |
|--------------|--------------------------------|
| `]h`         | `[Git변경]` 다음 hunk로 이동    |
| `[h`         | `[Git변경]` 이전 hunk로 이동    |
| `<leader>gp` | `[Git변경]` hunk 변경사항 미리보기 |
| `<leader>gb` | `[Git변경]` 현재 줄 git blame 토글 |

---

## [git] NeogitOrg/neogit

키워드: git commit push pull stage unstage 커밋 푸시 풀 스테이지

neovim 안에서 git add, commit, push, pull 등 전체 워크플로우를 처리한다.

| 단축키       | 설명                |
|--------------|---------------------|
| `<leader>gs` | `[Git관리]` neogit 열기 |

**neogit 창 내부 단축키**

| 단축키 | 설명                             |
|--------|----------------------------------|
| `s`    | `[Git관리]` 파일 stage             |
| `u`    | `[Git관리]` 파일 unstage           |
| `cc`   | `[Git관리]` 커밋 메시지 작성 후 커밋 |
| `Pp`   | `[Git관리]` push                   |
| `Fl`   | `[Git관리]` pull                   |
| `d`    | `[Git관리]` diffview로 변경사항 보기 |

---

## [git] sindrets/diffview.nvim

키워드: diff 비교 변경사항 머지 충돌 merge conflict 좌우분할

파일 변경사항을 좌우 분할 화면으로 비교한다.

| 단축키       | 설명                      |
|--------------|---------------------------|
| `<leader>gd` | `[Diff비교]` diffview 열기  |
| `<leader>gD` | `[Diff비교]` diffview 닫기  |

| 명령어                 | 설명                           |
|------------------------|--------------------------------|
| `:DiffviewOpen`        | `[Diff비교]` 현재 변경사항 diff  |
| `:DiffviewFileHistory` | `[Diff비교]` 파일 커밋 히스토리  |

---

## [lsp] neovim/nvim-lspconfig

키워드: lsp 정의 선언 구현 참조 hover rename 코드액션 진단 자동수정

LSP 서버와 neovim을 연결한다. 코드 진단, 정의 이동, 참조 찾기 등 IDE 기능의 핵심.

| 단축키       | 설명                                          |
|--------------|-----------------------------------------------|
| `gd`         | `[LSP이동]` 정의로 이동                         |
| `gD`         | `[LSP이동]` 선언으로 이동                       |
| `gi`         | `[LSP이동]` 구현으로 이동                       |
| `gr`         | `[LSP이동]` 참조 찾기 (telescope)               |
| `K`          | `[LSP문서]` hover 문서 표시                     |
| `<leader>lk` | `[LSP문서]` 함수 시그니처 표시                  |
| `<leader>lr` | `[LSP편집]` 이름 변경 (rename)                  |
| `<leader>la` | `[LSP편집]` 코드 액션 (자동 수정, import 추가)  |
| `<leader>ld` | `[LSP진단]` 진단 상세 메시지 팝업               |
| `<leader>lf` | `[LSP포맷]` 포맷 실행 (conform → LSP fallback)  |
| `]d`         | `[LSP진단]` 다음 진단으로 이동                  |
| `[d`         | `[LSP진단]` 이전 진단으로 이동                  |

| 명령어        | 설명                            |
|---------------|---------------------------------|
| `:LspInfo`    | `[LSP관리]` 서버 연결 상태 확인   |
| `:LspRestart` | `[LSP관리]` 서버 재시작           |
| `:LspLog`     | `[LSP관리]` 로그 확인             |

---

## [lsp] williamboman/mason.nvim

키워드: mason 설치 lsp서버 포매터 린터 패키지관리 install

LSP 서버, 포매터, 린터를 neovim 안에서 설치/관리한다.

| 명령어                     | 설명                                |
|----------------------------|-------------------------------------|
| `:Mason`                   | `[도구설치]` GUI로 설치 목록 관리     |
| `:MasonInstall <패키지>`   | `[도구설치]` 패키지 설치              |
| `:MasonUninstall <패키지>` | `[도구설치]` 패키지 삭제              |
| `:MasonUpdate`             | `[도구설치]` 설치된 패키지 전체 업데이트 |
| `:MasonToolsInstall`       | `[도구설치]` 도구 목록 즉시 설치      |
| `:MasonToolsUpdate`        | `[도구설치]` 설치된 도구 업데이트     |

---

## [lsp] saghen/blink.cmp

키워드: 자동완성 자동추천 완성 코드완성 스니펫 snippet autocomplete completion

LSP, 스니펫, 버퍼, 경로를 통합하는 Rust 기반 고성능 자동완성 엔진.
함수 자동완성 시 괄호가 자동 추가된다 (`auto_brackets`).

**자동완성 소스 우선순위**: LSP → Snip → Path → Buf

| 단축키    | 설명                                             |
|-----------|--------------------------------------------------|
| `<C-n>`   | `[자동완성]` 다음 항목 선택                        |
| `<C-p>`   | `[자동완성]` 이전 항목 선택                        |
| `<C-y>`   | `[자동완성]` 현재 항목 바로 확정                   |
| `<C-e>`   | `[자동완성]` 자동완성 창 닫기                      |
| `<CR>`    | `[자동완성]` 선택 항목 확정 (명시적 선택만)        |
| `<Tab>`   | `[자동완성]` 다음 항목 선택 / 스니펫 다음 위치     |
| `<S-Tab>` | `[자동완성]` 이전 항목 선택 / 스니펫 이전 위치     |

---

## [lsp] stevearc/conform.nvim

키워드: 포매터 포맷 자동정렬 코드정리 format formatter gofumpt black prettier

파일 저장 시 자동으로 포매터를 실행한다.

**적용 포매터**

| 언어   | 포매터              |
|--------|---------------------|
| Go     | gofumpt → goimports |
| Python | black → isort       |
| Lua    | stylua              |
| YAML   | prettier            |
| JSON   | prettier            |
| Bash   | shfmt               |
| SQL    | sqlfluff            |

| 명령어 / 단축키 | 설명                                     |
|-----------------|------------------------------------------|
| `<leader>lf`   | `[포맷]` 현재 파일 수동 포맷               |
| `:ConformInfo`  | `[포맷]` 현재 버퍼에 적용되는 포매터 확인  |

---

## [lsp] mfussenegger/nvim-lint

키워드: 린터 린트 정적분석 shellcheck hadolint lint linter

LSP가 지원하지 않는 외부 린터를 통합 관리한다.

**적용 린터**

| 언어         | 린터       |
|--------------|------------|
| Bash / Shell | shellcheck |
| Dockerfile   | hadolint   |

파일 열기, 저장, Insert → Normal 전환 시 자동 실행.
진단 결과는 `]d` / `[d` / `<leader>ld` 로 확인.

---

## [debug] mfussenegger/nvim-dap + nvim-dap-ui + nvim-dap-go

키워드: 디버깅 디버거 브레이크포인트 중단점 step 변수확인 Go delve debug breakpoint

DAP 기반 Go 디버깅 환경. 디버깅 시작 시 UI 자동 열림, 종료 시 자동 닫힘.
`.env` 파일이 있으면 환경변수를 자동 로드한다.

**사전 요구사항**: `brew install delve`

| 단축키       | 설명                                                    |
|--------------|---------------------------------------------------------|
| `<F5>`       | `[디버깅]` 디버깅 시작 / 계속 실행                       |
| `<F6>`       | `[디버깅]` 디버깅 종료                                   |
| `<F7>`       | `[디버깅]` DAP UI 패널 토글                              |
| `<F8>`       | `[디버깅]` 조건부 브레이크포인트 설정 (조건식 입력)      |
| `<F9>`       | `[디버깅]` 브레이크포인트 토글                           |
| `<F10>`      | `[디버깅]` Step Over (다음 줄, 함수 진입 안 함)          |
| `<F11>`      | `[디버깅]` Step Into (함수 내부로 진입)                  |
| `<F12>`      | `[디버깅]` Step Out (현재 함수에서 빠져나오기)           |
| `<leader>dt` | `[디버깅]` 커서 위치의 Go 테스트 함수 디버깅             |
| `<leader>dT` | `[디버깅]` 빌드 태그 입력 후 Go 테스트 디버깅            |

**DAP UI 패널**

| 패널        | 설명                       |
|-------------|----------------------------|
| scopes      | 현재 스코프의 변수 목록    |
| watches     | 감시할 표현식 추가         |
| stacks      | 콜스택 (함수 호출 경로)    |
| breakpoints | 설정된 브레이크포인트 목록 |
| repl        | 디버거 REPL (표현식 평가)  |
| console     | 디버거 출력 콘솔           |

---

## [lang:go] gomodifytags

키워드: Go struct 태그 tag json yaml gomodifytags 구조체 필드

Go struct 필드에 `json`, `yaml` 등의 태그를 자동 생성/제거하는 CLI 도구.
`extras/lang/go.lua` 에서 래퍼 함수로 감싸 neovim 사용자 명령으로 노출한다.
커서 위치의 struct 블록을 기준으로 동작하며 `-transform snakecase` 옵션으로
필드명 `FooBar` → `foo_bar` 형태로 변환한다.

**사전 요구사항**: `mason-tool-installer` 가 nvim 시작 시 자동 설치 (`:MasonInstall gomodifytags` 로 수동 설치도 가능).

**동작 방식**
- 커서를 struct 블록 내부(또는 `type Foo struct {` 줄)에 두고 명령 실행
- 파일이 수정된 상태라면 자동 저장 후 `gomodifytags -w` 로 디스크 갱신
- 변경된 내용을 현재 버퍼에 다시 읽어들임

| 명령               | 예시                      | 설명                              |
|--------------------|---------------------------|-----------------------------------|
| `:GoAddTag`        | `:GoAddTag json`          | `[태그]` json 태그 추가 (기본값)    |
| `:GoAddTag`        | `:GoAddTag yaml`          | `[태그]` yaml 태그 추가             |
| `:GoAddTag`        | `:GoAddTag json,yaml`     | `[태그]` json 과 yaml 동시 추가     |
| `:GoRmTag`         | `:GoRmTag yaml`           | `[태그]` 지정한 태그만 제거         |
| `:GoClearTag`      | `:GoClearTag`             | `[태그]` struct 의 모든 태그 제거   |

**사용 예시**

```go
// 커서를 struct 내부에 두고 :GoAddTag json,yaml 실행
type User struct {
    UserID   int
    UserName string
}

// 결과
type User struct {
    UserID   int    `json:"user_id" yaml:"user_id"`
    UserName string `json:"user_name" yaml:"user_name"`
}
```

---

## [ui] akinsho/bufferline.nvim

키워드: 버퍼 탭 이동 닫기 전환 buffer tab pick close

열린 버퍼를 상단 탭 형태로 표시한다. LSP 진단 아이콘이 탭에 함께 표시된다.

| 단축키       | 설명                                   |
|--------------|----------------------------------------|
| `<S-h>`      | `[버퍼]` 이전 버퍼로 이동               |
| `<S-l>`      | `[버퍼]` 다음 버퍼로 이동               |
| `<leader>w`  | `[버퍼]` 현재 버퍼 닫기                 |
| `<leader>bp` | `[버퍼]` 알파벳 키로 버퍼 선택해서 이동 |
| `<leader>bc` | `[버퍼]` 알파벳 키로 버퍼 선택해서 닫기 |

---

## [ui] nvim-lualine/lualine.nvim

키워드: 상태바 하단바 statusbar statusline 모드 브랜치 파일명

하단 상태바 플러그인. 창이 여러 개여도 상태바는 하단에 하나만 표시.
창 분할 시 각 창 상단에 파일명을 자동 표시 (winbar).

**상태바 구성**

```
[모드] [git 브랜치 + diff] [파일명] [LSP 진단]    [파일타입] [진행률%] [줄:열]
```

별도 단축키 없음. 자동 표시.

---

## [ui] folke/which-key.nvim

키워드: 단축키 힌트 팝업 키맵 도움말 which key hint

leader 키 입력 후 500ms 대기하면 사용 가능한 단축키 목록을 팝업으로 표시한다.

**단축키 그룹**

| Prefix      | 그룹        |
|-------------|-------------|
| `<leader>a` | AI (Claude) |
| `<leader>b` | 버퍼        |
| `<leader>c` | Quickfix    |
| `<leader>d` | 디버깅      |
| `<leader>e` | 파일 탐색기 |
| `<leader>f` | 찾기        |
| `<leader>g` | Git         |
| `<leader>k` | 키맵/도움말 |
| `<leader>l` | LSP         |
| `<leader>m` | Markdown    |
| `<leader>t` | 터미널      |
| `<leader>u` | 대소문자    |
| `<leader>z` | 폴딩        |

| 단축키 / 명령어       | 설명                        |
|------------------------|-----------------------------|
| `<Space>` (500ms 대기) | `[단축키힌트]` 팝업 표시      |
| `:WhichKey`            | `[단축키힌트]` 전체 키맵 목록 |
| `<leader>ks`           | `[단축키힌트]` 전체 키맵 검색 |

---

## [ui] akinsho/toggleterm.nvim

키워드: 터미널 terminal float 플로팅 수평 수직 toggle

단축키로 터미널을 열고 닫는다. float / horizontal / vertical 레이아웃 지원.

| 단축키       | 설명                      |
|--------------|---------------------------|
| `<C-\>`      | `[터미널]` 터미널 토글      |
| `<leader>tf` | `[터미널]` float 터미널 토글 |
| `<leader>t1` | `[터미널]` 1번 터미널 토글  |
| `<leader>t2` | `[터미널]` 2번 터미널 토글  |
| `<leader>t3` | `[터미널]` 3번 터미널 토글  |

**터미널 내부**

| 단축키       | 설명                            |
|--------------|---------------------------------|
| `<Esc><Esc>` | `[터미널]` 노멀 모드로 전환       |
| `i`          | `[터미널]` 터미널 모드로 재진입   |

---

## [ui] colorscheme (테마)

키워드: 테마 색상 컬러 다크 라이트 theme color dark light github kanagawa nightfox

3개 테마 플러그인. `<leader>tc` 로 실시간 미리보기하며 전환 가능.

**기본 테마**: github_dark_high_contrast

| 명령어 / 단축키                          | 설명                              |
|------------------------------------------|-----------------------------------|
| `<leader>tc`                             | `[테마]` 테마 선택 (미리보기)       |
| `:colorscheme github_dark_high_contrast` | `[테마]` github 고대비 다크 (기본)  |
| `:colorscheme kanagawa-wave`             | `[테마]` kanagawa wave (다크)       |
| `:colorscheme nightfox`                  | `[테마]` nightfox (다크)            |
| `:colorscheme carbonfox`                 | `[테마]` carbonfox (가장 어두운)    |
| `:colorscheme dayfox`                    | `[테마]` dayfox (라이트)            |

---

## [input] keaising/im-select.nvim

키워드: 입력기 한영전환 한국어 영어 input method 자동전환 im-select

모드 전환 시 입력기를 자동으로 영어로 전환한다.

- Insert 모드 탈출 → 영어 입력기로 자동 전환
- Insert 모드 진입 → 이전 입력기 상태로 자동 복원
- 외부 앱에서 복귀 시 → 영어 입력기로 자동 전환

**사전 요구사항**: `brew install im-select`

별도 단축키 없음. 자동 동작.

---

## [ai] coder/claudecode.nvim

키워드: claude ai 인공지능 코드생성 코드리뷰 diff 제안 전송

Claude Code CLI와 Neovim을 연결하는 공식 IDE 통합 플러그인.
WebSocket 기반 MCP로 파일과 선택 영역을 Claude가 실시간으로 인식한다.

**사전 요구사항**: `npm install -g @anthropic-ai/claude-code`

| 단축키       | 모드   | 설명                                    |
|--------------|--------|-----------------------------------------|
| `<leader>ac` | Normal | `[AI]` Claude 터미널 토글                 |
| `<leader>af` | Normal | `[AI]` Claude 터미널 포커스               |
| `<leader>as` | Visual | `[AI]` 선택 영역 Claude에 전송            |
| `<leader>aa` | Normal | `[AI]` 현재 파일 Claude 컨텍스트 추가     |
| `<leader>ay` | Normal | `[AI]` Claude 제안 변경사항 수락 (Yes)    |
| `<leader>an` | Normal | `[AI]` Claude 제안 변경사항 거절 (No)     |

| 명령어                       | 설명                             |
|------------------------------|----------------------------------|
| `:ClaudeCode`                | `[AI]` Claude 터미널 토글          |
| `:ClaudeCodeSend`            | `[AI]` 선택 영역 전송              |
| `:ClaudeCodeAdd <파일경로>`  | `[AI]` 파일 컨텍스트 추가          |
| `:ClaudeCodeDiffAccept`      | `[AI]` 제안 변경사항 수락          |
| `:ClaudeCodeDiffDeny`        | `[AI]` 제안 변경사항 거절          |
| `:ClaudeCodeCloseAllDiffTabs`| `[AI]` 모든 diff 창 닫기           |

---

## [manager] folke/lazy.nvim

키워드: 플러그인 매니저 설치 업데이트 삭제 동기화 lazy plugin manager

플러그인 설치 / 업데이트 / 삭제를 관리한다.

| 명령어          | 설명                                        |
|-----------------|---------------------------------------------|
| `:Lazy`         | `[플러그인관리]` 플러그인 관리 GUI 열기       |
| `:Lazy install` | `[플러그인관리]` 미설치 플러그인 설치         |
| `:Lazy update`  | `[플러그인관리]` 플러그인 업데이트            |
| `:Lazy sync`    | `[플러그인관리]` 설치 + 업데이트 + 정리       |
| `:Lazy clean`   | `[플러그인관리]` 미사용 플러그인 제거         |
| `:Lazy profile` | `[플러그인관리]` 플러그인 로딩 시간 프로파일링 |
| `:Lazy health`  | `[플러그인관리]` 플러그인 상태 확인           |

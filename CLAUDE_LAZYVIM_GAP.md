# LazyVim Gap Analysis

현재 neovim 설정과 LazyVim의 기능 차이를 정리한 문서.

---

## 현재 설정 현황

### 잘 갖춰진 영역

| 카테고리 | 플러그인 |
|---|---|
| 플러그인 매니저 | `lazy.nvim` |
| LSP | `mason` + `mason-lspconfig` + `nvim-lspconfig` |
| 자동완성 | `blink.cmp` (Rust 기반 고성능) + `LuaSnip` + `friendly-snippets` |
| 포맷/린터 | `conform.nvim` + `nvim-lint` |
| 문법 하이라이팅 | `nvim-treesitter` |
| 검색 | `telescope.nvim` + `telescope-fzf-native` |
| 파일 탐색기 | `neo-tree.nvim` |
| Git | `gitsigns` + `neogit` + `diffview` + `lazygit` |
| 편집 보조 | `nvim-autopairs` + `Comment.nvim` + `indent-blankline` + `todo-comments` + `nvim-ufo` + `render-markdown.nvim` + `vim-table-mode` |
| UI | `lualine` + `bufferline` + `which-key` + `toggleterm` + `github-nvim-theme` |
| 디버깅 | `nvim-dap` + `nvim-dap-ui` + `nvim-dap-go` |
| AI | `claudecode.nvim` |
| 언어 extras | `extras/lang/go.lua` + `extras/lang/python.lua` + `extras/lang/ops.lua` |

### 디렉토리 구조 (현재)

```
lua/plugins/
├── ai/claudecode.lua
├── debug/dap.lua
├── editor/          (autopairs, comment, indent, markdown-table, render-markdown, todo-comments, treesitter, ufo)
├── file/neo-tree.lua
├── git/neogit.lua
├── input/im-select.lua
├── lsp/             (cmp, conform, lint, lspconfig, mason)
├── search/telescope.lua
└── ui/              (bufferline, colorscheme, lualine, toggleterm, which-key)

lua/extras/lang/
├── go.lua           (gopls, gofumpt, goimports)
├── python.lua       (pyright, black, isort)
└── ops.lua          (YAML/JSON/Bash/Dockerfile/SQL)
```

---

## LazyVim 대비 부족한 부분

### 1. UI 향상

#### `noice.nvim` — cmdline/메시지 UI 개선

neovim의 기본 UI(cmdline, 메시지, popupmenu)를 완전히 교체하는 플러그인.

**현재 문제:**
- `:w`, `:q` 같은 명령어 입력 시 화면 하단에 작은 줄이 생겼다 사라지는 투박한 UI
- LSP 로딩 메시지, 포맷 완료 알림 등이 하단 상태줄에 잠깐 표시되다 사라져 놓치기 쉬움
- `vim.lsp.buf.rename()` 등의 입력창이 하단에 작게 표시됨

**noice.nvim 적용 시:**
- cmdline이 화면 중앙 상단에 팝업으로 표시됨
- LSP/시스템 알림이 우측 상단에 toast 형태로 표시됨
- 검색(`/`, `?`) 입력창도 팝업 형태로 표시됨
- 메시지 히스토리를 `:Noice` 명령으로 언제든 다시 확인 가능

---

#### `nvim-notify` — 알림 시스템

neovim의 `vim.notify()` 출력을 시각적인 알림창으로 교체하는 플러그인.

**현재 문제:**
- LSP 서버 시작, 포맷 완료, 에러 메시지 등이 하단 상태줄에 순간적으로 표시되어 놓치기 쉬움
- 여러 알림이 동시에 발생하면 마지막 것만 표시됨

**nvim-notify 적용 시:**
- 알림이 우측 상단에 슬라이드인 팝업으로 표시됨
- 레벨별(ERROR/WARN/INFO) 색상 구분
- 여러 알림이 동시에 발생해도 쌓여서 모두 표시됨
- `noice.nvim`이 내부적으로 이 플러그인을 알림 백엔드로 사용함

---

#### `dressing.nvim` — vim.ui.select / vim.ui.input 개선

LSP 기능(rename, code action 등)이 내부적으로 호출하는 `vim.ui.select()`와 `vim.ui.input()`의 UI를 개선하는 플러그인.

**현재 문제:**
- `<leader>lr` (rename) 실행 시 하단에 작은 입력창이 생김
- `<leader>la` (code action) 실행 시 기본 선택 목록이 cmdline 영역에 표시됨

**dressing.nvim 적용 시:**
- rename 입력창이 중앙 팝업 형태로 표시됨
- code action 목록이 telescope 또는 nui 기반의 세련된 선택창으로 표시됨
- 어떤 플러그인이든 `vim.ui.select()`를 호출하면 자동으로 개선된 UI가 적용됨

---

#### `dashboard-nvim` / `alpha-nvim` — 시작 화면

neovim을 파일 없이 실행했을 때 표시되는 시작 화면 플러그인.

**현재 문제:**
- 파일 없이 `nvim` 실행 시 빈 버퍼만 표시됨

**적용 시 제공 기능:**
- ASCII 아트 로고 또는 커스텀 헤더 표시
- 최근 작업 파일 목록 바로 표시 (파일 선택으로 바로 열기)
- 자주 쓰는 단축키 바로가기 표시 (e: 탐색기 열기, f: 파일 찾기 등)
- 세션 복원 버튼 (persistence.nvim 연동 시)
- neovim 버전, 플러그인 수 등 통계 표시

---

#### `trouble.nvim` — 진단 패널

LSP 진단(에러/경고), quickfix, references 등을 하단 패널로 관리하는 플러그인.

**현재 문제:**
- LSP 에러 확인 시 `]d`/`[d`로 하나씩 이동하거나 `<leader>ld`로 팝업을 열어야 함
- 파일 전체의 에러 목록을 한눈에 보기 어려움
- `gr` (references)로 찾은 결과가 telescope 팝업에만 표시되어 결과를 유지하며 편집하기 어려움

**trouble.nvim 적용 시:**
- `<leader>xx` 로 현재 파일의 에러/경고 전체를 하단 패널에 목록으로 표시
- `<leader>xX` 로 프로젝트 전체 진단 목록 표시
- 목록 항목 선택 시 해당 위치로 이동
- quickfix, LSP references, TODO 목록도 동일한 UI로 표시
- 패널을 열어둔 채로 다른 파일 편집 가능

---

### 2. 모션 & 텍스트 오브젝트

#### `flash.nvim` — 향상된 커서 이동

화면에 보이는 임의의 위치로 최소한의 키 입력으로 이동할 수 있게 해주는 플러그인.

**현재 문제:**
- `f`/`t` 이동은 현재 줄에서만 동작
- 다른 줄로 이동하려면 `/{검색어}<Enter>` 후 `n`/`N`으로 탐색하거나 줄 번호 이동(`12j` 등)을 사용해야 함
- 검색(`/`) 후 이동하면 검색 하이라이트가 남아 `<leader>h`로 지워야 함

**flash.nvim 적용 시:**
- `s` 키 입력 후 검색어를 타이핑하면 화면의 모든 매칭 위치에 라벨(a, b, c...)이 표시됨
- 라벨 키 하나만 누르면 해당 위치로 즉시 이동
- `f`/`t`도 현재 줄뿐 아니라 화면 전체로 확장됨
- `/` 검색 시에도 동일한 라벨 방식으로 이동 가능
- Treesitter 연동으로 `<leader>v`로 함수/블록 단위 선택도 가능

**사용 예시:**
```
현재 커서 위치에서 화면 내 "handleRequest" 함수로 이동 시:
  s → han → [a 라벨 표시] → a 입력 → 이동 완료
  (기존: /handleRequest<Enter>)
```

---

#### `nvim-surround` — Surround 편집

텍스트를 감싸는 괄호, 따옴표, 태그 등을 추가/변경/삭제하는 플러그인.

**현재 문제:**
- `"hello"` → `'hello'` 변환 시 수동으로 각 따옴표를 찾아서 교체해야 함
- 함수 인자에 괄호를 추가하거나 제거하려면 커서를 정확히 위치시켜야 함
- HTML/JSX 태그 변경 시 시작/끝 태그를 각각 수정해야 함

**nvim-surround 적용 시:**

| 동작 | 키 입력 | 결과 |
|---|---|---|
| 단어를 `"` 로 감싸기 | `ysiw"` | `hello` → `"hello"` |
| `"` 를 `'` 로 교체 | `cs"'` | `"hello"` → `'hello'` |
| `"` 제거 | `ds"` | `"hello"` → `hello` |
| 선택 영역을 `(` 로 감싸기 | `S(` (visual) | `hello` → `(hello)` |
| 함수로 감싸기 | `ysiwffoo<CR>` | `hello` → `foo(hello)` |
| HTML 태그 변경 | `cst<p>` | `<div>text</div>` → `<p>text</p>` |

---

#### `mini.ai` — 향상된 텍스트 오브젝트

vim 기본 텍스트 오브젝트(`iw`, `i"`, `i(` 등)를 확장하고 새로운 오브젝트를 추가하는 플러그인.

**현재 문제:**
- 함수 인자 전체를 선택하려면 `vi(` 후 수동 조정이 필요한 경우가 있음
- 함수 본문 전체 선택(`if`), 클래스 전체 선택(`ic`) 같은 오브젝트가 없음
- `da,` (인자 삭제) 같은 편리한 오브젝트가 없음

**mini.ai 적용 시:**

| 오브젝트 | 키 | 설명 |
|---|---|---|
| 함수 인자 | `ia` / `aa` | 커서가 위치한 함수 인자 선택 (`,` 포함 여부 차이) |
| 함수 본문 | `if` / `af` | 함수 내부/전체 선택 (Treesitter 기반) |
| 클래스 본문 | `ic` / `ac` | 클래스 내부/전체 선택 |
| 따옴표 내부 | `iq` / `aq` | `"`, `'`, `` ` `` 구분 없이 가장 가까운 따옴표 내부 |
| 블록 | `ib` / `ab` | `()`, `[]`, `{}` 구분 없이 가장 가까운 블록 |

---

### 3. Treesitter 확장

#### `nvim-treesitter-context` — 현재 스코프 컨텍스트 표시

스크롤 시 현재 커서가 속한 함수/클래스/블록의 시작줄을 화면 최상단에 고정으로 표시하는 플러그인.

**현재 문제:**
- 100줄짜리 함수 내부를 스크롤하면 함수 선언부가 화면 밖으로 나가버림
- 어떤 함수 안에 있는지 확인하려면 위로 스크롤하거나 `[m` 같은 이동 키를 써야 함
- 중첩된 조건문/반복문에서 현재 어느 블록 안에 있는지 파악이 어려움

**적용 시:**
```
화면 최상단에 아래와 같이 고정 표시됨:

  func (s *Server) handleRequest(w http.ResponseWriter, r *http.Request) {  ← 항상 표시
    if r.Method == "POST" {  ← 현재 블록도 표시
  ...
  [현재 커서 위치]
```
- 중첩 깊이에 따라 여러 줄의 컨텍스트가 표시됨
- 클릭하거나 단축키로 컨텍스트 위치로 즉시 이동 가능

---

#### `nvim-treesitter-textobjects` — Treesitter 기반 텍스트 오브젝트

AST(추상 구문 트리)를 기반으로 함수, 클래스, 파라미터 단위로 이동/선택/교환하는 플러그인.

**현재 문제:**
- 다음 함수로 이동하려면 `/func ` 검색이나 `]]` 같은 기본 동작에 의존해야 함
- 함수 파라미터만 선택하거나 두 파라미터를 교환하는 기능이 없음

**적용 시:**

| 동작 | 키 | 설명 |
|---|---|---|
| 다음 함수로 이동 | `]f` | 다음 함수 선언부로 이동 |
| 이전 함수로 이동 | `[f` | 이전 함수 선언부로 이동 |
| 함수 내부 선택 | `vif` | 함수 본문 전체 선택 |
| 파라미터 선택 | `via` | 현재 커서의 파라미터 선택 |
| 파라미터 교환 | `<leader>a` | 현재 파라미터를 다음 파라미터와 교환 |
| 함수 전체 선택 | `vaf` | 함수 선언부 포함 전체 선택 |

---

### 4. 검색 & 치환

#### `grug-far.nvim` — 프로젝트 전체 검색/치환

프로젝트 전체에서 문자열을 검색하고 대화형으로 치환하는 플러그인.

**현재 문제:**
- `<leader>fg` (telescope live_grep)으로 검색은 가능하지만 치환 기능이 없음
- 프로젝트 전체 변수명/함수명 변경 시 LSP rename(`<leader>lr`)은 단일 심볼에만 동작
- 문자열 리터럴 일괄 변경 시 외부 터미널에서 `sed` 명령을 써야 함

**grug-far.nvim 적용 시:**
- neovim 내에서 ripgrep 기반 검색 + 치환을 대화형으로 진행
- 검색 결과를 미리보기로 확인 후 선택적으로 치환 가능
- 정규식 지원
- 특정 파일 타입이나 경로만 대상으로 치환 범위 제한 가능
- 치환 전 diff 미리보기 제공

**사용 예시:**
```
// Go 프로젝트에서 "oldFunctionName" → "newFunctionName" 전체 치환
// 단순 문자열 치환이므로 다른 패키지의 동일 이름 함수도 함께 변경 가능
// 변경 전 파일별 diff를 확인하고 개별 항목은 제외할 수 있음
```

---

#### `telescope-ui-select` — telescope를 vim.ui.select로 사용

neovim 내부의 `vim.ui.select()` 호출을 telescope 팝업으로 표시하는 플러그인.

**현재 문제:**
- `<leader>la` (code action) 실행 시 기본 선택 UI가 하단에 작게 표시됨
- 선택 항목이 많을 때 스크롤이 불편하고 검색이 안 됨

**적용 시:**
- code action, LSP 관련 선택창이 모두 telescope 팝업으로 표시됨
- 검색으로 빠르게 원하는 항목 필터링 가능
- 일관된 UI 경험 제공

---

### 5. 세션 관리

#### `persistence.nvim` — 프로젝트 세션 저장/복원

작업 디렉토리별로 열린 파일, 창 레이아웃, 커서 위치를 저장하고 복원하는 플러그인.

**현재 문제:**
- neovim을 종료하고 다시 실행하면 매번 파일을 다시 열어야 함
- 여러 파일을 분할창으로 작업하다가 종료하면 레이아웃이 초기화됨
- 프로젝트 디렉토리별로 다른 파일 세트를 유지하기 어려움

**persistence.nvim 적용 시:**
- `nvim`을 특정 디렉토리에서 실행하면 이전 세션이 자동으로 복원됨
- 열린 파일 목록, 분할창 레이아웃, 버퍼별 커서 위치가 모두 복원됨
- `<leader>qs` 로 현재 세션 저장, `<leader>ql` 로 마지막 세션 복원
- 프로젝트 디렉토리가 다르면 세션도 분리되어 관리됨

---

### 6. LSP 보조

#### `lazydev.nvim` — neovim config용 Lua LSP 향상

neovim 설정 파일(`~/.config/nvim/`)을 편집할 때 Lua LSP가 neovim API를 정확히 인식하도록 개선하는 플러그인.

**현재 문제:**
- `vim.api.nvim_create_autocmd()` 같은 neovim 전용 API 입력 시 LSP가 타입을 모르는 경우가 있음
- `vim.opt`, `vim.g` 등의 자동완성이 불완전하게 동작하기도 함
- 플러그인 spec 타입(`LazyPluginSpec` 등)이 자동완성에 표시되지 않음

**lazydev.nvim 적용 시:**
- neovim 모든 API에 대한 타입 정의가 자동으로 Lua LSP에 로드됨
- `vim.api.*`, `vim.opt.*`, `vim.fn.*` 등 완전한 자동완성 제공
- lazy.nvim 플러그인 스펙 타입도 인식하여 설정 작성이 편리해짐

---

## 추가 우선순위

### 높은 우선순위 (실사용에 바로 영향)

| 우선순위 | 플러그인 | 이유 |
|---|---|---|
| 1 | `nvim-surround` | surround 편집은 매일 쓰는 기능. `cs"'`, `ysiw"`, `ds"` 등 |
| 2 | `nvim-treesitter-context` | 긴 파일 탐색 시 현재 위치 파악 필수 |
| 3 | `trouble.nvim` | LSP 에러 목록 패널 관리. `]d`/`[d` 보다 편리 |
| 4 | `grug-far.nvim` | 프로젝트 전체 변수명/문자열 치환 |

### 중간 우선순위

| 우선순위 | 플러그인 | 이유 |
|---|---|---|
| 5 | `noice.nvim` + `nvim-notify` | UI가 크게 달라짐. cmdline 팝업, 알림 시스템 |
| 6 | `flash.nvim` | 이동 효율 향상. 특히 긴 파일에서 유용 |
| 7 | `persistence.nvim` | 프로젝트별 세션 저장. 재시작 시 편의성 |

### 낮은 우선순위

| 우선순위 | 플러그인 | 이유 |
|---|---|---|
| 8 | `mini.ai` | 텍스트 오브젝트 확장. 학습 곡선 있음 |
| 9 | `nvim-treesitter-textobjects` | 코드 단위 이동/선택 강화 |
| 10 | `dashboard-nvim` | 시작 화면. 기능보다 UX 개선 |
| 11 | `lazydev.nvim` | neovim 설정 개발 시에만 유용 |
| 12 | `dressing.nvim` | UX 소폭 개선 |
| 13 | `telescope-ui-select` | code action UI 개선. dressing.nvim과 역할 겹침 |

---

## 생략하기로 결정한 항목

| 플러그인 | 이유 |
|---|---|
| `vim-visual-multi` (멀티커서) | 학습 곡선 대비 효용 불확실, 필요 시 추가 |
| `markdown-preview.nvim` | `render-markdown.nvim`으로 인라인 렌더링 충분 |
| `lang-go.lua` (go.nvim) | gopls + dap-go로 충분 (`extras/lang/go.lua` 완료) |
| `lang-yaml.lua` (yaml-companion) | yaml-language-server로 충분 (`extras/lang/ops.lua` 완료) |
| `cmp-cmdline` | `blink.cmp`가 cmdline 자동완성을 내장 지원하므로 불필요 |

# Neovim 설정 가이드
나만의 Neovim 설정

## 목차

- [사전 준비](#사전-준비)
- [단축키와 사용법 확인](#단축키와-사용법-확인)
- [플러그인 목록](#플러그인-목록)
  - [플러그인 매니저](#플러그인-매니저)
  - [LSP / 자동완성](#lsp--자동완성)
  - [포매터 / 린터](#포매터--린터)
  - [문법 하이라이팅](#문법-하이라이팅)
  - [검색 / 탐색](#검색--탐색)
  - [파일 탐색기](#파일-탐색기)
  - [Git 통합](#git-통합)
  - [편집 보조](#편집-보조)
  - [디버깅](#디버깅)
  - [언어 도구](#언어-도구)
  - [UI](#ui)
  - [입력기](#입력기)
  - [AI](#ai)

---

## 사전 준비

### Neovim 설치

```bash
brew update
brew install neovim
```

### 필수 의존성

```bash
# mason 으로 npm 기반 LSP 서버(pyright, yamlls, jsonls, bashls, dockerls) 설치 시 필요
brew install node

# Telescope 파일 이름 검색 (.gitignore 무시 및 숨김 파일 검색 포함)
brew install fd
# Telescope 텍스트 검색 (live grep)
brew install ripgrep

# nvim-treesitter 파서 빌드
brew install tree-sitter-cli

# 한/영 입력기 자동 전환 (im-select.nvim)
brew install im-select

# Go 디버거 (nvim-dap-go 사용 시)
brew install delve
```

### 포매터 설치

해당 언어를 사용할 때만 설치하면 됩니다.

```bash
# Go (gofumpt → goimports)
go install mvdan.cc/gofumpt@latest
go install golang.org/x/tools/cmd/goimports@latest

# Python (black → isort)
pip install black isort

# SQL (sqlfluff)
pip install sqlfluff

# YAML / JSON (prettier)
npm install -g prettier

# Bash (shfmt)
brew install shfmt
```

> **Note**: `shellcheck`, `hadolint`, `prettier`, `stylua`, `gomodifytags` 등 mason 으로 설치 가능한 린터/포매터/도구는
> `mason-tool-installer` 가 nvim 시작 시 자동으로 설치합니다 (수동 설치 불필요).
>
> `gopls`, `pyright`, `lua_ls`, `yamlls`, `jsonls`, `bashls`, `dockerls` 같은 LSP 서버도
> mason 이 자동으로 설치하므로 별도 설치가 필요 없습니다.

### Claude Code CLI (선택)

`coder/claudecode.nvim` 플러그인을 사용하려면 Claude Code CLI 가 필요합니다.

```bash
npm install -g @anthropic-ai/claude-code
```

---

## 단축키와 사용법 확인

상세한 단축키와 플러그인 사용법은 neovim 내부에서 치트시트로 조회할 수 있습니다.

| 단축키       | 설명                                                  |
|--------------|-------------------------------------------------------|
| `<leader>kn` | Neovim 내장 명령 / 단축키 치트시트 (플로팅 창)        |
| `<leader>kp` | 플러그인 사용법 치트시트 (플로팅 창)                  |
| `<leader>kg` | `guide/` 디렉토리 키워드 검색 (Telescope live grep)   |
| `<leader>ks` | 등록된 모든 단축키 검색 (Telescope)                   |

> 치트시트 원본 파일
> - `guide/nvim-cheatsheet.md` — Neovim 기본 동작
> - `guide/plugin-cheatsheet.md` — 설치된 플러그인 사용법 / 단축키

---

## 플러그인 목록

각 플러그인의 상세 단축키와 사용법은 `guide/plugin-cheatsheet.md` (`<leader>kp`) 에서 확인하세요.

---

### 플러그인 매니저

#### [folke/lazy.nvim](https://github.com/folke/lazy.nvim)

Neovim 의 표준에 가까운 최신 플러그인 매니저입니다.
플러그인 정의를 Lua 테이블 스펙으로 작성하며, 각 플러그인을 `event` / `cmd` / `ft` / `keys`
기준으로 지연 로딩해 startup 시간을 최소화합니다.
`:Lazy` GUI 로 설치 / 업데이트 / 청소를 시각적으로 관리하고,
`lockfile` 로 플러그인 버전을 고정해 재현 가능한 환경을 유지합니다.
이 설정은 `lua/plugins/` 아래 디렉토리 단위 자동 import 와 `lua/extras/lang/` 언어별 분산 설정 패턴을 사용합니다.

---

### LSP / 자동완성

#### [williamboman/mason.nvim](https://github.com/williamboman/mason.nvim)

LSP 서버 / 포매터 / 린터 / 디버그 어댑터를 neovim 안에서 설치·관리하는 패키지 매니저입니다.
Go / Node / Python / Rust 등 서로 다른 런타임으로 배포되는 도구들의 설치 경로를 통합해
`~/.local/share/nvim/mason/bin/` 한 곳에 모으고, `PATH` 없이도 사용 가능하게 해줍니다.
`:Mason` 으로 GUI 설치 화면을 열거나 `:MasonInstall <pkg>` 로 개별 설치할 수 있습니다.

#### [williamboman/mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim)

mason 과 `nvim-lspconfig` 사이의 이름 매핑 / 자동 활성화 브릿지입니다.
`ensure_installed` 에 서버를 나열하면 nvim 시작 시 자동 설치되며,
lspconfig 의 서버 키와 mason 패키지 이름의 차이를 내부적으로 변환해줍니다.
이 설정에서는 공용 서버 리스트 대신 `lua/extras/lang/*.lua` 의 언어별 opts function 으로
`gopls`, `pyright`, `lua_ls` 등을 분산 관리합니다.

#### [WhoIsSethDaniel/mason-tool-installer.nvim](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim)

mason-lspconfig 가 다루지 않는 외부 도구(LSP 가 아닌 린터 / 포매터 / 부가 CLI)를 `ensure_installed` 로 자동 설치합니다.
`shellcheck`, `hadolint`, `prettier`, `stylua`, `gomodifytags` 같은 도구들이 여기서 일괄 관리되며,
nvim 시작 시 미설치된 것만 자동으로 내려받습니다.
`:MasonToolsUpdate` 로 수동 업데이트, `:MasonToolsClean` 으로 ensure_installed 에 없는 도구를 제거할 수 있습니다.

#### [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)

Neovim 내장 LSP 클라이언트를 위한 언어 서버별 기본 설정 모음입니다.
정의 이동, 참조 찾기, 코드 액션, rename, 호버 문서, 진단(diagnostics) 등 IDE 기능의 중심축입니다.
이 설정은 Neovim 0.11+ 의 `vim.lsp.config` / `vim.lsp.enable` 신형 API 로 서버를 등록합니다.
언어별 서버 옵션(예: `gopls` 의 staticcheck / inlay hints)은 `lua/extras/lang/` 각 파일에서 `opts.configs` 로 주입합니다.

#### [saghen/blink.cmp](https://github.com/saghen/blink.cmp)

Rust 구현 + SIMD 매칭으로 매우 빠른 자동완성 엔진입니다.
LSP / 스니펫(LuaSnip + friendly-snippets) / 버퍼 / 경로를 하나의 소스로 통합하고,
팝업 우측에 각 항목의 출처(`LSP`, `Snip`, `Path`, `Buf`) 가 표시됩니다.
함수 선택 시 괄호가 자동으로 추가되는 `auto_brackets`, 키바인딩 프리셋(`super-tab`) 등 기본값이 합리적이라 설정이 거의 필요 없습니다.

---

### 포매터 / 린터

#### [stevearc/conform.nvim](https://github.com/stevearc/conform.nvim)

파일 저장 시 언어별 포매터 체인을 실행하는 통합 매니저입니다.
하나의 파일에 여러 포매터를 순차 적용할 수 있고(예: `gofumpt → goimports`), LSP 포맷을 fallback 으로 사용할 수 있습니다.
언어별 포매터 매핑은 `lua/extras/lang/*.lua` 에서 주입합니다.

**적용 포매터**: Go (gofumpt → goimports) · Python (black → isort) · Lua (stylua) · YAML (prettier) · JSON (prettier) · Bash (shfmt) · SQL (sqlfluff)

#### [mfussenegger/nvim-lint](https://github.com/mfussenegger/nvim-lint)

LSP 진단만으로 부족한 외부 린터를 실행해 neovim 진단 시스템(`vim.diagnostic`)에 주입합니다.
파일 열기(`BufReadPost` / `BufNewFile`), 저장 후(`BufWritePost`), Insert → Normal 전환 시점(`InsertLeave`)에 자동 실행됩니다.
진단 결과는 LSP 진단과 동일하게 `]d` / `[d` / `<leader>ld` 로 탐색할 수 있습니다.

**적용 린터**: Bash / Shell (shellcheck) · Dockerfile (hadolint)

---

### 문법 하이라이팅

#### [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)

AST 기반으로 정확한 문법 하이라이팅 / 들여쓰기 / 코드 폴딩을 제공합니다.
regex 기반 하이라이트보다 문맥 판단이 훨씬 정확하며,
`blink.cmp` 의 심볼 컨텍스트, `nvim-ufo` 의 폴딩 힌트, `nvim-autopairs` 의 문맥 분기(문자열 / 주석 내부 비활성화) 등에도 활용됩니다.
언어별 파서는 `lua/extras/lang/*.lua` 에서 `vim.g.extra_treesitter_parsers` 로 병합 주입하고,
`:TSInstall <언어>` 로 추가 수동 설치도 가능합니다.

**자동 설치 파서**: `lua`, `vim`, `vimdoc`, `query`, `markdown`, `markdown_inline`, `go`, `gomod`, `gosum`, `gowork`, `python`, `yaml`, `json`, `bash`, `dockerfile`, `sql`, `make`

---

### 검색 / 탐색

#### [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)

파일, 텍스트, Git 이력, LSP 심볼, 테마, 키맵, 도움말 등 거의 모든 것을 퍼지 검색 프롬프트로 통합하는 플러그인입니다.
결과 목록에서 수직 / 수평 분할, 새 탭, quickfix 전송 같은 액션을 제공하며,
이 설정에서는 LSP references / colorscheme 실시간 프리뷰 / TODO 검색 / 단축키 검색 / 가이드 문서 검색 등에 폭넓게 사용합니다.
`fd` 와 `ripgrep` 을 백엔드로 사용하므로 대규모 프로젝트에서도 빠릅니다.

---

### 파일 탐색기

#### [nvim-neo-tree/neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)

파일 시스템 / 버퍼 목록 / Git 상태를 사이드바 트리로 전환하며 표시합니다.
트리 안에서 파일 / 디렉토리 CRUD, 이름 변경, 경로 복사, 파일 이동, diff 미리보기를 직접 수행할 수 있고,
`reveal` 액션으로 현재 편집 중인 파일의 위치를 트리에서 즉시 강조할 수 있습니다.
소스별 뷰(`filesystem` / `buffers` / `git_status`)는 같은 창에서 탭처럼 전환됩니다.

---

### Git 통합

#### [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)

에디터 좌측 gutter 에 hunk 변경 / 추가 / 삭제를 실시간으로 표시합니다.
hunk 단위로 다음 / 이전 이동, 변경사항 미리보기, 현재 줄 blame 토글, 줄 단위 staging / reset 등을 지원하며,
Git 워크플로우의 가장 빈번한 동작을 에디터 안에서 처리할 수 있게 해주는 플러그인입니다.

#### [NeogitOrg/neogit](https://github.com/NeogitOrg/neogit)

Emacs Magit 스타일의 neovim Git 인터페이스입니다.
상호작용형 버퍼에서 stage / unstage / commit / push / pull / rebase / cherry-pick 등 전체 Git 워크플로우를 처리합니다.
`diffview.nvim` 과 연동되어 있어 커밋 전 변경사항을 diff 로 바로 검토할 수 있습니다.

#### [sindrets/diffview.nvim](https://github.com/sindrets/diffview.nvim)

파일 변경사항을 좌우 분할 뷰로 비교하는 diff 뷰어입니다.
워킹 트리 diff 뿐만 아니라 커밋 히스토리(`:DiffviewFileHistory`), 파일별 이력도 탐색할 수 있어 리뷰 작업에 유용합니다.

---

### 편집 보조

#### [windwp/nvim-autopairs](https://github.com/windwp/nvim-autopairs)

괄호 / 따옴표 입력 시 닫는 쌍을 자동으로 추가합니다.
treesitter 연동으로 문자열 / 주석 내부에서는 자동 완성을 비활성화하며,
`(<CR>` 처럼 괄호 뒤 Enter 시 자동 들여쓰기와 함께 블록이 펼쳐집니다.

#### [numToStr/Comment.nvim](https://github.com/numToStr/Comment.nvim)

언어별 주석 문법을 자동 감지해 줄 / 블록 주석을 토글합니다.
`gcc` (현재 줄), `gbc` (블록 주석), `gc` + motion / text object (`gcip`, `gc3j`), Visual 영역 주석 등
`gc` / `gb` prefix 기반의 표준 motion 을 지원합니다.
JSX / TSX / Vue 같은 파일 내 혼합 문법도 treesitter 로 정확히 인식합니다.

#### [lukas-reineke/indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim)

들여쓰기 레벨을 수직선(`│`)으로 시각화하는 플러그인입니다.
현재 커서가 속한 스코프를 강조 표시해 중첩이 깊은 코드에서 구조 파악을 돕습니다.
빈 줄에도 들여쓰기 가이드가 유지되어 Python / YAML 처럼 들여쓰기가 문법인 언어에서 특히 유용합니다.

#### [folke/todo-comments.nvim](https://github.com/folke/todo-comments.nvim)

`TODO`, `FIXME`, `NOTE`, `HACK`, `WARN`, `PERF`, `TEST` 같은 주석 키워드를 색상으로 하이라이팅하고,
프로젝트 전체에서 TODO 를 한 번에 검색 / 이동할 수 있게 해줍니다.
Telescope 와 연동되어 `<leader>ft` 로 전체 TODO 를 퍼지 검색할 수 있습니다.

#### [dhruvasagar/vim-table-mode](https://github.com/dhruvasagar/vim-table-mode)

Markdown 테이블 정렬에 특화된 플러그인입니다.
큰 markdown 파일에서 저장 lag 을 피하기 위해 자동 정렬(`BufWritePre`)은 비활성화했고,
`<leader>mf` 또는 `:MarkdownTableRealign` 로 명시 호출합니다.
또한 markdown 파일 저장 시 trailing 공백은 제거되지 않도록 설정해, 2칸 공백 줄바꿈 문법을 보존합니다.

#### [MeanderingProgrammer/render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim)

neovim 버퍼 안에서 Markdown 을 라이브 렌더링합니다.
헤더 / 코드블록 / 체크박스 / 테이블 / 인용구 / 링크를 아이콘과 색상으로 표현해,
외부 프리뷰 도구 없이도 `.md` 파일을 정돈된 형태로 읽을 수 있습니다.
`<leader>mr` 로 렌더링을 토글합니다.

#### [mg979/vim-visual-multi](https://github.com/mg979/vim-visual-multi)

VSCode 스타일 멀티 커서 편집 플러그인입니다.
`<C-n>` 반복으로 같은 단어를 점진 선택하거나, `\\A` 로 모든 매칭에 한 번에 커서를 생성할 수 있고,
정규식 검색(`\\/`) 으로 매칭 위치에 커서를 배치하는 것도 가능합니다.
여러 줄 임의 위치 멀티 편집(`<C-Down>` / `<C-Up>`) 으로 변수명 일괄 변경 같은 작업을 빠르게 처리합니다.

#### [kevinhwang91/nvim-ufo](https://github.com/kevinhwang91/nvim-ufo)

LSP + treesitter 기반 고급 폴딩 플러그인입니다.
Neovim 기본 폴딩보다 정확한 블록 인식, 접힌 줄 수 표시, 커스텀 virtual text 로 접힌 내용의 요약 표시 등을 지원합니다.
`<leader>zp` 로 접힌 블록 내용을 현재 위치에서 미리볼 수 있습니다.

---

### 디버깅

#### [mfussenegger/nvim-dap](https://github.com/mfussenegger/nvim-dap)

Debug Adapter Protocol 클라이언트 코어입니다.
브레이크포인트 / step over·into·out / 변수 조사 / watches / REPL 등 디버깅의 하부 기능을 담당하며,
DAP 어댑터만 연결하면 사실상 모든 언어의 디버깅이 가능합니다.

#### [rcarriga/nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui)

DAP 세션의 변수 / 콜스택 / 브레이크포인트 / watches / REPL / console 을 패널로 표시합니다.
이 설정에서는 디버깅 시작(`event_initialized`) 시 UI 가 자동으로 열리고,
종료(`event_terminated` / `event_exited`) 시 자동으로 닫히도록 리스너를 연결했습니다.

#### [nvim-neotest/nvim-nio](https://github.com/nvim-neotest/nvim-nio)

nvim-dap-ui 가 내부적으로 사용하는 비동기(coroutine 기반) 라이브러리입니다.
별도 조작은 필요 없고 의존성으로만 설치됩니다.

#### [leoluz/nvim-dap-go](https://github.com/leoluz/nvim-dap-go)

Go 전용 DAP 설정 플러그인입니다.
`delve` 디버거를 자동 실행하고 `debug_test` 로 커서 위치 테스트 함수를 즉시 디버깅할 수 있습니다.
이 설정에서는 `dap.run` 을 래핑해 디버깅 시작 직전에 현재 작업 디렉토리의 `.env` 파일을 자동으로 읽어
테스트 프로세스 환경변수로 주입하도록 확장했습니다.
`//go:build integration` 같은 빌드 태그가 필요한 테스트를 위한 "빌드 태그 입력" 설정도 내장되어 있습니다.

---

### 언어 도구

#### [gomodifytags](https://github.com/fatih/gomodifytags)

Go struct 필드의 태그(`json`, `yaml`, `toml`, `xml`, `db` 등)를 생성 / 제거 / 초기화하는 CLI 도구입니다.
이 설정에서는 `extras/lang/go.lua` 에서 래핑해 `:GoAddTag`, `:GoRmTag`, `:GoClearTag` 사용자 명령으로 노출했고,
`-transform snakecase` 를 기본값으로 사용해 `UserName` 같은 필드가 `user_name` 태그로 변환되도록 했습니다.
`mason-tool-installer` 를 통해 nvim 시작 시 자동 설치됩니다.

---

### UI

#### [akinsho/bufferline.nvim](https://github.com/akinsho/bufferline.nvim)

열린 버퍼를 상단 탭 형태로 표시합니다.
LSP 진단 아이콘이 탭에 함께 표시되어 어느 버퍼에 오류가 있는지 한눈에 파악할 수 있고,
버퍼 선택 / 닫기 시 알파벳 키 pick 모드를 지원해 다수 버퍼 환경에서도 빠르게 이동할 수 있습니다.

#### [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)

하단 상태바 플러그인입니다.
창이 여러 개로 분할되어도 상태바는 맨 아래 하나만 유지되는 `globalstatus` 모드를 사용합니다.
모드 / git 브랜치 + diff / 파일명 / LSP 진단 / 파일 타입 / 진행률% / 줄:열 정보를 표시합니다.

#### [folke/which-key.nvim](https://github.com/folke/which-key.nvim)

`<leader>` 나 `g`, `z` 같은 prefix 키를 누른 뒤 500ms 대기하면
사용 가능한 단축키를 플로팅 팝업으로 표시해주는 플러그인입니다.
단축키를 외우지 않아도 탐색하며 기억할 수 있고, 그룹별 설명(`<leader>g` = Git 등)이 표시됩니다.
`:WhichKey` 로 전체 키맵을 열람할 수도 있습니다.

#### [akinsho/toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim)

float / horizontal / vertical 레이아웃의 터미널을 단축키로 토글하는 플러그인입니다.
여러 개의 번호별 터미널을 동시에 열고 전환하며 사용할 수 있고,
외부 CLI 를 float 터미널로 래핑해 neovim 내부에서 실행하는 런처 역할도 합니다(예: `claudecode`).

#### [projekt0n/github-nvim-theme](https://github.com/projekt0n/github-nvim-theme) (기본 테마)

GitHub UI 색감 기반 테마입니다.
기본값은 `github_dark_high_contrast` 이며, Go 코드용 treesitter highlight
(변수 / 함수 / 타입 / 키워드 색상 구분) 가 커스터마이즈되어 있습니다.

#### [rebelot/kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim) (대체 테마)

호쿠사이의 '가나가와 해변의 큰 파도' 에서 영감받은 다크 테마입니다.
`wave` (기본 다크) / `dragon` (더 어두운 다크) / `lotus` (라이트) 3종 variant 를 제공합니다.

#### [EdenEast/nightfox.nvim](https://github.com/EdenEast/nightfox.nvim) (대체 테마)

여우 컨셉의 테마 모음입니다.
`nightfox` / `duskfox` / `nordfox` / `terafox` / `carbonfox` (다크) / `dayfox` / `dawnfox` (라이트) 등 7종 variant 를 제공합니다.

---

### 입력기

#### [keaising/im-select.nvim](https://github.com/keaising/im-select.nvim)

Insert 모드 탈출 시 시스템 입력기를 영어로 자동 전환하고,
Insert 재진입 시 이전 입력기 상태로 자동 복원합니다.
한글 입력 환경에서 Normal 모드 진입 직후 한글이 명령으로 찍히는 문제를 근본적으로 방지합니다.
동작을 위해 `brew install im-select` 로 CLI 가 설치되어 있어야 합니다.

---

### AI

#### [coder/claudecode.nvim](https://github.com/coder/claudecode.nvim)

Claude Code CLI 와 Neovim 을 연결하는 공식 IDE 통합 플러그인입니다.
WebSocket 기반 MCP(Model Context Protocol) 로 현재 편집 중인 파일과 선택 영역을 Claude 가 실시간으로 인식하며,
Claude 가 제안하는 코드 변경사항을 diff 로 검토하고 수락 / 거절할 수 있습니다.
사용 전 [Claude Code CLI](#claude-code-cli-선택) 설치가 필요합니다.

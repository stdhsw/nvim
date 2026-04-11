# 플러그인 리스트

## 기술 스택
- 언어: Go, Python, SQL, YAML, JSON, Bash, Dockerfile, Makefile
- 인프라: Kubernetes manifests

---

## 플러그인 매니저

| 상태 | 플러그인 | 필요한 이유 |
|---|---|---|
| ✅ | `folke/lazy.nvim` | 플러그인 설치/업데이트/삭제 관리. 지연 로딩으로 시작 속도 최적화 |

---

## LSP / 자동완성 / 진단

| 상태 | 플러그인 | 필요한 이유 |
|---|---|---|
| ✅ | `williamboman/mason.nvim` | Go, Python, YAML 등 각 언어의 LSP 서버와 포매터를 neovim 안에서 한 번에 설치/관리 |
| ✅ | `williamboman/mason-lspconfig.nvim` | mason으로 설치한 서버를 lspconfig에 자동 연결 |
| ✅ | `WhoIsSethDaniel/mason-tool-installer.nvim` | mason-lspconfig 가 다루지 않는 외부 도구(shellcheck, hadolint 등 린터/포매터)를 ensure_installed 로 자동 설치 |
| ✅ | `neovim/nvim-lspconfig` | gopls, pyright 등 LSP 서버와 neovim을 연결. 코드 진단, 정의 이동, 참조 찾기 등 IDE 기능의 핵심 |
| ✅ | `saghen/blink.cmp` | Rust 기반 고성능 자동완성 엔진. LSP, 스니펫, 경로, 버퍼 소스 통합. 함수 괄호 자동 추가(auto_brackets) 내장 |
| ✅ | `L3MON4D3/LuaSnip` | 스니펫 엔진. Go 구조체, Python 함수, K8s manifest 템플릿 등 반복 패턴을 빠르게 입력 |
| ✅ | `rafamadriz/friendly-snippets` | Go, Python, bash, dockerfile 등 언어별 실용 스니펫 모음 |

### LSP 서버 (mason으로 자동 설치)

| 서버 | 언어 | 필요한 이유 |
|---|---|---|
| `gopls` | Go | Go 공식 LSP. 타입 추론, 자동완성, import 관리, inlay hints |
| `pyright` | Python | 정적 타입 분석 기반 LSP. 타입 오류 사전 감지 |
| `lua-language-server` | Lua | neovim 설정 작성용. vim 전역 인식 + neovim runtime 라이브러리 자동완성 |
| `yaml-language-server` | YAML, K8s | YAML 문법 검사 + Kubernetes schema 검증 |
| `json-lsp` | JSON | JSON 스키마 검증, 자동완성 |
| `bash-language-server` | Bash | 쉘 스크립트 자동완성, 문법 오류 감지 |
| `dockerfile-language-server` | Dockerfile | Dockerfile 명령어 자동완성, 문법 검사 |

---

## 포매터 / 린터

| 상태 | 플러그인 | 필요한 이유 |
|---|---|---|
| ✅ | `stevearc/conform.nvim` | 저장 시 자동 포맷. 언어별 포매터를 통합 관리하고 fallback 체인 설정 가능 |
| ✅ | `mfussenegger/nvim-lint` | LSP가 지원하지 않는 린터(hadolint, shellcheck 등)를 통합 관리 |

### 포매터/린터 도구

| 도구 | 언어 | 설치 방법 |
|---|---|---|
| `gofumpt` | Go | `go install mvdan.cc/gofumpt@latest` |
| `goimports` | Go | `go install golang.org/x/tools/cmd/goimports@latest` |
| `black` | Python | `pip install black` |
| `isort` | Python | `pip install isort` |
| `sqlfluff` | SQL | `pip install sqlfluff` |
| `shfmt` | Bash | `brew install shfmt` |
| `stylua` | Lua | mason-tool-installer 자동 설치 |
| `prettier` | YAML, JSON | mason-tool-installer 자동 설치 |
| `hadolint` | Dockerfile | mason-tool-installer 자동 설치 |
| `shellcheck` | Bash | mason-tool-installer 자동 설치 |

---

## 문법 하이라이팅

| 상태 | 플러그인 | 필요한 이유 |
|---|---|---|
| ✅ | `nvim-treesitter/nvim-treesitter` | 정규식 기반 하이라이팅보다 정확한 AST 파싱. Go, Python, YAML, K8s 등 모든 스택 지원 |

### Treesitter 파서 (자동 설치)
`go`, `python`, `lua`, `sql`, `query`, `yaml`, `json`, `bash`, `dockerfile`, `make`, `vim`, `vimdoc`, `markdown`, `markdown_inline`

---

## 검색 / 탐색

| 상태 | 플러그인 | 필요한 이유 |
|---|---|---|
| ✅ | `nvim-telescope/telescope.nvim` | 파일명, 코드 내용, LSP 심볼, git 이력 등 모든 검색을 퍼지 검색으로 통합 |
| ✅ | `nvim-telescope/telescope-fzf-native.nvim` | fzf 알고리즘으로 telescope 검색 속도 향상 |
| ✅ | `nvim-lua/plenary.nvim` | telescope, gitsigns 등 여러 플러그인의 공통 의존성 유틸 라이브러리 |

---

## 파일 탐색기

| 상태 | 플러그인 | 필요한 이유 |
|---|---|---|
| ✅ | `nvim-neo-tree/neo-tree.nvim` | 프로젝트 디렉토리 구조를 사이드바로 시각화 |
| ✅ | `nvim-tree/nvim-web-devicons` | 파일 확장자별 아이콘 표시 |
| ✅ | `MunifTanjim/nui.nvim` | neo-tree UI 컴포넌트 의존성 |

---

## Git 통합

| 상태 | 플러그인 | 필요한 이유 |
|---|---|---|
| ✅ | `lewis6991/gitsigns.nvim` | 변경된 줄을 좌측 gutter에 표시. hunk 단위 스테이징/되돌리기 |
| ✅ | `NeogitOrg/neogit` | neovim 안에서 git add, commit, push, rebase 등 전체 워크플로우 처리 |
| ✅ | `sindrets/diffview.nvim` | 파일 diff, 머지 충돌 해결을 neovim 안에서 처리 |
| ✅ | `lazygit` (CLI) | ui/toggleterm.lua로 연동하는 git TUI. `<leader>gg`로 실행. `brew install lazygit` 필요 |

---

## 편집 보조

| 상태 | 플러그인 | 필요한 이유 |
|---|---|---|
| ✅ | `windwp/nvim-autopairs` | 괄호/따옴표 자동 닫기 |
| ✅ | `numToStr/Comment.nvim` | `gcc`로 줄 주석 토글. 언어별 주석 문법 자동 감지 |
| ✅ | `lukas-reineke/indent-blankline.nvim` | 들여쓰기 레벨을 수직선으로 시각화. 중첩된 YAML, K8s manifest 구조 파악에 유용 |
| ✅ | `folke/todo-comments.nvim` | `TODO`, `FIXME`, `NOTE` 등을 하이라이팅하고 telescope로 전체 검색 가능 |
| ✅ | `dhruvasagar/vim-table-mode` | Markdown 테이블 자동 정렬. `\|` 입력 시 실시간 열 너비 정렬, `<leader>tm`으로 모드 토글 |
| ✅ | `MeanderingProgrammer/render-markdown.nvim` | Neovim 버퍼 내 Markdown 인라인 렌더링. 헤더, 코드블록, 체크박스, 테이블 시각화 |
| ✅ | `kevinhwang91/nvim-ufo` | LSP + treesitter 기반 코드 폴딩. 접힌 줄 수 표시, fold peek 지원 |
| ✅ | `kevinhwang91/promise-async` | nvim-ufo 비동기 처리 의존성 |
| ➖ | `mg979/vim-visual-multi` | 멀티커서 편집. 여러 위치에 동시에 커서를 놓고 편집. Ctrl+N으로 단어 선택 후 동시 수정 |

---

## 디버깅

| 상태 | 플러그인 | 필요한 이유 |
|---|---|---|
| ✅ | `mfussenegger/nvim-dap` | DAP 클라이언트 코어. 디버거와 neovim을 연결 |
| ✅ | `rcarriga/nvim-dap-ui` | DAP UI. 변수, 콜스택, 브레이크포인트 패널 제공 |
| ✅ | `nvim-neotest/nvim-nio` | nvim-dap-ui 비동기 처리 의존성 |
| ✅ | `leoluz/nvim-dap-go` | Go 전용 DAP 설정. delve 디버거 연동 |

---

## UI

| 상태 | 플러그인 | 필요한 이유 |
|---|---|---|
| ✅ | `nvim-lualine/lualine.nvim` | 현재 모드, 파일명, git 브랜치, LSP 진단 수를 하단 상태바에 표시 |
| ✅ | `akinsho/bufferline.nvim` | 열린 버퍼를 상단 탭으로 표시 |
| ✅ | `folke/which-key.nvim` | leader 키 입력 후 사용 가능한 단축키 목록을 팝업으로 표시 |
| ✅ | `akinsho/toggleterm.nvim` | 단축키로 터미널 토글. float/vertical/horizontal 레이아웃 지원 |
| ✅ | `catppuccin/nvim` | 기본 테마. mocha flavour 적용. 파스텔톤 다크 테마 (latte/frappe/macchiato/mocha 4종) |
| ✅ | `projekt0n/github-nvim-theme` | 대체 테마. dark_high_contrast variant. 커스텀 syntax highlight 포함. lazy 로드 |
| ✅ | `rebelot/kanagawa.nvim` | 우키요에 감성의 대체 다크 테마. wave/dragon/lotus variant 지원. lazy 로드(Telescope colorscheme 에서 미리보기) |
| ✅ | `EdenEast/nightfox.nvim` | 여우 컨셉의 대체 테마 모음. nightfox/duskfox/nordfox/terafox/carbonfox/dayfox/dawnfox 7종 variant 지원. lazy 로드 |

---

## 입력기

| 상태 | 플러그인 | 필요한 이유 |
|---|---|---|
| ✅ | `keaising/im-select.nvim` | Normal 모드 진입 시 영문 입력기로 자동 전환 |

---

## AI 통합

| 상태 | 플러그인 | 필요한 이유 |
|---|---|---|
| ✅ | `coder/claudecode.nvim` | Claude Code CLI와 Neovim 통합. WebSocket 기반 MCP로 파일/선택 영역 실시간 공유, diff 확인 |

---

## 총 플러그인 수

| 카테고리 | 전체 | 완료 | 예정 |
|---|---|---|---|
| 플러그인 매니저 | 1 | 1 | 0 |
| LSP / 자동완성 | 7 | 7 | 0 |
| 포매터 / 린터 | 2 | 2 | 0 |
| 문법 하이라이팅 | 1 | 1 | 0 |
| 검색 / 탐색 | 3 | 3 | 0 |
| 파일 탐색기 | 3 | 3 | 0 |
| Git 통합 | 3 | 3 | 0 |
| 편집 보조 | 8 | 7 | 0 |
| 디버깅 | 4 | 4 | 0 |
| UI | 6 | 6 | 0 |
| 입력기 | 1 | 1 | 0 |
| AI 통합 | 1 | 1 | 0 |
| **합계** | **40** | **39** | **0** |

# Neovim 설정 설계

## 디렉토리 구조

```
~/.config/nvim/
├── init.lua                      # 진입점 (모듈 로드만 담당)
├── CLAUDE.md                     # 프로젝트 규칙 및 지침
├── CLAUDE_PLAN.md                # 전체 구현 계획 및 진행 상태
├── CLAUDE_PLUGINS.md             # 플러그인 목록 및 상태
├── CLAUDE_STRUCT.md              # 디렉토리 구조 설계 (현재 파일)
└── lua/
    ├── config/                   # 핵심 설정 (플러그인 무관)
    │   ├── init.lua              # config 모듈 진입점 (하위 모듈 일괄 로드)
    │   ├── options.lua           # vim 기본 옵션 (set 계열)
    │   ├── keymaps.lua           # 모든 단축키 정의 (글로벌 + 플러그인별)
    │   ├── autocmds.lua          # autocommand 정의
    │   └── lazy.lua              # lazy.nvim 부트스트랩 및 plugins/ 자동 스캔
    ├── plugins/                  # 플러그인별 설정 파일 (기능별 디렉토리로 구성)
    │   ├── ai/
    │   │   └── claudecode.lua            # ✅ Claude Code 통합
    │   ├── debug/
    │   │   └── dap.lua                   # ✅ Go 디버깅 (nvim-dap, dap-ui, dap-go)
    │   ├── editor/
    │   │   ├── autopairs.lua             # ✅ 괄호/따옴표 자동 닫기
    │   │   ├── comment.lua               # ✅ 주석 토글 (gcc, gc)
    │   │   ├── indent.lua                # ✅ 들여쓰기 가이드라인 시각화
    │   │   ├── markdown-table.lua        # ✅ Markdown 테이블 자동 정렬
    │   │   ├── render-markdown.lua       # ✅ Markdown 인라인 렌더링
    │   │   ├── todo-comments.lua         # ✅ TODO/FIXME/NOTE 하이라이팅
    │   │   ├── treesitter.lua            # ✅ 문법 하이라이팅 / 코드 파싱
    │   │   └── ufo.lua                   # ✅ 코드 폴딩 (nvim-ufo)
    │   ├── file/
    │   │   └── neo-tree.lua              # ✅ 파일 탐색기 사이드바
    │   ├── git/
    │   │   └── neogit.lua                # ✅ git 통합 (gitsigns, neogit, diffview)
    │   ├── input/
    │   │   └── im-select.lua             # ✅ 입력기 자동 전환 (한/영)
    │   ├── lsp/
    │   │   ├── blink.lua                 # ✅ 자동완성 (blink.cmp + LuaSnip)
    │   │   ├── conform.lua               # ✅ 포매터 (저장 시 자동 실행)
    │   │   ├── lint.lua                  # ✅ 린터 (nvim-lint)
    │   │   ├── lspconfig.lua             # ✅ LSP 공통 설정 (capabilities)
    │   │   ├── mason.lua                 # ✅ LSP 서버 자동 설치
    │   │   └── mason-tool-installer.lua  # ✅ 외부 도구 (린터/포매터) 자동 설치
    │   ├── search/
    │   │   └── telescope.lua             # ✅ 파일/심볼/grep/LSP 검색
    │   └── ui/
    │       ├── bufferline.lua            # ✅ 탭/버퍼 UI
    │       ├── colorscheme.lua           # ✅ 테마 (catppuccin-mocha 기본 + github / kanagawa 대체)
    │       ├── lualine.lua               # ✅ 하단 상태바
    │       ├── toggleterm.lua            # ✅ 터미널 토글
    │       └── which-key.lua             # ✅ 단축키 힌트 팝업
    └── extras/                   # LazyExtras 스타일 언어별 설정
        └── lang/
            ├── go.lua                    # ✅ Go (gopls, gofumpt, goimports)
            ├── python.lua                # ✅ Python (pyright, black, isort)
            ├── lua.lua                   # ✅ Lua (lua_ls, stylua)
            └── ops.lua                   # ✅ YAML/JSON/Bash/Dockerfile/SQL
```

## config/ 파일별 역할 상세

### init.lua (최상위)
- `config` 모듈만 require
- lazy.nvim이 `plugins/`를 자동 스캔하므로 플러그인 개별 require 불필요

### config/init.lua
- `options`, `keymaps`, `autocmds`, `lazy` 순서로 로드
- 순서 중요: options → keymaps → autocmds → lazy (플러그인)

### config/options.lua
- `vim.opt.*` 형태로 작성
- 들여쓰기, 탭, 줄번호, 검색, 클립보드, 마우스 등

### config/keymaps.lua
- `vim.keymap.set()` 형태로 작성
- leader 키 정의 포함 (`vim.g.mapleader`)
- 글로벌 키맵 + 각 플러그인 키맵을 한 곳에 집중 관리

### config/autocmds.lua
- `vim.api.nvim_create_autocmd()` 형태로 작성
- 파일 타입별 들여쓰기, 저장 시 공백 제거, treesitter 자동 활성화 등

### config/lazy.lua
- lazy.nvim 없으면 자동 설치 (부트스트랩)
- `plugins/` 하위 디렉토리를 개별 import하여 플러그인 로드
  (lazy.nvim은 하위 디렉토리를 재귀 탐색하지 않으므로 각 카테고리별 import 필요)
- `extras/lang/` 의 언어별 설정을 개별 import
- 새 플러그인 카테고리 추가 시 `{ import = "plugins.<카테고리>" }` 라인 추가 ��요

## 설계 원칙

- **단일 책임**: 파일 하나가 하나의 역할만 담당
- **지연 로딩**: lazy.nvim의 `event`, `ft`, `cmd` 옵션으로 시작 속도 최적화
- **플러그인 최소화**: 기능별로 1개씩만 선택, 중복 제거
- **단축키 집중 관리**: 모든 단축키는 config/keymaps.lua에서만 관리

## 기술 스택 기반 설계 결정사항

### 자동완성 엔진
- `saghen/blink.cmp` (Rust 기반) 사용 — nvim-cmp 대비 빠르고 메모리 효율적
- 함수 괄호 자동 추가는 blink.cmp의 `auto_brackets` 옵션으로 처리
- 스니펫 엔진: LuaSnip + friendly-snippets

### 언어/파일별 LSP 매핑
| 언어/파일 | LSP 서버 | 포매터 | 린터 |
|---|---|---|---|
| Go | gopls | gofumpt, goimports | gopls 내장 (staticcheck) |
| Python | pyright | black, isort | - |
| SQL | - | sqlfluff | sqlfluff |
| YAML / K8s | yaml-language-server | prettier | - |
| JSON | json-lsp | prettier | - |
| Bash | bash-language-server | shfmt | shellcheck |
| Dockerfile | dockerfile-language-server | - | hadolint |
| Makefile | - (treesitter만) | - | - |

### Kubernetes manifests 특화
- `yaml-language-server`에 kubernetes schema 적용
- `telescope`로 manifest 파일 빠른 탐색

### Go 특화
- `gopls`의 inlay hints 활성화 (타입/파라미터 힌트 표시)
- `nvim-dap` + `nvim-dap-go` + `delve`로 디버깅 지원
- `.env` 파일 자동 로드 (디버깅/테스트 시 환경변수 주입)

### 테마
- catppuccin/nvim (mocha flavour) — 기본값. 파스텔톤 다크. latte/frappe/macchiato/mocha 4종 제공
- github-nvim-theme (dark_high_contrast variant) — 대체 테마. lazy 로드
- kanagawa.nvim (wave / dragon / lotus variant) — 대체 다크 테마. lazy 로드
- github-theme 은 Go 코딩에 맞게 treesitter highlight 커스텀 적용 (변수, 함수, 타입, 키워드 등)
- `<leader>tc`로 telescope에서 실시간 테마 전환 가능 (github/kanagawa 도 이 시점에 자동 로드)

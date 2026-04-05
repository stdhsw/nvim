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
    └── plugins/                  # 플러그인별 설정 파일
        ├── file-neo-tree.lua             # ✅ 파일 탐색기 사이드바
        ├── input-im-select.lua           # ✅ 입력기 자동 전환
        ├── search-telescope.lua          # ✅ 파일/심볼/grep/LSP 검색
        ├── git-neogit.lua                # ✅ git 통합 (gitsigns, neogit, diffview)
        ├── ui-lualine.lua                # ✅ 하단 상태바
        ├── ui-bufferline.lua             # ✅ 탭/버퍼 UI
        ├── ui-which-key.lua              # ✅ 단축키 힌트 팝업
        ├── ui-toggleterm.lua             # ✅ 터미널 토글
        ├── ui-colorscheme.lua            # ✅ 테마 (onedark warmer / kanagawa wave)
        ├── editor-treesitter.lua         # ✅ 문법 하이라이팅 / 코드 파싱
        ├── editor-autopairs.lua          # ✅ 괄호/따옴표 자동 닫기
        ├── editor-comment.lua            # ✅ 주석 토글 (gcc, gc)
        ├── editor-indent.lua             # ✅ 들여쓰기 가이드라인 시각화
        ├── editor-todo-comments.lua      # ✅ TODO/FIXME/NOTE 하이라이팅
        ├── lsp-mason.lua                 # ✅ LSP 서버/포매터/린터 자동 설치
        ├── lsp-lspconfig.lua             # ✅ LSP 서버 설정 (gopls, pyright 등)
        ├── lsp-cmp.lua                   # ✅ 자동완성 (nvim-cmp + LuaSnip)
        ├── lsp-conform.lua               # ✅ 포매터 (저장 시 자동 실행)
        ├── lsp-lint.lua                  # ✅ 린터 (nvim-lint)
        ├── editor-markdown-table.lua     # ✅ Markdown 테이블 자동 정렬
        ├── editor-ufo.lua                # ✅ 코드 폴딩 (nvim-ufo, promise-async)
        └── debug-dap.lua                 # ✅ Go 디버깅 (nvim-dap, dap-ui, dap-go)
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
- `plugins/` 디렉토리 전체를 자동 스캔하여 플러그인 로드

## 설계 원칙

- **단일 책임**: 파일 하나가 하나의 역할만 담당
- **지연 로딩**: lazy.nvim의 `event`, `ft`, `cmd` 옵션으로 시작 속도 최적화
- **플러그인 최소화**: 기능별로 1개씩만 선택, 중복 제거
- **단축키 집중 관리**: 모든 단축키는 config/keymaps.lua에서만 관리

## 기술 스택 기반 설계 결정사항

### 언어/파일별 LSP 매핑
| 언어/파일 | LSP 서버 | 포매터 | 린터 |
|---|---|---|---|
| Go | gopls | gofumpt, goimports | gopls 내장 |
| Python | pyright | black, isort | - |
| SQL | - | sqlfluff | sqlfluff |
| YAML / K8s | yaml-language-server | prettier | - |
| JSON | json-lsp | prettier | - |
| Bash | bash-language-server | shfmt | shellcheck |
| Dockerfile | dockerfile-language-server | - | hadolint |
| Lua | - | stylua | - |
| Makefile | - (treesitter만) | - | - |

### Kubernetes manifests 특화
- `yaml-language-server`에 kubernetes schema 적용
- `telescope`로 manifest 파일 빠른 탐색

### Go 특화
- `gopls`의 inlay hints 활성화 (타입/파라미터 힌트 표시)
- `nvim-dap` + `nvim-dap-go` + `delve`로 디버깅 지원 (예정)

### 테마
- 기본: onedark (warmer variant) — Go 코딩에 맞게 highlight 커스텀 적용
- 보조: kanagawa (wave variant)
- `<leader>tc`로 telescope에서 실시간 테마 전환 가능

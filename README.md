# Neovim 설정 가이드

## 목차

- [사전 준비](#사전-준비)
- [기본 단축키](#기본-단축키)
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
# LSP 서버(pyright, yamlls 등) 설치를 위해 Node.js 설치
brew install node

# Telescope 파일 검색 (필수 - .gitignore 무시 및 숨김 파일 검색)
brew install fd
# Telescope 텍스트 검색 (필수)
brew install ripgrep

# Treesitter 파서 빌드
brew install tree-sitter-cli

# 한/영 입력기 자동 전환
brew install im-select

# Go 디버거 (DAP 디버깅 사용 시)
brew install delve
```

### 포매터 설치

```bash
# Go
go install mvdan.cc/gofumpt@latest
go install golang.org/x/tools/cmd/goimports@latest

# Python
pip install black isort sqlfluff

# YAML / JSON
npm install -g prettier

# Bash
brew install shfmt

# Lua
brew install stylua
```

### 린터 설치 (neovim 시작 후 실행)

```
:MasonInstall shellcheck hadolint
```

---

## 기본 단축키

`<leader>` = `Space`

### 일반 편집

| 단축키      | 설명                 |
|-------------|----------------------|
| `<leader>h` | 검색 하이라이트 해제 |

### Visual 모드 편집

| 단축키 | 모드   | 설명                          |
|--------|--------|-------------------------------|
| `<`    | Visual | 들여쓰기 감소 후 선택 유지    |
| `>`    | Visual | 들여쓰기 증가 후 선택 유지    |
| `p`    | Visual | 레지스터 유지하며 붙여넣기    |

### 대소문자 변환

| 단축키       | 모드   | 설명                    |
|--------------|--------|-------------------------|
| `<leader>uu` | Normal | 단어 대문자로 변환      |
| `<leader>ul` | Normal | 단어 소문자로 변환      |
| `<leader>u~` | Normal | 단어 대소문자 토글      |
| `<leader>uu` | Visual | 선택 영역 대문자로 변환 |
| `<leader>ul` | Visual | 선택 영역 소문자로 변환 |

### 창 이동 / 크기 조절

| 단축키      | 설명               |
|-------------|--------------------|
| `<C-h>`     | 왼쪽 창으로 이동   |
| `<C-j>`     | 아래 창으로 이동   |
| `<C-k>`     | 위 창으로 이동     |
| `<C-l>`     | 오른쪽 창으로 이동 |
| `<M-Up>`    | 창 높이 증가       |
| `<M-Down>`  | 창 높이 감소       |
| `<M-Left>`  | 창 너비 감소       |
| `<M-Right>` | 창 너비 증가       |

### 터미널

| 단축키       | 모드     | 설명                    |
|--------------|----------|-------------------------|
| `<C-\>`      | Normal   | 터미널 토글 (기본)      |
| `<Esc><Esc>` | Terminal | 터미널 노멀 모드로 전환 |

---

## 플러그인 목록

---

### 플러그인 매니저

#### folke/lazy.nvim

플러그인 설치 / 업데이트 / 삭제를 관리하며, 지연 로딩으로 시작 속도를 최적화합니다.

| 명령어         | 설명                                |
|----------------|-------------------------------------|
| `:Lazy`        | 플러그인 관리 GUI 열기              |
| `:Lazy update` | 플러그인 전체 업데이트              |
| `:Lazy sync`   | 설치 / 업데이트 / 정리 한 번에 실행 |

---

### LSP / 자동완성

#### williamboman/mason.nvim

LSP 서버, 포매터, 린터를 neovim 안에서 설치 / 관리합니다.
설치된 바이너리는 `~/.local/share/nvim/mason/bin/`에 저장됩니다.

**자동 설치 LSP 서버**

| 서버       | 언어              |
|------------|-------------------|
| `gopls`    | Go                |
| `pyright`  | Python            |
| `yamlls`   | YAML / Kubernetes |
| `jsonls`   | JSON              |
| `bashls`   | Bash              |
| `dockerls` | Dockerfile        |

| 명령어                     | 설명                        |
|----------------------------|-----------------------------|
| `:Mason`                   | GUI로 설치 목록 관리        |
| `:MasonInstall <패키지>`   | 패키지 설치                 |
| `:MasonUninstall <패키지>` | 패키지 삭제                 |
| `:MasonUpdate`             | 설치된 패키지 전체 업데이트 |

---

#### neovim/nvim-lspconfig

LSP 서버와 neovim을 연결합니다. 코드 진단, 정의 이동, 참조 찾기 등 IDE 기능의 핵심입니다.

| 명령어        | 설명                                |
|---------------|-------------------------------------|
| `:LspInfo`    | 현재 버퍼의 LSP 서버 연결 상태 확인 |
| `:LspRestart` | LSP 서버 재시작                     |
| `:LspLog`     | LSP 로그 확인                       |

| 단축키       | 설명                                  |
|--------------|---------------------------------------|
| `gd`         | 정의로 이동                           |
| `gD`         | 선언으로 이동                         |
| `gi`         | 구현으로 이동                         |
| `gr`         | 참조 찾기                             |
| `K`          | hover 문서 표시                       |
| `<leader>lk` | 함수 시그니처 표시                    |
| `<leader>lr` | 이름 변경 (rename)                    |
| `<leader>la` | 코드 액션 (자동 수정, import 추가 등) |
| `<leader>ld` | 진단 상세 메시지 팝업                 |
| `<leader>lf` | 포맷 실행                             |
| `]d`         | 다음 진단으로 이동                    |
| `[d`         | 이전 진단으로 이동                    |

---

#### hrsh7th/nvim-cmp

LSP, 스니펫, 버퍼, 경로를 통합하는 자동완성 엔진입니다.
팝업 우측에 소스 출처(`[LSP]`, `[Snip]`, `[Buf]`, `[Path]`)가 표시됩니다.

| 단축키    | 설명                                     |
|-----------|------------------------------------------|
| `<C-n>`   | 다음 항목 선택                           |
| `<C-p>`   | 이전 항목 선택                           |
| `<C-y>`   | 현재 항목 바로 확정                      |
| `<C-e>`   | 자동완성 창 닫기                         |
| `<CR>`    | 선택 항목 확정 (명시적 선택만)           |
| `<Tab>`   | 다음 항목 선택 / 스니펫 다음 위치로 이동 |
| `<S-Tab>` | 이전 항목 선택 / 스니펫 이전 위치로 이동 |

---

### 포매터 / 린터

#### stevearc/conform.nvim

파일 저장 시 자동으로 포매터를 실행합니다.

**적용 포매터**

| 언어   | 포매터              |
|--------|---------------------|
| Go     | gofumpt → goimports |
| Python | black → isort       |
| YAML   | prettier            |
| JSON   | prettier            |
| Bash   | shfmt               |
| SQL    | sqlfluff            |
| Lua    | stylua              |

| 명령어 / 단축키 | 설명                             |
|-----------------|----------------------------------|
| `:ConformInfo`  | 현재 버퍼에 적용되는 포매터 확인 |
| `<leader>lf`    | 현재 파일 수동 포맷              |

---

#### mfussenegger/nvim-lint

LSP가 지원하지 않는 외부 린터를 통합 관리합니다.

**적용 린터**

| 언어         | 린터       |
|--------------|------------|
| Bash / Shell | shellcheck |
| Dockerfile   | hadolint   |

파일 열기 및 저장 시 자동으로 실행됩니다. 진단 결과는 `]d` / `[d` / `<leader>ld`로 확인할 수 있습니다.

---

### 문법 하이라이팅

#### nvim-treesitter/nvim-treesitter

AST 기반으로 정확한 문법 하이라이팅, 코드 폴딩, 들여쓰기를 제공합니다.

**자동 설치 파서**: `go`, `python`, `lua`, `sql`, `yaml`, `json`, `bash`, `dockerfile`, `make`, `vim`, `vimdoc`, `markdown`, `markdown_inline`

| 명령어                         | 설명                      |
|--------------------------------|---------------------------|
| `:TSInstall <언어>`            | 특정 언어 파서 수동 설치  |
| `:TSUpdate`                    | 설치된 파서 전체 업데이트 |
| `:checkhealth nvim-treesitter` | 파서 설치 상태 확인       |
| `:InspectTree`                 | 현재 버퍼의 AST 구조 확인 |

| 단축키 | 설명             |
|--------|------------------|
| `zc`   | 현재 블록 접기   |
| `zo`   | 현재 블록 펼치기 |
| `za`   | 현재 블록 토글   |

---

### 검색 / 탐색

#### nvim-telescope/telescope.nvim

파일, 코드, Git 이력, LSP 심볼 등 모든 것을 퍼지 검색으로 찾습니다.

| 단축키       | 설명                           |
|--------------|--------------------------------|
| `<leader>ff` | 파일 찾기                      |
| `<leader>fg` | 텍스트 실시간 검색 (live grep) |
| `<leader>fb` | 열린 버퍼 목록                 |
| `<leader>fr` | 최근 파일 목록                 |
| `<leader>fh` | 도움말 검색                    |
| `<leader>ft` | 프로젝트 전체 TODO 검색        |
| `<leader>ks` | 등록된 단축키 검색             |
| `<leader>tc` | 테마 선택                      |

**telescope 창 내부 단축키**

| 단축키            | 설명                          |
|-------------------|-------------------------------|
| `<C-n>` / `<C-p>` | 다음 / 이전 결과로 이동       |
| `<C-x>`           | 수평 분할로 파일 열기         |
| `<C-v>`           | 수직 분할로 파일 열기         |
| `<C-t>`           | 새 탭으로 파일 열기           |
| `<C-q>`           | 결과를 quickfix 목록으로 전송 |
| `<Tab>`           | 다중 선택 토글                |
| `<Esc>`           | 닫기                          |

---

### 파일 탐색기

#### nvim-neo-tree/neo-tree.nvim

프로젝트 디렉토리 구조를 트리 형태로 사이드바에 표시합니다.

| 단축키       | 설명                             |
|--------------|----------------------------------|
| `<leader>ee` | 파일 탐색기 열기 / 닫기          |
| `<leader>E`  | 파일 탐색기 포커스               |
| `<leader>er` | 현재 파일 위치를 탐색기에서 표시 |
| `<leader>ge` | Git 상태 탐색기 토글             |

**탐색기 창 내부 단축키**

| 단축키       | 설명                        |
|--------------|-----------------------------|
| `<CR>` / `o` | 파일 열기 / 디렉토리 펼치기 |
| `S`          | 수직 분할로 파일 열기       |
| `s`          | 수평 분할로 파일 열기       |
| `a`          | 파일 / 디렉토리 생성        |
| `d`          | 파일 / 디렉토리 삭제        |
| `r`          | 이름 변경                   |
| `y`          | 파일 경로 복사              |
| `c`          | 파일 복사                   |
| `m`          | 파일 이동                   |
| `R`          | 디렉토리 새로고침           |
| `H`          | 숨김 파일 표시 / 숨김 토글  |
| `E`          | 모든 디렉토리 펼치기        |
| `C`          | 모든 디렉토리 접기          |
| `q`          | 탐색기 닫기                 |

---

### Git 통합

#### lewis6991/gitsigns.nvim

에디터 좌측 gutter에 변경된 라인을 표시하고, hunk 단위로 조작합니다.

| 단축키       | 설명                   |
|--------------|------------------------|
| `]h`         | 다음 hunk로 이동       |
| `[h`         | 이전 hunk로 이동       |
| `<leader>gp` | hunk 변경사항 미리보기 |
| `<leader>gb` | 현재 줄 git blame 토글 |

---

#### NeogitOrg/neogit

neovim 안에서 git add, commit, push, pull 등 전체 워크플로우를 처리합니다.

| 단축키       | 설명        |
|--------------|-------------|
| `<leader>gs` | neogit 열기 |

**neogit 창 내부 단축키**

| 단축키 | 설명                     |
|--------|--------------------------|
| `s`    | 파일 stage               |
| `u`    | 파일 unstage             |
| `cc`   | 커밋 메시지 작성 후 커밋 |
| `Pp`   | push                     |
| `Fl`   | pull                     |
| `d`    | diffview로 변경사항 보기 |

---

#### sindrets/diffview.nvim

파일 변경사항을 좌우 분할 화면으로 비교합니다.

| 단축키       | 설명          |
|--------------|---------------|
| `<leader>gd` | diffview 열기 |
| `<leader>gD` | diffview 닫기 |

---

### 편집 보조

#### windwp/nvim-autopairs

괄호, 따옴표 등을 입력하면 닫는 쌍을 자동으로 추가합니다.
Insert 모드에서 자동으로 동작합니다.

| 동작         | 결과                             |
|--------------|----------------------------------|
| `(` 입력     | `()` — 커서가 가운데 위치        |
| `"` 입력     | `""`                             |
| `{` 입력     | `{}`                             |
| `(` + `<CR>` | 자동 들여쓰기와 함께 괄호 펼쳐짐 |

---

#### numToStr/Comment.nvim

단축키 하나로 코드 주석을 토글합니다. 언어별 주석 문법을 자동으로 감지합니다.

| 단축키 | 모드   | 설명                            |
|--------|--------|---------------------------------|
| `gcc`  | Normal | 현재 줄 주석 토글               |
| `gbc`  | Normal | 현재 줄 블록 주석 토글          |
| `gc3j` | Normal | 현재 줄 포함 아래 3줄 주석 토글 |
| `gcip` | Normal | 현재 단락 주석 토글             |
| `gc`   | Visual | 선택 영역 줄 주석 토글          |
| `gb`   | Visual | 선택 영역 블록 주석 토글        |

---

#### lukas-reineke/indent-blankline.nvim

들여쓰기 레벨을 수직선(`│`)으로 시각화합니다. 현재 커서가 위치한 스코프를 강조 표시합니다.
파일을 열면 자동으로 표시됩니다.

---

#### folke/todo-comments.nvim

코드 내 특수 키워드를 색상으로 하이라이팅합니다.

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

| 단축키 / 명령어                      | 설명                    |
|--------------------------------------|-------------------------|
| `]t`                                 | 다음 TODO로 이동        |
| `[t`                                 | 이전 TODO로 이동        |
| `<leader>ft`                         | 프로젝트 전체 TODO 검색 |
| `:TodoTelescope keywords=TODO,FIXME` | 특정 키워드만 필터링    |

---

#### dhruvasagar/vim-table-mode

Markdown 테이블을 저장 시 자동으로 정렬합니다.
`.md` 파일 저장 시 파일 내 모든 테이블이 자동으로 재정렬됩니다.

---

#### MeanderingProgrammer/render-markdown.nvim

neovim 버퍼 내에서 Markdown을 직접 렌더링합니다.
헤더, 코드블록, 체크박스, 테이블, 인용구 등을 아이콘과 색상으로 표현합니다.

| 단축키       | 설명                 |
|--------------|----------------------|
| `<leader>mr` | Markdown 렌더링 토글 |

---

#### kevinhwang91/nvim-ufo

LSP + treesitter 기반의 코드 폴딩 플러그인.
접힌 줄 수와 미리보기를 제공합니다.

| 단축키       | 설명                    |
|--------------|-------------------------|
| `zR`         | 파일 내 모든 fold 열기  |
| `zM`         | 파일 내 모든 fold 닫기  |
| `za`         | 현재 fold 토글          |
| `zo`         | 현재 fold 열기          |
| `zc`         | 현재 fold 닫기          |
| `<leader>zp` | 접힌 블록 내용 미리보기 |

---

### 디버깅

#### mfussenegger/nvim-dap + rcarriga/nvim-dap-ui + leoluz/nvim-dap-go

DAP(Debug Adapter Protocol) 기반 Go 디버깅 환경입니다.
디버깅 시작 시 UI가 자동으로 열리고, 종료 시 자동으로 닫힙니다.

| 단축키       | 설명                                            |
|--------------|-------------------------------------------------|
| `<F5>`       | 디버깅 시작 / 다음 브레이크포인트까지 계속 실행 |
| `<F6>`       | 디버깅 종료                                     |
| `<F7>`       | DAP UI 패널 토글                                |
| `<F8>`       | 조건부 브레이크포인트 설정 (조건식 입력 후 Enter) |
| `<F9>`       | 브레이크포인트 토글                             |
| `<F10>`      | Step Over (다음 줄, 함수 진입 안 함)            |
| `<F11>`      | Step Into (함수 내부로 진입)                    |
| `<F12>`      | Step Out (현재 함수에서 빠져나오기)             |
| `<leader>dt` | 커서 위치의 Go 테스트 함수 디버깅               |

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

### UI

#### akinsho/bufferline.nvim

열린 버퍼를 상단 탭 형태로 표시합니다.
LSP 진단 아이콘이 탭에 함께 표시됩니다.

| 단축키       | 설명                           |
|--------------|--------------------------------|
| `<S-h>`      | 이전 버퍼로 이동               |
| `<S-l>`      | 다음 버퍼로 이동               |
| `<leader>w`  | 현재 버퍼 닫기                 |
| `<leader>bp` | 알파벳 키로 버퍼 선택해서 이동 |
| `<leader>bc` | 알파벳 키로 버퍼 선택해서 닫기 |

---

#### nvim-lualine/lualine.nvim

하단 상태바 플러그인. 창이 여러 개여도 상태바는 하단에 하나만 표시됩니다.

**상태바 구성**

```
[모드] [git 브랜치 + diff] [파일명] [LSP 진단]       [파일타입] [진행률%] [줄:열]
```

---

#### folke/which-key.nvim

`<leader>` 키 입력 후 잠시 기다리면 사용 가능한 단축키 목록을 팝업으로 표시합니다.

**단축키 그룹**

| Prefix      | 그룹   |
|-------------|--------|
| `<leader>b` | 버퍼   |
| `<leader>g` | Git    |
| `<leader>f` | 찾기   |
| `<leader>l` | LSP    |
| `<leader>t` | 터미널 |

| 단축키                 | 설명                |
|------------------------|---------------------|
| `<Space>` (500ms 대기) | which-key 팝업 표시 |
| `:WhichKey`            | 전체 키맵 목록 표시 |
| `<leader>ks`           | 전체 키맵 검색      |

---

#### akinsho/toggleterm.nvim

단축키로 터미널을 열고 닫습니다. float, horizontal, vertical 레이아웃을 지원합니다.

| 단축키       | 설명              |
|--------------|-------------------|
| `<leader>tf` | float 터미널 토글 |
| `<leader>t1` | 1번 터미널 토글   |
| `<leader>t2` | 2번 터미널 토글   |
| `<leader>t3` | 3번 터미널 토글   |

---

#### navarasu/onedark.nvim + rebelot/kanagawa.nvim

기본 테마는 `onedark warmer`가 적용됩니다.

| 명령어 / 단축키         | 설명                        |
|-------------------------|-----------------------------|
| `<leader>tc`            | 테마 선택 (실시간 미리보기) |
| `:colorscheme onedark`  | onedark 테마 적용           |
| `:colorscheme kanagawa` | kanagawa 테마 적용          |

---

### 입력기

#### keaising/im-select.nvim

모드 전환 시 입력기를 자동으로 영어로 전환합니다.

- Insert 모드 탈출 → 영어 입력기로 자동 전환
- Insert 모드 진입 → 이전 입력기 상태로 자동 복원

별도 조작 없이 자동으로 동작합니다.

---

### AI

#### coder/claudecode.nvim

Claude Code CLI와 Neovim을 연결하는 공식 IDE 통합 플러그인.
WebSocket 기반 MCP(Model Context Protocol)로 현재 편집 중인 파일과 선택 영역을 Claude가 실시간으로 인식합니다.

**사전 요구사항**

```bash
npm install -g @anthropic-ai/claude-code
```

| 단축키       | 모드   | 설명                         |
|--------------|--------|------------------------------|
| `<leader>ac` | Normal | Claude 터미널 토글           |
| `<leader>af` | Normal | Claude 터미널 포커스         |
| `<leader>as` | Visual | 선택 영역 Claude에 전송      |
| `<leader>aa` | Normal | 현재 파일 Claude 컨텍스트 추가 |
| `<leader>ay` | Normal | Claude 제안 변경사항 수락 (Yes) |
| `<leader>an` | Normal | Claude 제안 변경사항 거절 (No)  |

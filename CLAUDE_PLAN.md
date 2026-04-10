# Neovim 설정 최적화 계획

현재 neovim 설정을 검토한 결과를 우선순위별로 정리한 작업 계획.

---

## 우선순위 높음 (버그 / Deprecated / 명백한 오류)

### 1.1 `vim.diagnostic.goto_next/prev` deprecated ✅
- **위치**: `lua/config/keymaps.lua:106-107`
- **문제**: nvim 0.11+에서 `vim.diagnostic.jump({count = N, float = true})` 형식으로 변경됨. 0.12에서 경고 출력 가능
- **조치**:
  - `]d` → `vim.diagnostic.jump({ count = 1, float = true })`
  - `[d` → `vim.diagnostic.jump({ count = -1, float = true })`

### 1.2 `mason-lspconfig`의 `automatic_installation` deprecated ✅
- **위치**: `lua/plugins/lsp/mason.lua:53`
- **문제**: 최신 mason-lspconfig는 `automatic_installation`을 제거함. `ensure_installed`만 사용해야 함
- **조치**: `automatic_installation = true` 라인 제거

### 1.3 `trim_whitespace` autocmd가 markdown line-break를 파괴 ✅
- **위치**: `lua/config/autocmds.lua:73-81`
- **문제**: `pattern = "*"`이라 markdown의 의도적인 trailing 2-space(줄바꿈)를 제거함
- **조치**: pattern에서 markdown 제외 또는 callback 안에서 `vim.bo.filetype ~= "markdown"` 가드 추가

### 1.4 `im-select` 중복 처리 ✅
- **위치**: `lua/config/autocmds.lua:88-105` + `lua/plugins/input/im-select.lua`
- **문제**: 플러그인 자체가 `InsertLeave/CmdlineLeave`에서 영문 전환을 이미 수행하는데, autocmds.lua에서 `FocusGained`/`ModeChanged`로 동기 `vim.fn.system("im-select ...")`을 또 호출 → 중복 + 미세 lag
- **조치**: 플러그인이 처리하지 않는 영역(터미널 모드 탈출)만 남기고 `FocusGained`는 제거 검토

### 1.5 LSP 진단 sign 아이콘 미설정 ✅
- **위치**: `lua/config/options.lua:73-84`
- **문제**: `signs = true`만으로는 실제 sign 아이콘이 표시되지 않음 (nvim 0.10+)
- **조치**:
  ```lua
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN]  = " ",
      [vim.diagnostic.severity.INFO]  = " ",
      [vim.diagnostic.severity.HINT]  = " ",
    },
  }
  ```

---

## 우선순위 중간 (UX / 일관성)

### 2.1 `lualine` 테마 미스매치 ✅
- **위치**: `lua/plugins/ui/lualine.lua:33`
- **문제**: colorscheme은 `github_dark_high_contrast`인데 lualine은 `powerline_dark` → 색상 톤 어긋남
- **조치**: `theme = "auto"`로 변경하여 colorscheme에 자동 동기화

### 2.2 `markdown-table`의 BufWritePre가 무겁고 trim_whitespace와 충돌 가능 ✅
- **위치**: `lua/plugins/editor/markdown-table.lua:78-110`
- **문제**:
  - 모든 .md 파일 저장 시 전체 테이블을 순회+재정렬 → 큰 노트에서 lag
  - `trim_whitespace`(autocmds.lua)와 같은 BufWritePre에서 실행되어 순서에 따라 결과 차이 발생 가능
- **조치**: `<leader>mf` 같은 단축키로 수동 정렬로 전환하거나, 변경된 테이블 영역만 선택적으로 정렬

### 2.3 `bufferline` 로딩 타이밍 ✅
- **위치**: `lua/plugins/ui/bufferline.lua:28`
- **문제**: `event = "VeryLazy"`라 첫 buffer가 그려진 직후 잠깐 깜빡일 수 있음
- **조치**: `event = { "BufReadPost", "BufNewFile" }`로 변경 (lualine은 VeryLazy 유지 OK)

### 2.4 `<leader>w` 키 충돌 가능성 ⏭️ (사용자 요청으로 변경 보류)
- **위치**: `lua/config/keymaps.lua:94-101`
- **문제**: which-key spec에 `<leader>w` 그룹은 없는데 keymaps.lua에서 단일 키로 사용 → 다른 그룹과 모양이 달라 직관성 저하
- **조치**: `<leader>bd`(buffer delete)로 이동 — 이미 `<leader>b` 그룹이 정의됨

### 2.5 `disabled_plugins`에서 `matchparen` 비활성화 ✅
- **위치**: `lua/config/lazy.lua:90-99`
- **문제**: 짝괄호 시각화가 사라짐. autopairs는 입력 보조만 하고 시각화 기능은 없음
- **조치**: 의도적이 아니라면 `matchparen`는 disabled_plugins에서 제거

### 2.6 `format_on_save` 동기 실행 ✅ (timeout 1000ms 로 증가)
- **위치**: `lua/plugins/lsp/conform.lua:26-29`
- **문제**: `timeout_ms = 500`은 OK이나 큰 Go 파일에서 gofumpt + goimports 동기 실행이 체감될 수 있음
- **조치**: `format_after_save`(BufWritePost, async)로 변경 검토 — 단점은 저장 직후 잠깐 unformatted가 보일 수 있음

---

## 우선순위 낮음 (튜닝 / 정리)

### 3.1 `nvim-lint`의 autocmd 중복 ✅
- **위치**: `lua/plugins/lsp/lint.lua:23, 32-36`
- **문제**: 플러그인 spec의 `event`와 config 안의 autocmd가 같은 이벤트를 사용 (event는 lazy 트리거이므로 동작은 OK)
- **조치**: 의도가 분명하도록 둘 중 하나로 정리

### 3.2 `treesitter` 설정 단순화 ✅
- **위치**: `lua/plugins/editor/treesitter.lua:65-69`
- **문제**: 모든 FileType마다 `pcall(vim.treesitter.start, ...)` 호출. 0.12 nvim-treesitter 새 API는 자동 attach 지원이 있을 수 있음
- **조치**: 공식 README 재확인 후 단순화 가능 여부 검토

### 3.3 `lazy.nvim` 자동 업데이트 체크 ✅
- **위치**: `lua/config/lazy.lua:80-83`
- **문제**: `checker.enabled = true`로 백그라운드 git fetch 수행. 알림이 비활성화돼 있어 사실상 효용 적음
- **조치**: 주 1회 수동 `:Lazy sync` 운영이라면 `enabled = false` 권장

### 3.4 `restore_cursor` autocmd 보완 ✅
- **위치**: `lua/config/autocmds.lua:44-53`
- **문제**: gitcommit, help, quickfix 같은 buftype에선 마지막 위치 복원이 부적절
- **조치**: `vim.bo.filetype ~= "gitcommit"` 등의 가드 추가

### 3.5 shellcheck/hadolint 자동 설치 ✅
- **위치**: `lua/extras/lang/ops.lua`
- **문제**: 주석에 "수동 설치 필요"로 안내 — 신규 환경 셋업이 번거로움
- **조치**: `WhoIsSethDaniel/mason-tool-installer.nvim` 추가하면 린터/포매터도 `ensure_installed`로 일괄 자동 설치 가능

### 3.6 `opt.encoding` / `opt.fileencoding` redundant ✅
- **위치**: `lua/config/options.lua:90-91`
- **문제**: 둘 다 utf-8이 nvim 기본값
- **조치**: 명시 자체에 해는 없으므로 정리할지 유지할지는 선택

### 3.7 claudecode `port_range` 너무 넓음 ✅
- **위치**: `lua/plugins/ai/claudecode.lua:59`
- **문제**: `{ min = 10000, max = 65535 }`로 너무 넓음
- **조치**: `40000~41000` 같은 좁은 범위로 변경 권장

---

## 잘 되어 있는 부분 (유지)

- `keymaps.lua`의 `lazy_require` 캐싱 패턴 — 깔끔하고 효율적
- `extras/lang/*.lua`의 LazyVim 스타일 opts function 주입 — 확장성 우수
- `dap.lua`의 `dap.run` override로 .env 자동 주입 — 영리한 구현
- `lspconfig.lua`의 0.11+ `vim.lsp.config`/`vim.lsp.enable` API 채택 — 최신 모범 사례
- `blink.cmp` 도입과 키맵 명시화 — 설정 의도가 분명
- 카테고리별 디렉토리 + 파일명 prefix 규칙 — 유지보수성 우수

---

## 추천 적용 순서

즉효성 높은 5가지를 우선 처리:

1. **1.1** `vim.diagnostic.jump`로 마이그레이션 (deprecated 경고 제거)
2. **1.2** `mason-lspconfig`의 `automatic_installation` 제거
3. **1.3** `trim_whitespace`에서 markdown 제외
4. **1.4** im-select 중복 autocmd 정리
5. **2.1** lualine 테마 `auto`로 변경

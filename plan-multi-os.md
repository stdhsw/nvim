# Neovim 설정 크로스플랫폼화 작업 계획 (macOS / Linux / WSL Ubuntu)

> 본 문서는 현재 macOS + iTerm2 전제로 작성된 `~/.config/nvim` 설정을
> **동일 dotfiles 로 macOS / Linux / WSL Ubuntu 세 환경에서 사용 가능**하게
> 만드는 작업 계획입니다. 모든 변경은 최소 침습적이며, macOS 동작은
> 현재와 동일하게 유지됩니다.

---

## 1. Context (왜 하는가)

- 현재 설정은 `brew`, `osascript`, `iTerm2`, `im-select` (macOS 전용 CLI) 에 강하게 의존.
- 사용자는 Linux 및 WSL Ubuntu 환경에서도 같은 설정을 사용하고 싶어함.
- 조사 결과 **macOS 전용 코드는 3개 파일로 국한**되고, 나머지(LSP/Mason, Telescope, Treesitter, DAP, clipboard)는 이미 크로스플랫폼이다.
- 따라서 **플랫폼 감지 헬퍼 + 조건부 로드 + README 분리** 전략으로 해결.

## 2. 사용자 결정사항 (확정)

| 항목 | 결정 |
|---|---|
| im-select (한/영 자동 전환) | **macOS 에서만 활성화**. Linux/WSL 은 비활성. |
| Claude Code 터미널 | **macOS**: 기존 외부 iTerm2 유지. **Linux/WSL**: Neovim 내부 split (`native` provider). |
| README 구조 | **OS 별 섹션 분리** (macOS / Ubuntu·WSL 두 섹션). |

## 3. 작업 후 기능별 동작 매트릭스

| 기능 | macOS | Linux | WSL Ubuntu |
|---|---|---|---|
| LSP · Mason · 포매터 · 린터 | ✅ | ✅ | ✅ |
| Telescope · Treesitter · Neo-tree | ✅ | ✅ | ✅ |
| Go DAP (delve) | ✅ | ✅ | ✅ |
| Git (neogit) | ✅ | ✅ | ✅ |
| 시스템 클립보드 | ✅ (자동) | ⚠ `xclip`/`wl-clipboard` 필요 | ⚠ `win32yank` 권장 |
| Nerd Font 아이콘 | ✅ | ⚠ 터미널에 Nerd Font 설치 필요 | ⚠ Windows Terminal 에 Nerd Font 설치 필요 |
| 한/영 입력기 자동 전환 | ✅ | ❌ (의도적 비활성) | ❌ (의도적 비활성) |
| Claude Code 터미널 | ✅ 외부 iTerm2 창 | ✅ 내부 split | ✅ 내부 split |

---

## 4. 변경 대상 파일 총괄표

| # | 파일 | 변경 유형 | 난이도 |
|---|---|---|---|
| 1 | `lua/config/platform.lua` | 신규 생성 | 하 |
| 2 | `lua/config/init.lua` | 로드 순서 추가 | 하 |
| 3 | `lua/plugins/input/im-select.lua` | `cond` 추가 | 하 |
| 4 | `lua/config/autocmds.lua` | macOS 조건부 분기 | 하 |
| 5 | `lua/plugins/ai/claudecode.lua` | 터미널 provider 분기 | 중 |
| 6 | `README.md` | OS 별 섹션 분리 | 중 |
| 7 | `CLAUDE.md` | 환경 정보 업데이트 | 하 |
| 8 | `CLAUDE.STRUCT.md` | `platform.lua` 추가 반영 | 하 |

---

## 5. 파일별 상세 변경 내역

### 5.1. `lua/config/platform.lua` — **신규 생성**

플랫폼 감지 헬퍼. 다른 파일에서 `require("config.platform")` 로 재사용.

**전체 내용:**

```lua
-- ============================================================================
-- 파일명: config/platform.lua
--
-- 설명:
--   현재 실행 중인 OS/환경을 감지하여 불리언 플래그로 제공한다.
--   각 플러그인/autocmd 에서 플랫폼별 동작을 분기할 때 사용한다.
--
-- 사용법:
--   local platform = require("config.platform")
--   if platform.is_mac then ... end
--   if platform.is_wsl then ... end
-- ============================================================================

local M = {}

local uname = vim.uv.os_uname()

M.sysname = uname.sysname
M.is_mac = uname.sysname == "Darwin"
M.is_linux = uname.sysname == "Linux"
M.is_windows = uname.sysname:match("Windows") ~= nil

-- WSL 감지: /proc/sys/kernel/osrelease 에 "microsoft" 문자열 포함
-- 또는 WSL_DISTRO_NAME 환경변수 존재 (WSL2 기본 설정)
M.is_wsl = M.is_linux
	and (
		(uname.release or ""):lower():find("microsoft") ~= nil
		or vim.env.WSL_DISTRO_NAME ~= nil
	)

M.is_unix = M.is_mac or M.is_linux

return M
```

**핵심 포인트:**
- `vim.uv.os_uname()` 는 Neovim 0.10+ 에서 `vim.loop.os_uname()` 의 별칭. (사용자 환경 nvim 0.12 → 안전)
- WSL 감지 로직은 Microsoft 공식 권장 방식(`osrelease` 검사 + `WSL_DISTRO_NAME`).
- `M.is_unix = M.is_mac or M.is_linux` — macOS 도 유닉스 계열임을 표시.

---

### 5.2. `lua/config/init.lua` — **로드 순서 추가**

`platform` 모듈을 가장 먼저 로드해야 다른 모듈이 참조 가능.

**변경 전** (추정):
```lua
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
```

**변경 후:**
```lua
require("config.platform")  -- 가장 먼저: 이후 모듈에서 플랫폼 분기용으로 참조
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
```

> **주의**: 실제 현재 `config/init.lua` 내용을 먼저 확인 후 적용할 것. 이 문서 작성 시점에는 직접 읽지 않았음.

---

### 5.3. `lua/plugins/input/im-select.lua` — **`cond` 추가**

macOS 외 플랫폼에서는 플러그인 자체가 로드되지 않도록 lazy.nvim 의 `cond` 필드 활용.

**변경 전** (line 29~):
```lua
return {
	"keaising/im-select.nvim",
	lazy = false,
	config = function()
		require("im_select").setup({
			default_im_select = "com.apple.keylayout.ABC",
			default_command = "im-select",
			set_previous_events = { "InsertEnter" },
			set_default_events = { "InsertLeave", "CmdlineLeave", "FocusGained" },
		})
	end,
}
```

**변경 후:**
```lua
return {
	"keaising/im-select.nvim",
	-- macOS 전용: Linux/WSL 에서는 im-select CLI 가 없으므로 비활성
	cond = function()
		return require("config.platform").is_mac
	end,
	lazy = false,
	config = function()
		require("im_select").setup({
			default_im_select = "com.apple.keylayout.ABC",
			default_command = "im-select",
			set_previous_events = { "InsertEnter" },
			set_default_events = { "InsertLeave", "CmdlineLeave", "FocusGained" },
		})
	end,
}
```

**주석 블록 업데이트 (파일 상단 line 13-16):**
```lua
-- 사전 요구사항:
--   macOS: brew install im-select
--   Linux/WSL: 지원하지 않음 (플러그인 자동 비활성)
```

---

### 5.4. `lua/config/autocmds.lua` — **macOS 조건부 분기**

`im_select_terminal` autocmd (line 105-111) 를 macOS 에서만 등록.

**변경 전 (line 101-111):**
```lua
-- im-select (터미널 모드 탈출 시 영어 입력기 자동 전환)
-- Claude 터미널 등에서 ESC/<C-\><C-n>으로 노말 모드 전환 시 영어로 자동 전환
-- InsertLeave는 터미널 모드에서 발생하지 않으므로 ModeChanged 이벤트 사용
-- (InsertLeave/CmdlineLeave/FocusGained 는 im-select.nvim 플러그인이 직접 처리)
autocmd("ModeChanged", {
	group = augroup("im_select_terminal", { clear = true }),
	pattern = "t:*",
	callback = function()
		vim.fn.system("im-select com.apple.keylayout.ABC")
	end,
})
```

**변경 후:**
```lua
-- im-select (터미널 모드 탈출 시 영어 입력기 자동 전환) — macOS 전용
-- Claude 터미널 등에서 ESC/<C-\><C-n>으로 노말 모드 전환 시 영어로 자동 전환
-- InsertLeave는 터미널 모드에서 발생하지 않으므로 ModeChanged 이벤트 사용
-- (InsertLeave/CmdlineLeave/FocusGained 는 im-select.nvim 플러그인이 직접 처리)
if require("config.platform").is_mac then
	autocmd("ModeChanged", {
		group = augroup("im_select_terminal", { clear = true }),
		pattern = "t:*",
		callback = function()
			vim.fn.system("im-select com.apple.keylayout.ABC")
		end,
	})
end
```

---

### 5.5. `lua/plugins/ai/claudecode.lua` — **터미널 provider 분기**

`terminal` 필드를 플랫폼에 따라 `external` (macOS/iTerm2) 또는 `native` (내부 split) 로 분기.

**변경 전 (line 101-133):**
```lua
terminal = {
	provider = "external",
	provider_opts = {
		external_terminal_cmd = function(cmd_string, env_table)
			local cwd = vim.fn.getcwd()
			local parts = {}
			for k, v in pairs(env_table) do
				table.insert(parts, string.format("export %s=%s", k, vim.fn.shellescape(v)))
			end
			table.insert(parts, string.format("cd %s", vim.fn.shellescape(cwd)))
			table.insert(parts, cmd_string)
			local shell_cmd = table.concat(parts, "; ")

			local applescript = string.format(
				'tell application "iTerm"\n'
					.. "  activate\n"
					.. "  set newWindow to (create window with default profile)\n"
					.. "  tell current session of newWindow to write text %q\n"
					.. "end tell",
				shell_cmd
			)
			return { "osascript", "-e", applescript }
		end,
	},
},
```

**변경 후:** 파일 최상단에서 `local platform = require("config.platform")` 로 받고, `opts` 안에서 분기.

```lua
-- ... 기존 주석 블록 ...

local platform = require("config.platform")

-- 플랫폼별 터미널 설정
--   macOS: 외부 iTerm2 창 (AppleScript)
--   Linux/WSL: Neovim 내부 split 터미널 (native provider)
local terminal_opts
if platform.is_mac then
	terminal_opts = {
		provider = "external",
		provider_opts = {
			external_terminal_cmd = function(cmd_string, env_table)
				local cwd = vim.fn.getcwd()
				local parts = {}
				for k, v in pairs(env_table) do
					table.insert(parts, string.format("export %s=%s", k, vim.fn.shellescape(v)))
				end
				table.insert(parts, string.format("cd %s", vim.fn.shellescape(cwd)))
				table.insert(parts, cmd_string)
				local shell_cmd = table.concat(parts, "; ")

				local applescript = string.format(
					'tell application "iTerm"\n'
						.. "  activate\n"
						.. "  set newWindow to (create window with default profile)\n"
						.. "  tell current session of newWindow to write text %q\n"
						.. "end tell",
					shell_cmd
				)
				return { "osascript", "-e", applescript }
			end,
		},
	}
else
	terminal_opts = {
		provider = "native", -- Neovim 내부 split 터미널 사용
		split_side = "right",
		split_width_percentage = 0.4,
	}
end

return {
	"coder/claudecode.nvim",
	lazy = true,
	cmd = {
		"ClaudeCode",
		"ClaudeCodeFocus",
		"ClaudeCodeSend",
		"ClaudeCodeAdd",
		"ClaudeCodeDiffAccept",
		"ClaudeCodeDiffDeny",
		"ClaudeCodeCloseAllDiffTabs",
	},
	opts = {
		port_range = { min = 40000, max = 41000 },
		auto_start = true,
		track_selection = true,
		focus_after_send = true,
		diff_opts = {
			layout = "vertical",
			open_in_new_tab = true,
			keep_terminal_focus = false,
			hide_terminal_in_new_tab = false,
			on_new_file_reject = "keep_empty",
		},
		terminal = terminal_opts,
	},
}
```

**주의사항:**
- `native` provider 에서 `split_side`, `split_width_percentage` 는 coder/claudecode.nvim 의 공식 옵션. 버전 따라 이름이 다를 수 있으니 작업 시 README 재확인 필요.
- AppleScript 블록은 변경 없음(동작 보존).

---

### 5.6. `README.md` — **OS 별 섹션 분리**

현재 line 25~92 의 "사전 준비" 를 macOS / Ubuntu·WSL 로 나눈다.

**변경 후 구조:**

```markdown
## 사전 준비

> **주 개발 환경**: macOS Tahoe + iTerm2
> **서브 지원 환경**: Ubuntu 22.04+, Windows WSL2 Ubuntu

### macOS (Homebrew)

\```bash
# Neovim (0.11+)
brew update
brew install neovim

# mason 으로 npm 기반 LSP 서버 설치 시 필요
brew install node

# Telescope 파일/텍스트 검색
brew install fd ripgrep

# nvim-treesitter 파서 빌드
brew install tree-sitter-cli

# 한/영 입력기 자동 전환 (im-select.nvim)
brew install im-select

# Go 디버거
brew install delve

# Bash 포매터 (Mason 미지원 시 fallback)
brew install shfmt
\```

### Ubuntu / WSL Ubuntu

\```bash
# Neovim 0.11+ — apt 버전이 오래됐으면 PPA 또는 AppImage 사용
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update && sudo apt install -y neovim

# 공통 의존성
sudo apt install -y nodejs npm fd-find ripgrep build-essential

# fd 는 Ubuntu 에서 fdfind 로 설치되므로 심볼릭 링크 필요
mkdir -p ~/.local/bin
ln -sf $(which fdfind) ~/.local/bin/fd

# Go 디버거
go install github.com/go-delve/delve/cmd/dlv@latest

# 한/영 입력기 자동 전환: Linux/WSL 에서는 지원하지 않음 (플러그인 자동 비활성)

# WSL 전용: 시스템 클립보드 공유
#   sudo apt install -y xclip  # 또는 win32yank 권장
#   win32yank.exe 설치: https://github.com/equalsraf/win32yank/releases
\```

### 언어별 포매터 (OS 공통)

\```bash
# Go
go install mvdan.cc/gofumpt@latest
go install golang.org/x/tools/cmd/goimports@latest

# Python
pip install black isort sqlfluff

# YAML / JSON
npm install -g prettier
\```

### Claude Code CLI (선택)

\```bash
npm install -g @anthropic-ai/claude-code
\```

### 폰트

Nerd Font (예: `JetBrainsMono Nerd Font`) 를 터미널에 설치하고 선택해야
아이콘이 정상 표시됩니다.

- macOS: `brew install --cask font-jetbrains-mono-nerd-font`
- Linux/WSL: https://www.nerdfonts.com/ 에서 다운로드 후 사용자 폰트로 등록
```

---

### 5.7. `CLAUDE.md` — **환경 정보 업데이트**

**변경 전 (line 5-8):**
```markdown
# 환경 정보
- MacOS Tahoe
- neovim version 0.12
- Iterm2 터미널 환경
```

**변경 후:**
```markdown
# 환경 정보
- 주 개발: macOS Tahoe + iTerm2
- 서브 지원: Ubuntu 22.04+ / Windows WSL2 Ubuntu
- neovim version 0.12
- 플랫폼 분기는 `lua/config/platform.lua` 의 is_mac / is_linux / is_wsl 플래그 사용
```

---

### 5.8. `CLAUDE.STRUCT.md` — **구조도에 platform.lua 반영**

`config/` 섹션에 새 파일 추가.

**변경 전 (line 13-18):**
```
│   ├── config/                   # 핵심 설정 (플러그인 무관)
│   │   ├── init.lua              # config 모듈 진입점 (하위 모듈 일괄 로드)
│   │   ├── options.lua           # vim 기본 옵션 (set 계열)
│   │   ├── keymaps.lua           # 모든 단축키 정의 (글로벌 + 플러그인별)
│   │   ├── autocmds.lua          # autocommand 정의
│   │   └── lazy.lua              # lazy.nvim 부트스트랩 및 plugins/ 자동 스캔
```

**변경 후:**
```
│   ├── config/                   # 핵심 설정 (플러그인 무관)
│   │   ├── init.lua              # config 모듈 진입점 (하위 모듈 일괄 로드)
│   │   ├── platform.lua          # OS/환경 감지 헬퍼 (is_mac / is_linux / is_wsl)
│   │   ├── options.lua           # vim 기본 옵션 (set 계열)
│   │   ├── keymaps.lua           # 모든 단축키 정의 (글로벌 + 플러그인별)
│   │   ├── autocmds.lua          # autocommand 정의
│   │   └── lazy.lua              # lazy.nvim 부트스트랩 및 plugins/ 자동 스캔
```

그리고 "config/ 파일별 역할 상세" 섹션에 다음 항목 추가:

```markdown
### config/platform.lua
- `vim.uv.os_uname()` 기반 OS 감지
- `is_mac`, `is_linux`, `is_wsl`, `is_unix` 불리언 플래그 제공
- 다른 모듈에서 `require("config.platform")` 로 참조
- `init.lua` 에서 options 보다 먼저 로드
```

---

## 6. 작업 순서 (실행 체크리스트)

권장 순서대로 진행하면 중간 테스트가 가능합니다.

- [ ] **Step 1** — `lua/config/platform.lua` 생성 (섹션 5.1)
- [ ] **Step 2** — `lua/config/init.lua` 에 `require("config.platform")` 추가 (섹션 5.2)
- [ ] **Step 3** — 중간 검증: `:lua print(vim.inspect(require("config.platform")))` → `is_mac = true` 확인
- [ ] **Step 4** — `lua/plugins/input/im-select.lua` 에 `cond` 추가 (섹션 5.3)
- [ ] **Step 5** — `lua/config/autocmds.lua` 의 im_select_terminal autocmd 조건부화 (섹션 5.4)
- [ ] **Step 6** — macOS 에서 `:ModeChanged` 로 한/영 전환 정상 동작 확인 (회귀 테스트)
- [ ] **Step 7** — `lua/plugins/ai/claudecode.lua` terminal provider 분기 (섹션 5.5)
- [ ] **Step 8** — macOS 에서 `:ClaudeCode` 실행 → iTerm2 새 창 뜨는지 확인 (회귀 테스트)
- [ ] **Step 9** — `README.md` OS 별 섹션 분리 (섹션 5.6)
- [ ] **Step 10** — `CLAUDE.md` 환경 정보 업데이트 (섹션 5.7)
- [ ] **Step 11** — `CLAUDE.STRUCT.md` 구조도 업데이트 (섹션 5.8)
- [ ] **Step 12** — 커밋 (메시지 예: `feat(platform): support linux/wsl alongside macos`)

---

## 7. 검증 방법

### 7.1. macOS 회귀 테스트 (반드시 먼저)

```bash
# 1. headless 부팅 오류 없음
nvim --headless +q

# 2. 플랫폼 감지 정상
nvim -c 'lua print(vim.inspect(require("config.platform")))' -c q
# 기대: { is_linux = false, is_mac = true, is_unix = true, is_wsl = false, ... }

# 3. 인터랙티브 체크
nvim
```
- `:Lazy` → im-select.nvim **loaded** 상태 확인
- `:ClaudeCode` → iTerm2 새 창 열림 확인
- 터미널 버퍼에서 `<Esc>` 눌렀을 때 영문 입력기 전환 확인
- `<leader>ff`, `<leader>fg`, `<leader>gg` 동작 확인

### 7.2. Ubuntu / WSL Ubuntu 테스트

```bash
# 0. 의존성 설치 (README.md 의 Ubuntu/WSL 섹션 참고)

# 1. dotfiles clone 또는 symlink
ln -s ~/dotfiles/nvim ~/.config/nvim

# 2. headless 부팅 오류 없음
nvim --headless +q

# 3. 플랫폼 감지
nvim -c 'lua print(vim.inspect(require("config.platform")))' -c q
# WSL 기대: is_wsl = true, is_linux = true
# Pure Linux 기대: is_wsl = false, is_linux = true

# 4. im-select 가 비활성 상태인지 확인
nvim -c 'Lazy' 
# → im-select.nvim 이 "disabled (cond)" 표시되는지 확인
```
- `:ClaudeCode` → Neovim 내부 split 에 claude CLI 뜨는지 확인
- Mason 자동 설치 완료 (`:Mason` 에서 gopls, pyright, lua_ls 등 설치됨)
- 클립보드 `"+y` / `"+p` 동작 (필요 시 xclip/win32yank 설치)

### 7.3. 공통 회귀 테스트 매트릭스

| 항목 | 커맨드 | macOS | Linux | WSL |
|---|---|---|---|---|
| 파일 검색 | `<leader>ff` | | | |
| live grep | `<leader>fg` | | | |
| neo-tree | `<leader>e` | | | |
| Claude 토글 | `<leader>ac` | | | |
| Go LSP | `.go` 파일 열기 → `K` | | | |
| Go DAP | `:lua require('dap').continue()` | | | |
| 테마 변경 | `<leader>tc` | | | |

---

## 8. 예상 리스크 및 대응

| 리스크 | 대응 |
|---|---|
| WSL 의 clipboard 가 느리거나 안 됨 | `win32yank` 설치 권장. README 에 명시. |
| Ubuntu 의 neovim 버전이 낮음 (0.9 이하) | neovim-ppa/unstable 또는 AppImage 사용 안내. |
| Nerd Font 미설치 시 UI 깨짐 | README 폰트 섹션에 설치법 추가. |
| coder/claudecode.nvim 의 `native` provider 옵션 이름이 다를 수 있음 | 작업 시 플러그인 README 재확인. 옵션명이 다르면 수정. |
| WSL 에서 `vim.uv.os_uname().release` 의 "microsoft" 대소문자 | `:lower():find("microsoft")` 로 처리하여 안전. |
| 사용자 `config/init.lua` 현재 상태가 이 문서 추정과 다를 수 있음 | 실제 작업 전 `config/init.lua` 먼저 Read 후 적용. |

---

## 9. 작업 후 남는 수동 설정 (문서화만, 코드 변경 X)

Linux/WSL 사용자가 별도로 처리해야 하는 것 — README 에 명시.

1. **Nerd Font** 설치 및 터미널 설정.
2. **클립보드 도구**: `xclip` / `wl-clipboard` / `win32yank` 중 환경에 맞게.
3. **한/영 입력기**: 시스템 IME(fcitx5/ibus/Windows IME) 사용, Vim 내 자동 전환 없음.
4. **Claude Code CLI**: `npm install -g @anthropic-ai/claude-code` (macOS 와 동일).

---

## 10. 참고: 건드리지 않는 부분 (이미 호환)

| 파일/설정 | 이유 |
|---|---|
| `lua/config/options.lua:39` `clipboard = "unnamedplus"` | Neovim 이 OS 별 clipboard provider 를 자동 선택 |
| `lua/plugins/search/telescope.lua` | `fd`, `ripgrep` 는 3 OS 공통 |
| `lua/plugins/editor/treesitter.lua` | `tree-sitter-cli` 는 3 OS 공통 |
| `lua/plugins/debug/dap.lua` | `dlv` 커맨드 이름 참조, 경로 하드코딩 없음 |
| `lua/plugins/lsp/mason*.lua` | Mason 이 OS 별 바이너리 자동 선택 |
| `lua/extras/lang/*.lua` | 외부 커맨드 경로 하드코딩 없음 |

---

## 11. 커밋 전략 제안

작업 단위가 작으므로 **1커밋 완결** 권장.

```
feat(platform): support linux and wsl ubuntu alongside macos

- add config/platform.lua to detect os (mac/linux/wsl)
- guard im-select plugin + autocmd with is_mac
- switch claudecode terminal provider per platform
  (macos: external iterm2, linux/wsl: native split)
- split README 사전 준비 into macos / ubuntu·wsl sections
```

분할하고 싶다면 (a) platform 헬퍼 + im-select, (b) claudecode 분기, (c) README 3분할.

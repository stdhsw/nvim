-- ============================================================================
-- lazy.nvim 부트스트랩
-- ============================================================================
-- 플러그인: folke/lazy.nvim
-- 저장소: https://github.com/folke/lazy.nvim
--
-- 설명:
--   neovim의 플러그인 매니저로, 플러그인의 설치/업데이트/삭제를 관리한다.
--   지연 로딩(lazy loading)을 지원하여 neovim 시작 속도를 최적화한다.
--   plugins/ 디렉토리를 자동으로 스캔하여 플러그인을 로드한다.
--
-- 사용법:
--   :Lazy          - lazy.nvim UI 열기 (플러그인 목록 확인)
--   :Lazy install  - 미설치 플러그인 설치
--   :Lazy update   - 플러그인 업데이트
--   :Lazy sync     - 설치 + 업데이트 + 미사용 플러그인 제거
--   :Lazy clean    - 미사용 플러그인 제거
--   :Lazy profile  - 플러그인 로딩 시간 프로파일링
--   :Lazy health   - 플러그인 상태 확인
--
-- UI 단축키 (Lazy UI 내부):
--   I - 플러그인 설치
--   U - 플러그인 업데이트
--   S - sync
--   X - clean
--   R - restore (lockfile 기준으로 복원)
--   q - UI 닫기
-- ============================================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- lazy.nvim이 없으면 자동으로 git clone하여 설치
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

-- lazy.nvim을 런타임 경로에 추가
vim.opt.rtp:prepend(lazypath)

-- lazy.nvim 초기화
-- plugins/ 디렉토리를 자동 스캔하고, extras/lang/ 에서 언어별 설정을 import한다.
-- 새 언어 추가 시 lua/extras/lang/<언어>.lua 파일을 만들고 아래에 import를 추가한다.
require("lazy").setup({
	-- =========================================================================
	-- [[ Plugins ]]
	-- plugins/ 하위 디렉토리를 개별 import한다.
	-- 새 카테고리 추가 시 plugins/<카테고리>/ 디렉토리를 만들고 아래에 import를 추가한다.
	-- =========================================================================
	{ import = "plugins.ai" },
	{ import = "plugins.debug" },
	{ import = "plugins.editor" },
	{ import = "plugins.file" },
	{ import = "plugins.git" },
	{ import = "plugins.input" },
	{ import = "plugins.lsp" },
	{ import = "plugins.note" },
	{ import = "plugins.search" },
	{ import = "plugins.ui" },

	-- =========================================================================
	-- [[ Language Extras ]]
	-- 활성화할 언어 extras를 아래에 추가/제거한다.
	-- =========================================================================
	{ import = "extras.lang.go" }, -- Go
	{ import = "extras.lang.python" }, -- Python
	{ import = "extras.lang.lua" }, -- Lua (neovim 설정 작성용)
	{ import = "extras.lang.ops" }, -- YAML / JSON / Bash / Dockerfile / SQL
}, {
	defaults = {
		lazy = false, -- 기본적으로 즉시 로드 (각 플러그인에서 개별 설정)
	},
	install = {
		colorscheme = { "habamax" }, -- 플러그인 설치 중 사용할 임시 테마
	},
	checker = {
		enabled = false, -- 자동 업데이트 체크 비활성화 (수동으로 :Lazy sync 운영)
	},
	change_detection = {
		notify = false, -- 설정 파일 변경 감지 시 알림 비활성화
	},
	performance = {
		rtp = {
			disabled_plugins = {
				-- 사용하지 않는 neovim 기본 플러그인 비활성화 (시작 속도 향상)
				-- matchparen 은 짝괄호 시각화에 필요하므로 유지
				"gzip",
				"matchit",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})

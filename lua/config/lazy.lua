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
if not vim.loop.fs_stat(lazypath) then
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

-- lazy.nvim 초기화 및 plugins/ 디렉토리 자동 스캔
require("lazy").setup("plugins", {
	defaults = {
		lazy = false, -- 기본적으로 즉시 로드 (각 플러그인에서 개별 설정)
	},
	install = {
		colorscheme = { "habamax" }, -- 플러그인 설치 중 사용할 임시 테마
	},
	checker = {
		enabled = true, -- 플러그인 업데이트 자동 감지
		notify = false, -- 업데이트 감지 시 알림 비활성화 (수동으로 :Lazy 확인)
	},
	change_detection = {
		notify = false, -- 설정 파일 변경 감지 시 알림 비활성화
	},
	performance = {
		rtp = {
			disabled_plugins = {
				-- 사용하지 않는 neovim 기본 플러그인 비활성화 (시작 속도 향상)
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})

-- ============================================================================
-- 파일명: ui/lualine.lua
--
-- 플러그인: nvim-lualine/lualine.nvim
-- 저장소: https://github.com/nvim-lualine/lualine.nvim
--
-- 설명:
--   neovim 하단 상태바 플러그인.
--   현재 모드, 파일명, git 브랜치, LSP 진단 수, 파일타입, 커서 위치 등을
--   구성 가능한 6개 섹션으로 나누어 표시한다.
--   globalstatus = true 설정으로 창이 여러 개여도 상태바는 하단에 하나만 표시된다.
--
-- 상태바 구성:
--   좌측: [모드] [git 브랜치 + diff] [파일명(상대경로)] [LSP 진단]
--   우측: [파일타입] [진행률%] [줄:열]
--
--   LSP 진단 표시:
--   E:n  - Error n개   W:n  - Warning n개   I:n  - Info n개
--
-- 사용법:
--   별도 명령어 없이 자동으로 하단 상태바에 표시된다.
--
-- 커스텀 단축키:
--   없음
-- ============================================================================

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VeryLazy",
	opts = {
		options = {
			theme = "powerline_dark", -- 고대비 내장 테마. colorscheme 확정 후 변경 가능
			globalstatus = true, -- 창이 여러 개여도 상태바는 하단에 하나만 표시
			disabled_filetypes = {
				statusline = { "neo-tree" },
			},
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch", "diff", "diagnostics" },
			lualine_c = { { "filename", path = 1 } }, -- 상대 경로 표시
			lualine_x = { "filetype" },
			lualine_y = { "progress" },
			lualine_z = { "location" },
		},
	},
}

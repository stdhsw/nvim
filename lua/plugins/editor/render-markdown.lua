-- ============================================================================
-- 파일명: editor/render-markdown.lua
--
-- 플러그인: MeanderingProgrammer/render-markdown.nvim
-- 저장소: https://github.com/MeanderingProgrammer/render-markdown.nvim
--
-- 설명:
--   Neovim 버퍼 내에서 Markdown을 직접 렌더링하는 플러그인.
--   별도의 브라우저나 외부 창 없이 Neovim 안에서 시각적으로 표시.
--   헤더, 코드블록, 인용구, 체크박스, 테이블, 리스트 등을 아이콘과 색상으로 표현.
--
-- 사용법:
--   .md 파일을 열면 자동으로 렌더링 적용.
--   <leader>mr 로 렌더링 토글 (읽기/편집 모드 전환).
--
-- 기본 단축키:
--   <leader>mr : 렌더링 토글 (render-markdown 활성/비활성)
-- ============================================================================

return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	ft = { "markdown" },
	opts = {
		-- 헤더 렌더링 설정
		heading = {
			enabled = true,
			-- 헤더 레벨별 아이콘
			icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
		},
		-- 코드블록 렌더링 설정
		code = {
			enabled = true,
			-- 코드블록에 배경색 적용
			style = "full",
		},
		-- 체크박스 렌더링 설정
		checkbox = {
			enabled = true,
			unchecked = { icon = "󰄱 " },
			checked = { icon = "󰄵 " },
		},
		-- 불릿 리스트 아이콘
		bullet = {
			enabled = true,
			icons = { "●", "○", "◆", "◇" },
		},
		-- 인용구 렌더링 설정
		quote = {
			enabled = true,
			icon = "▋",
		},
		-- 테이블 렌더링 설정
		pipe_table = {
			enabled = true,
			style = "full",
		},
	},
}

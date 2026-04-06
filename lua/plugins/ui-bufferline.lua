-- ============================================================================
-- 파일명: ui-bufferline.lua
--
-- 플러그인: akinsho/bufferline.nvim
-- 저장소: https://github.com/akinsho/bufferline.nvim
--
-- 설명:
--   열린 버퍼를 상단 탭 형태로 표시하는 플러그인.
--   파일 아이콘, LSP 진단 아이콘, 사선(slant) 구분자 스타일을 사용한다.
--   neo-tree 사이드바와 연동하여 사이드바 너비만큼 탭을 오른쪽으로 밀어 표시한다.
--   마지막 버퍼 닫기 시 neovim이 종료되지 않도록 안전하게 처리한다.
--
-- 사용법:
--   :BufferLinePick        - 알파벳 키로 버퍼 선택해서 이동
--   :BufferLinePickClose   - 알파벳 키로 버퍼 선택 후 닫기
--
-- 커스텀 단축키 (config/keymaps.lua 참고):
--   <S-h>        - 이전 버퍼로 이동
--   <S-l>        - 다음 버퍼로 이동
--   <leader>w    - 현재 버퍼 닫기 (마지막 버퍼면 neovim 종료)
--   <leader>bp   - 버퍼 선택해서 이동 (pick)
--   <leader>bc   - 버퍼 선택해서 닫기 (pick close)
-- ============================================================================

return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VeryLazy",
	opts = {
		options = {
			-- LSP 진단 결과를 탭에 아이콘으로 표시 (nvim_lsp: LSP 연동)
			diagnostics = "nvim_lsp",
			diagnostics_indicator = function(_, _, diag)
				-- error, warning, hint 각각의 수를 아이콘과 함께 표시
				local icons = { error = " ", warning = " ", hint = " " }
				local ret = ""
				for severity, icon in pairs(icons) do
					if diag[severity] and diag[severity] > 0 then
						ret = ret .. icon .. diag[severity] .. " "
					end
				end
				return vim.trim(ret)
			end,
			-- neo-tree 사이드바가 열려 있을 때 탭을 그 너비만큼 오른쪽으로 밀어 표시
			offsets = {
				{
					filetype = "neo-tree",
					text = "File Explorer",
					highlight = "Directory",
					text_align = "center",
				},
			},
			show_buffer_close_icons = true, -- 각 탭에 닫기 버튼 표시
			show_close_icon = false, -- 우측 끝 전체 닫기 버튼 숨김
			separator_style = "slant", -- 탭 구분자 스타일 (slant: 사선)
		},
	},
}

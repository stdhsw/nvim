-- ============================================================================
-- 파일명: ui/bufferline.lua
--
-- 플러그인: akinsho/bufferline.nvim
-- 저장소: https://github.com/akinsho/bufferline.nvim
--
-- 설명:
--   열린 버퍼를 상단 탭 형태로 표시하는 플러그인.
--   파일 아이콘, LSP 진단 아이콘, 사선(slant) 구분자 스타일을 사용한다.
--   neo-tree 사이드바와 연동하여 사이드바 너비만큼 탭을 오른쪽으로 밀어 표시한다.
--   마지막 버퍼 닫기 시 alpha 대시보드로 교체하여 neovim 이 종료되지 않도록 한다.
--   테마 전환(:colorscheme / <leader>tc) 시에도 커스텀 하이라이트가 풀리지 않도록
--   ColorScheme autocmd 에서 setup 을 재호출하여 색을 복원한다.
--
-- 사용법:
--   :BufferLinePick        - 알파벳 키로 버퍼 선택해서 이동
--   :BufferLinePickClose   - 알파벳 키로 버퍼 선택 후 닫기
--
-- 커스텀 단축키 (config/keymaps.lua 참고):
--   <S-h>        - 이전 버퍼로 이동
--   <S-l>        - 다음 버퍼로 이동
--   <leader>w    - 현재 버퍼 닫기 (마지막 버퍼면 alpha 대시보드로 교체, nvim 유지)
--   <leader>bp   - 버퍼 선택해서 이동 (pick)
--   <leader>bc   - 버퍼 선택해서 닫기 (pick close)
-- ============================================================================

return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- 첫 buffer 가 그려지는 시점에 함께 표시되도록 BufRead/BufNewFile 로 로드
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		local options = {
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
			show_buffer_icons = false, -- 각 탭의 파일 타입 아이콘 숨김
			show_buffer_close_icons = true, -- 각 탭에 닫기 버튼 표시
			show_close_icon = false, -- 우측 끝 전체 닫기 버튼 숨김
			separator_style = "slant", -- 탭 구분자 스타일 (slant: 사선)
			indicator = { style = "icon", icon = "▎" }, -- 활성 탭 좌측 세로 막대
			modified_icon = "[+]", -- 수정된 버퍼 표시 아이콘
			always_show_bufferline = true,
			-- X 버튼 클릭 시 동작: 마지막 버퍼면 alpha 대시보드로 교체 (nvim 유지)
			close_command = function(bufnr)
				local bufs = vim.fn.getbufinfo({ buflisted = 1 })
				if #bufs > 1 then
					vim.cmd("bprevious")
				else
					vim.cmd("Alpha") -- 마지막 버퍼면 대시보드 표시
				end
				vim.cmd("bdelete! " .. bufnr)
			end,
		}

		-- colorscheme.lua(github_dark_high_contrast) / lualine.lua(노랑 파워라인) 톤에 맞춘 하이라이트
		-- 배경 톤:
		--   비활성 버퍼   #161b22 (어두운 회색)
		--   visible 버퍼  #333333 (중간 회색)
		--   활성 버퍼     #EEEEEE (밝은 회색) + 검정 글자
		-- 진단 그룹은 배경을 위 톤과 동일하게 유지하고 fg 만 진단 색으로 지정하여
		-- 전체 탭바 톤이 갑자기 깨지지 않도록 했다.
		local highlights = {
			-- 탭 라인 전체 배경
			fill = { bg = "#0a0c10" },

			-- 비활성 / 표시중 / 활성 버퍼
			background = { fg = "#888888", bg = "#161b22" },
			buffer_visible = { fg = "#ffffff", bg = "#333333" },
			buffer_selected = { fg = "#000000", bg = "#EEEEEE", bold = true, italic = false },

			-- 닫기 버튼
			close_button = { fg = "#888888", bg = "#161b22" },
			close_button_visible = { fg = "#ffffff", bg = "#333333" },
			close_button_selected = { fg = "#000000", bg = "#EEEEEE", bold = true, italic = false },

			-- 수정됨 표시 (close 버튼과 동일한 배경)
			modified = { fg = "#888888", bg = "#161b22" },
			modified_visible = { fg = "#ffffff", bg = "#333333" },
			modified_selected = { fg = "#000000", bg = "#EEEEEE", bold = true, italic = false },

			-- 진단 공통 (특정 severity 없이 진단만 존재할 때)
			diagnostic = { fg = "#888888", bg = "#161b22", italic = true },
			diagnostic_visible = { fg = "#ffffff", bg = "#333333", italic = true },
			diagnostic_selected = { fg = "#000000", bg = "#EEEEEE", bold = true, italic = true },

			-- 에러 (빨강)
			error = { fg = "#E03A3E", bg = "#161b22" },
			error_visible = { fg = "#E03A3E", bg = "#333333" },
			error_selected = { fg = "#A0282C", bg = "#EEEEEE", bold = true, italic = true },
			error_diagnostic = { fg = "#E03A3E", bg = "#161b22" },
			error_diagnostic_visible = { fg = "#E03A3E", bg = "#333333" },
			error_diagnostic_selected = { fg = "#A0282C", bg = "#EEEEEE", bold = true, italic = true },

			-- 경고 (노랑/주황)
			warning = { fg = "#FDB827", bg = "#161b22" },
			warning_visible = { fg = "#FDB827", bg = "#333333" },
			warning_selected = { fg = "#B8860B", bg = "#EEEEEE", bold = true, italic = true },
			warning_diagnostic = { fg = "#FDB827", bg = "#161b22" },
			warning_diagnostic_visible = { fg = "#FDB827", bg = "#333333" },
			warning_diagnostic_selected = { fg = "#B8860B", bg = "#EEEEEE", bold = true, italic = true },

			-- 정보 (파랑)
			info = { fg = "#61AFEF", bg = "#161b22" },
			info_visible = { fg = "#61AFEF", bg = "#333333" },
			info_selected = { fg = "#2F6FAF", bg = "#EEEEEE", bold = true, italic = true },
			info_diagnostic = { fg = "#61AFEF", bg = "#161b22" },
			info_diagnostic_visible = { fg = "#61AFEF", bg = "#333333" },
			info_diagnostic_selected = { fg = "#2F6FAF", bg = "#EEEEEE", bold = true, italic = true },

			-- 힌트 (하늘)
			hint = { fg = "#009DDC", bg = "#161b22" },
			hint_visible = { fg = "#009DDC", bg = "#333333" },
			hint_selected = { fg = "#005F82", bg = "#EEEEEE", bold = true, italic = true },
			hint_diagnostic = { fg = "#009DDC", bg = "#161b22" },
			hint_diagnostic_visible = { fg = "#009DDC", bg = "#333333" },
			hint_diagnostic_selected = { fg = "#005F82", bg = "#EEEEEE", bold = true, italic = true },
		}

		require("bufferline").setup({ options = options, highlights = highlights })

		-- 테마 전환(:colorscheme / <leader>tc) 시 BufferLine* 하이라이트가 테마 기본값으로
		-- 초기화되는 문제를 방지하기 위해 setup 을 재호출하여 색을 복원한다.
		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "*",
			callback = function()
				require("bufferline").setup({ options = options, highlights = highlights })
			end,
		})
	end,
}

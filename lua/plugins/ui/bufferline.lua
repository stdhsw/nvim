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
		-- 배경 톤 (3가지 상태 공통):
		--   비활성(normal)  #161b22 (어두운 회색)
		--   표시중(visible) #333333 (중간 회색)
		--   활성(selected)  #EEEEEE (밝은 회색) + 검정/굵게
		local BG_NORMAL = "#161b22"
		local BG_VISIBLE = "#333333"
		local BG_SELECTED = "#EEEEEE"

		-- 진단 severity 한 종류(error/warning/info/hint)에 대한 6개 그룹을 생성한다.
		--   normal/visible 은 fg 를 진단 색(c)으로, selected 는 어두운 변형(sel)으로 지정하고
		--   배경은 위 3색 톤을 그대로 유지해 탭바 전체 톤이 깨지지 않게 한다.
		--   진단 그룹은 _diagnostic 접미사까지 동일 색으로 6개가 한 쌍을 이룬다.
		local function diag_hl(name, c, sel)
			local sel_hl = { fg = sel, bg = BG_SELECTED, bold = true, italic = true }
			return {
				[name] = { fg = c, bg = BG_NORMAL },
				[name .. "_visible"] = { fg = c, bg = BG_VISIBLE },
				[name .. "_selected"] = sel_hl,
				[name .. "_diagnostic"] = { fg = c, bg = BG_NORMAL },
				[name .. "_diagnostic_visible"] = { fg = c, bg = BG_VISIBLE },
				[name .. "_diagnostic_selected"] = sel_hl,
			}
		end

		local highlights = {
			-- 탭 라인 전체 배경
			fill = { bg = "#0a0c10" },

			-- 비활성 / 표시중 / 활성 버퍼
			background = { fg = "#888888", bg = BG_NORMAL },
			buffer_visible = { fg = "#ffffff", bg = BG_VISIBLE },
			buffer_selected = { fg = "#000000", bg = BG_SELECTED, bold = true, italic = false },

			-- 닫기 버튼
			close_button = { fg = "#888888", bg = BG_NORMAL },
			close_button_visible = { fg = "#ffffff", bg = BG_VISIBLE },
			close_button_selected = { fg = "#000000", bg = BG_SELECTED, bold = true, italic = false },

			-- 수정됨 표시 (close 버튼과 동일한 배경)
			modified = { fg = "#888888", bg = BG_NORMAL },
			modified_visible = { fg = "#ffffff", bg = BG_VISIBLE },
			modified_selected = { fg = "#000000", bg = BG_SELECTED, bold = true, italic = false },

			-- 진단 공통 (특정 severity 없이 진단만 존재할 때)
			diagnostic = { fg = "#888888", bg = BG_NORMAL, italic = true },
			diagnostic_visible = { fg = "#ffffff", bg = BG_VISIBLE, italic = true },
			diagnostic_selected = { fg = "#000000", bg = BG_SELECTED, bold = true, italic = true },
		}

		-- severity 별 진단 색상 (normal/visible fg, selected fg) 일괄 등록
		--   error(빨강) / warning(노랑·주황) / info(파랑) / hint(하늘)
		for _, d in ipairs({
			{ "error", "#E03A3E", "#A0282C" },
			{ "warning", "#FDB827", "#B8860B" },
			{ "info", "#61AFEF", "#2F6FAF" },
			{ "hint", "#009DDC", "#005F82" },
		}) do
			for group, hl in pairs(diag_hl(d[1], d[2], d[3])) do
				highlights[group] = hl
			end
		end

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

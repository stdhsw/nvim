-- ============================================================================
-- 파일명: editor/markdown-table.lua
--
-- 플러그인: dhruvasagar/vim-table-mode
-- 저장소: https://github.com/dhruvasagar/vim-table-mode
--
-- 설명:
--   Markdown 테이블을 정렬하고 편집하는 플러그인.
--   기본 단축키(<leader>tm 등)는 비활성화하고
--   사용자가 호출하는 단일 user command + 단축키로만 사용한다.
--
-- 사용법:
--   :MarkdownTableRealign  - 현재 markdown 파일의 모든 테이블 재정렬
--                            구분선 셀의 공백은 - 로 자동 채움
--
--   기본 단축키 (config/keymaps.lua 참고):
--   <leader>mf  - 현재 markdown 파일의 모든 테이블 재정렬
--
-- 동작 변경 이력:
--   기존에는 .md 저장(BufWritePre) 시 자동으로 전체 테이블을 재정렬했으나,
--   큰 markdown 파일에서 저장 lag 이 발생하여 수동 호출 방식으로 변경됨.
-- ============================================================================

-- 구분선 셀 내부의 공백을 - 로 채우는 후처리 함수
local function fill_separator_dashes()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local changed = false

	for i, line in ipairs(lines) do
		-- 구분선 여부: | 로 감싸이고, -, :, 공백만 포함하며 - 가 하나 이상 있는 셀
		if line:match("^%s*|") and line:match("%-") then
			-- | 로 분리하여 각 셀 처리
			local parts = vim.split(line, "|", { plain = true })
			local is_separator = true
			for _, part in ipairs(parts) do
				-- 빈 셀(맨 앞/뒤)은 제외, 나머지가 -, :, 공백만 있어야 구분선
				if part ~= "" and not part:match("^[%- :]+$") then
					is_separator = false
					break
				end
			end

			if is_separator then
				for j, part in ipairs(parts) do
					if part:match("^[%- :]+$") and part:match("%-") then
						-- 공백을 - 로 치환 (: 정렬 마커는 보존)
						parts[j] = part:gsub(" ", "-")
					end
				end
				local new_line = table.concat(parts, "|")
				if new_line ~= line then
					lines[i] = new_line
					changed = true
				end
			end
		end
	end

	if changed then
		vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
	end
end

-- 현재 buffer 내 모든 markdown 테이블을 재정렬
local function realign_all_tables()
	local pos = vim.api.nvim_win_get_cursor(0)
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

	-- 테이블 행(|로 시작)의 첫 번째 줄 위치를 수집
	local table_starts = {}
	local in_table = false
	for i, line in ipairs(lines) do
		local is_table_line = line:match("^%s*|")
		if is_table_line and not in_table then
			table_starts[#table_starts + 1] = i
			in_table = true
		elseif not is_table_line then
			in_table = false
		end
	end

	-- 각 테이블의 첫 줄로 커서 이동 후 재정렬
	-- pcall: 커서 위치가 table-mode 가 인식 못 하는 셀일 때 에러 무시
	for _, lnum in ipairs(table_starts) do
		vim.api.nvim_win_set_cursor(0, { lnum, 0 })
		pcall(vim.cmd.TableModeRealign)
	end

	-- 구분선 셀의 공백을 - 로 채움
	fill_separator_dashes()

	-- 커서 원위치
	vim.api.nvim_win_set_cursor(0, pos)
end

return {
	"dhruvasagar/vim-table-mode",
	ft = { "markdown" },
	cmd = { "MarkdownTableRealign" },
	init = function()
		-- Markdown 호환 모서리 문자 (|)
		vim.g.table_mode_corner = "|"
		-- 구분선 채우기 문자 (-)
		vim.g.table_mode_fillchar = "-"
		-- 기본 단축키 비활성화 (수동 정렬 user command 만 사용)
		vim.g.table_mode_map_prefix = "<Plug>(disabled-table-mode)"
	end,
	config = function()
		vim.api.nvim_create_user_command("MarkdownTableRealign", realign_all_tables, {
			desc = "현재 markdown 파일의 모든 테이블 재정렬",
		})
	end,
}

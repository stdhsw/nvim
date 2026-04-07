local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- ============================================================================
-- 파일타입별 들여쓰기
-- 언어 추가 시 이 테이블만 수정하면 됨
-- ============================================================================
local indent_config = {
	{ filetypes = { "go", "makefile" }, expand = false, size = 4 },
	{ filetypes = { "yaml", "json", "sql", "bash", "sh", "dockerfile" }, expand = true, size = 2 },
	{ filetypes = { "python" }, expand = true, size = 4 },
}

autocmd("FileType", {
	group = augroup("filetype_indent", { clear = true }),
	callback = function()
		local ft = vim.bo.filetype
		for _, config in ipairs(indent_config) do
			if vim.tbl_contains(config.filetypes, ft) then
				vim.opt_local.expandtab = config.expand
				vim.opt_local.tabstop = config.size
				vim.opt_local.shiftwidth = config.size
				break
			end
		end
	end,
})

-- ============================================================================
-- yank 하이라이트
-- 복사(yank) 시 복사된 영역을 잠깐 하이라이팅하여 시각적 피드백 제공
-- ============================================================================
autocmd("TextYankPost", {
	group = augroup("yank_highlight", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ higroup = "Visual", timeout = 150 })
	end,
})

-- ============================================================================
-- 마지막 커서 위치 복원
-- 파일을 다시 열 때 이전에 편집하던 위치로 자동 이동
-- ============================================================================
autocmd("BufReadPost", {
	group = augroup("restore_cursor", { clear = true }),
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local line_count = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= line_count then
			vim.api.nvim_win_set_cursor(0, mark)
		end
	end,
})

-- ============================================================================
-- 터미널 모드 진입 시 줄번호 숨김
-- 터미널 버퍼에서는 줄번호가 불필요하므로 자동으로 숨김
-- ============================================================================
autocmd("TermOpen", {
	group = augroup("terminal_settings", { clear = true }),
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.signcolumn = "no"
		vim.keymap.set("n", "i", "<cmd>startinsert<cr>", { buffer = true })
	end,
})

-- ============================================================================
-- 저장 시 후행 공백 제거
-- 줄 끝에 남은 불필요한 공백을 저장 시 자동으로 제거
-- ============================================================================
autocmd("BufWritePre", {
	group = augroup("trim_whitespace", { clear = true }),
	pattern = "*",
	callback = function()
		local pos = vim.api.nvim_win_get_cursor(0)
		vim.cmd([[%s/\s\+$//e]])
		vim.api.nvim_win_set_cursor(0, pos)
	end,
})

-- ############################################################################
-- [[ Plugins ]]
-- ############################################################################

-- im-select (포커스 진입 시 영어 입력기 자동 전환)
-- 다른 앱에서 한글로 입력하다가 neovim으로 돌아올 때 영어로 자동 전환
autocmd("FocusGained", {
	group = augroup("im_select_focus", { clear = true }),
	callback = function()
		vim.fn.system("im-select com.apple.keylayout.ABC")
	end,
})

-- im-select (터미널 모드 탈출 시 영어 입력기 자동 전환)
-- Claude 터미널 등에서 ESC/<C-\><C-n>으로 노말 모드 전환 시 영어로 자동 전환
-- InsertLeave는 터미널 모드에서 발생하지 않으므로 ModeChanged 이벤트 사용
autocmd("ModeChanged", {
	group = augroup("im_select_terminal", { clear = true }),
	pattern = "t:*",
	callback = function()
		vim.fn.system("im-select com.apple.keylayout.ABC")
	end,
})

-- autoread (외부 파일 변경 자동 감지)
-- Claude Code 등 외부 편집기가 파일을 수정했을 때 자동으로 반영됨
-- CursorHold/CursorHoldI 제거: 타이핑을 멈출 때마다 디스크 I/O가 발생하므로
-- 포커스 복귀 시점(FocusGained, BufEnter)에만 감지하는 것으로 충분
autocmd({ "FocusGained", "BufEnter" }, {
	group = augroup("auto_reload", { clear = true }),
	callback = function()
		if vim.fn.mode() ~= "c" then
			vim.cmd("checktime")
		end
	end,
})

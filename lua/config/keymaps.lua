-- leader 키 설정
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set
local opts = function(desc)
	return { desc = desc, silent = true }
end

-- ============================================================================
-- 일반 편집
-- ============================================================================
-- map("n", "<leader>w", "<cmd>w<cr>", opts("파일 저장"))
-- map("n", "<leader>q", "<cmd>q<cr>", opts("종료"))
-- map("n", "<leader>Q", "<cmd>qa<cr>", opts("전체 종료"))

-- 검색 하이라이트 해제
map("n", "<leader>h", "<cmd>nohlsearch<cr>", opts("[검색] 하이라이트 해제"))

-- 들여쓰기 후 선택 유지
map("v", "<", "<gv", opts("[들여쓰기] 감소 후 선택 유지"))
map("v", ">", ">gv", opts("[들여쓰기] 증가 후 선택 유지"))

-- 대소문자 변환
map("n", "<leader>uu", "gUiw", opts("[대소문자] 단어 대문자로 변환"))
map("n", "<leader>ul", "guiw", opts("[대소문자] 단어 소문자로 변환"))
map("n", "<leader>u~", "g~iw", opts("[대소문자] 단어 대소문자 토글"))
map("v", "<leader>uu", "U", opts("[대소문자] 선택 영역 대문자로 변환"))
map("v", "<leader>ul", "u", opts("[대소문자] 선택 영역 소문자로 변환"))

-- 붙여넣기 시 레지스터 덮어쓰기 방지 (visual 모드)
map("v", "p", '"_dP', opts("레지스터 유지하며 붙여넣기"))

-- ============================================================================
-- 창 이동
-- ============================================================================
map("n", "<C-h>", "<C-w>h", opts("[창이동] 왼쪽 창으로 이동"))
map("n", "<C-j>", "<C-w>j", opts("[창이동] 아래 창으로 이동"))
map("n", "<C-k>", "<C-w>k", opts("[창이동] 위 창으로 이동"))
map("n", "<C-l>", "<C-w>l", opts("[창이동] 오른쪽 창으로 이동"))

-- 창 크기 조절
map("n", "<M-Up>", "<cmd>resize +2<cr>", opts("[창크기] 창 높이 증가"))
map("n", "<M-Down>", "<cmd>resize -2<cr>", opts("[창크기] 창 높이 감소"))
map("n", "<M-Left>", "<cmd>vertical resize -2<cr>", opts("[창크기] 창 너비 감소"))
map("n", "<M-Right>", "<cmd>vertical resize +2<cr>", opts("[창크기] 창 너비 증가"))

-- ============================================================================
-- 터미널
-- ============================================================================
map("t", "<Esc><Esc>", "<C-\\><C-n>", opts("[터미널] 노멀 모드로 전환"))

-- ############################################################################
-- [[ Plugins ]]
-- ############################################################################

-- 플러그인 lazy require 캐싱
-- 단축키 실행 시점까지 로드를 미루고, 첫 호출 이후에는 캐시에서 반환
local function lazy_require(mod)
	local m
	return function()
		m = m or require(mod)
		return m
	end
end

local todo_comments = lazy_require("todo-comments")
local gitsigns = lazy_require("gitsigns")
local ufo = lazy_require("ufo")
local dap = lazy_require("dap")
local dapui = lazy_require("dapui")
local dap_go = lazy_require("dap-go")

-- neo-tree (파일 탐색기)
map("n", "<leader>ee", "<cmd>Neotree toggle<cr>", opts("[Neo-tree] 파일 탐색기 열기/닫기"))
map("n", "<leader>E", "<cmd>Neotree focus<cr>", opts("[Neo-tree] 파일 탐색기 포커스"))
map("n", "<leader>er", "<cmd>Neotree reveal<cr>", opts("[Neo-tree] 파일 탐색기에서 현재파일 표시"))
map(
	"n",
	"<leader>ge",
	"<cmd>Neotree git_status toggle<cr>",
	opts("[Neo-tree] 파일 탐색기에서 Git 상태 탐색기 토글")
)

-- bufferline (버퍼 탭)
map("n", "<S-h>", "<cmd>bprevious<cr>", opts("[Bufferline] 이전 버퍼"))
map("n", "<S-l>", "<cmd>bnext<cr>", opts("[Bufferline] 다음 버퍼"))
map("n", "<leader>w", function()
	local bufs = vim.fn.getbufinfo({ buflisted = 1 })
	if #bufs > 1 then
		vim.cmd("bp | bd #") -- 이전 버퍼로 전환 후 현재 버퍼 삭제
	else
		vim.cmd("q") -- 마지막 버퍼면 종료
	end
end, opts("[Bufferline] 버퍼 닫기"))
map("n", "<leader>bp", "<cmd>BufferLinePick<cr>", opts("[Bufferline] 버퍼 선택해서 이동"))
map("n", "<leader>bc", "<cmd>BufferLinePickClose<cr>", opts("[Bufferline] 버퍼 선택해서 닫기"))

-- lspconfig (LSP)
map("n", "]d", vim.diagnostic.goto_next, opts("[LSP] 다음 진단으로 이동"))
map("n", "[d", vim.diagnostic.goto_prev, opts("[LSP] 이전 진단으로 이동"))

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local bufopts = function(desc)
			return { desc = desc, silent = true, buffer = event.buf }
		end
		map("n", "gd", vim.lsp.buf.definition, bufopts("[LSP] 정의로 이동"))
		map("n", "gD", vim.lsp.buf.declaration, bufopts("[LSP] 선언으로 이동"))
		map("n", "gi", vim.lsp.buf.implementation, bufopts("[LSP] 구현으로 이동"))
		map("n", "gr", "<cmd>Telescope lsp_references<cr>", bufopts("[LSP] 참조 찾기 (Telescope)"))
		map("n", "K", vim.lsp.buf.hover, bufopts("[LSP] hover 문서"))
		map("n", "<leader>lk", vim.lsp.buf.signature_help, bufopts("[LSP] 시그니처 표시"))
		map("n", "<leader>lr", vim.lsp.buf.rename, bufopts("[LSP] 이름 변경"))
		map("n", "<leader>la", vim.lsp.buf.code_action, bufopts("[LSP] 코드 액션"))
		map("n", "<leader>ld", vim.diagnostic.open_float, bufopts("[LSP] 진단 상세"))
		map("n", "<leader>lf", function()
			-- conform이 로드된 경우 conform 포맷 사용, 아니면 LSP 포맷 사용
			local ok, conform = pcall(require, "conform")
			if ok then
				conform.format({ async = true, lsp_fallback = true })
			else
				vim.lsp.buf.format({ async = true })
			end
		end, bufopts("[LSP] 포맷"))
	end,
})

-- telescope (검색)
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts("[Telescope] 파일 찾기"))
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts("[Telescope] 텍스트 검색"))
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts("[Telescope] 버퍼 목록"))
map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", opts("[Telescope] 최근 파일"))
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts("[Telescope] 도움말 검색"))
map("n", "<leader>ks", "<cmd>Telescope keymaps<cr>", opts("[Telescope] 단축키 검색"))
-- ui-colorscheme (테마)
map("n", "<leader>tc", "<cmd>Telescope colorscheme<cr>", opts("[Colorscheme] 테마 선택"))
map("n", "<leader>ft", "<cmd>TodoTelescope<cr>", opts("[Todo-comments] TODO 검색"))

-- todo-comments (TODO 하이라이팅)
map("n", "]t", function()
	todo_comments().jump_next()
end, opts("[Todo-comments] 다음 TODO로 이동"))
map("n", "[t", function()
	todo_comments().jump_prev()
end, opts("[Todo-comments] 이전 TODO로 이동"))

-- Comment.nvim (주석 토글)
map("n", "<leader>/", function()
	require("Comment.api").toggle.linewise.current()
end, opts("[Comment] 현재 줄 주석 토글"))
map(
	"v",
	"<leader>/",
	"<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
	opts("[Comment] 선택 영역 주석 토글")
)

-- toggleterm (터미널)
map("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", opts("[Toggleterm] float 터미널 토글"))
map("n", "<leader>t1", "<cmd>1ToggleTerm<cr>", opts("[Toggleterm] 1번 터미널 토글"))
map("n", "<leader>t2", "<cmd>2ToggleTerm<cr>", opts("[Toggleterm] 2번 터미널 토글"))
map("n", "<leader>t3", "<cmd>3ToggleTerm<cr>", opts("[Toggleterm] 3번 터미널 토글"))

-- gitsigns / neogit / diffview (Git)
map("n", "<leader>gs", "<cmd>Neogit<cr>", opts("[Git Neogit] neogit 열기"))
map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", opts("[Git Diffview] diffview 열기"))
map("n", "<leader>gD", "<cmd>DiffviewClose<cr>", opts("[Git Diffview] diffview 닫기"))
map("n", "]h", function()
	gitsigns().next_hunk()
end, opts("[Git Gitsigns] 다음 hunk로 이동"))
map("n", "[h", function()
	gitsigns().prev_hunk()
end, opts("[Git Gitsigns] 이전 hunk로 이동"))
map("n", "<leader>gp", function()
	gitsigns().preview_hunk()
end, opts("[Git Gitsigns] hunk 미리보기"))
map("n", "<leader>gb", function()
	gitsigns().toggle_current_line_blame()
end, opts("[Git Gitsigns] blame 토글"))

-- nvim-ufo (코드 폴딩)
map("n", "zR", function()
	ufo().openAllFolds()
end, opts("[UFO] 모든 fold 열기"))
map("n", "zM", function()
	ufo().closeAllFolds()
end, opts("[UFO] 모든 fold 닫기"))
map("n", "<leader>zp", function()
	ufo().peekFoldedLinesUnderCursor()
end, opts("[UFO] fold 내용 미리보기"))

-- render-markdown (Markdown 렌더링)
map("n", "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", opts("[Render-markdown] Markdown 렌더링 토글"))

-- nvim-dap / nvim-dap-ui / nvim-dap-go (Go 디버깅)
map("n", "<F5>", function()
	dap().continue()
end, opts("[DAP] 디버깅 시작/계속"))
map("n", "<F6>", function()
	dap().terminate()
end, opts("[DAP] 디버깅 종료"))
map("n", "<F7>", function()
	dapui().toggle()
end, opts("[DAP-UI] 디버깅 UI 토글"))
map("n", "<F8>", function()
	dap().set_breakpoint(vim.fn.input("조건식: "))
end, opts("[DAP] 디버깅 조건부 브레이크포인트 설정"))
map("n", "<F9>", function()
	dap().toggle_breakpoint()
end, opts("[DAP] 디버킹 브레이크포인트 토글"))
map("n", "<F10>", function()
	dap().step_over()
end, opts("[DAP] 디버깅 Step Over"))
map("n", "<F11>", function()
	dap().step_into()
end, opts("[DAP] 디버깅 Step Into"))
map("n", "<F12>", function()
	dap().step_out()
end, opts("[DAP] 디버깅 Step Out"))
map("n", "<leader>dt", function()
	dap_go().debug_test()
end, opts("[DAP-Go] 디버깅 Go 테스트"))
map("n", "<leader>dT", function()
	local tags = vim.fn.input("빌드 태그 입력 (예: integration e2e): ")
	if tags ~= "" then
		dap_go().debug_test({ build_flags = "-tags " .. tags })
	end
end, opts("[DAP-Go] 빌드 태그와 함께 Go 테스트 디버깅"))

-- claudecode (Claude Code 통합)
map("n", "<leader>ac", "<cmd>ClaudeCode<cr>", opts("[Claude] 터미널 토글"))
map("n", "<leader>af", "<cmd>ClaudeCodeFocus<cr>", opts("[Claude] 터미널 포커스"))
map("v", "<leader>as", "<cmd>ClaudeCodeSend<cr>", opts("[Claude] 선택 영역 전송"))
map("n", "<leader>aa", "<cmd>ClaudeCodeAdd %<cr>", opts("[Claude] 현재 파일 컨텍스트 추가"))
map("n", "<leader>ay", "<cmd>ClaudeCodeDiffAccept<cr>", opts("[Claude] 변경사항 수락"))
map("n", "<leader>an", "<cmd>ClaudeCodeDiffDeny<cr>", opts("[Claude] 변경사항 거절"))

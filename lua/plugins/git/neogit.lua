-- ============================================================================
-- 파일명: git/neogit.lua
--
-- 플러그인:
--   1. lewis6991/gitsigns.nvim   - gutter에 git 변경사항 표시 및 hunk 조작
--   2. NeogitOrg/neogit          - neovim 내 git TUI (Magit 스타일)
--   3. sindrets/diffview.nvim    - 파일 변경사항 diff 뷰어
--
-- 저장소:
--   https://github.com/lewis6991/gitsigns.nvim
--   https://github.com/NeogitOrg/neogit
--   https://github.com/sindrets/diffview.nvim
--
-- 설명:
--   gitsigns  - 에디터 좌측에 추가(+)/수정(~)/삭제(-) 라인을 표시하고
--               hunk 단위로 stage/reset/preview 가능.
--   neogit    - git status, commit, push, pull 등을 TUI로 조작.
--   diffview  - 변경사항을 좌우 분할 화면으로 비교하거나
--               커밋 히스토리를 탐색할 수 있는 diff 뷰어.
--
-- 사용법:
--   neogit:
--     <leader>gs  - neogit 열기
--     s           - 파일 stage
--     u           - 파일 unstage
--     cc          - 커밋 메시지 작성 후 커밋
--     Pp          - push
--     Fl          - pull
--
--   gitsigns:
--     ]h / [h     - 다음/이전 hunk로 이동
--     <leader>gp  - hunk 변경사항 미리보기
--     <leader>gb  - 현재 줄 git blame 토글
--     <leader>gr  - hunk 되돌리기 (visual 모드: 선택 영역만)
--     <leader>gR  - 버퍼 전체 되돌리기
--
--   diffview:
--     <leader>gd  - diffview 열기 (현재 변경사항)
--     <leader>gD  - diffview 닫기
--
-- 커스텀 단축키 (config/keymaps.lua 참고):
--   <leader>gs  - neogit 열기
--   <leader>gd  - diffview 열기
--   <leader>gD  - diffview 닫기
--   ]h / [h     - 다음/이전 hunk 이동
--   <leader>gp  - hunk 미리보기
--   <leader>gb  - blame 토글
--   <leader>gr  - hunk 되돌리기
--   <leader>gR  - 버퍼 전체 되돌리기
-- ============================================================================

return {
	-- gitsigns: gutter에 git 변경사항 표시
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			signs = {
				add = { text = "▎" }, -- 추가된 라인
				change = { text = "▎" }, -- 수정된 라인
				delete = { text = "" }, -- 삭제된 라인
				topdelete = { text = "" }, -- 위쪽 삭제
				changedelete = { text = "▎" }, -- 수정+삭제
			},
			current_line_blame = false, -- 기본값: blame 비활성화 (단축키로 토글)
		},
	},

	-- diffview: 변경사항 diff 뷰어
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
	},

	-- neogit: git TUI
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim", -- diff 뷰어 통합
			"nvim-telescope/telescope.nvim", -- telescope 통합
		},
		cmd = "Neogit",
		opts = {
			integrations = {
				diffview = true, -- neogit에서 d 키로 diffview 연동
				telescope = true, -- 브랜치 선택 등에 telescope 사용
			},
		},
	},
}

-- ============================================================================
-- 파일명: git/neogit.lua
--
-- 플러그인:
--   1. NeogitOrg/neogit          - neovim 내 git TUI (Magit 스타일)
--   2. sindrets/diffview.nvim    - 파일 변경사항 diff 뷰어
--
-- 저장소:
--   https://github.com/NeogitOrg/neogit
--   https://github.com/sindrets/diffview.nvim
--
-- 설명:
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
--     l           - log 메뉴 열기
--       ll        - 현재 브랜치 커밋 로그
--       la        - 모든 브랜치 로그 (tree 형태)
--       lh        - HEAD 기준 로그
--
--   diffview:
--     <leader>gv  - diffview 열기 (현재 변경사항)
--     <leader>gV  - diffview 닫기
--     <leader>gh  - 현재 파일 커밋 히스토리
--     <leader>gH  - 브랜치 전체 커밋 히스토리
--
-- 커스텀 단축키 (config/keymaps.lua 참고):
--   <leader>gs  - neogit 열기
--   <leader>gv  - diffview 열기
--   <leader>gV  - diffview 닫기
--   <leader>gh  - 현재 파일 커밋 히스토리
--   <leader>gH  - 브랜치 전체 커밋 히스토리
-- ============================================================================

return {
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
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim",
		},
		cmd = "Neogit",
		opts = {
			integrations = {
				diffview = true,
				telescope = true,
			},
		},
	},
}

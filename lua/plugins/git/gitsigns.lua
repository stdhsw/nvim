-- ============================================================================
-- 파일명: git/gitsigns.lua
--
-- 플러그인: lewis6991/gitsigns.nvim
-- 저장소: https://github.com/lewis6991/gitsigns.nvim
--
-- 설명:
--   에디터 좌측 gutter에 git 변경사항(추가/수정/삭제)을 표시하고
--   hunk 단위로 stage/reset/preview/blame을 수행할 수 있다.
--
-- 사용법:
--   ]h / [h     - 다음/이전 hunk로 이동
--   <leader>gp  - hunk 변경사항 미리보기
--   <leader>gb  - 현재 줄 git blame 토글
--   <leader>gr  - hunk 되돌리기 (visual 모드: 선택 영역만)
--   <leader>gR  - 버퍼 전체 되돌리기
--
-- 커스텀 단축키 (config/keymaps.lua 참고):
--   ]h / [h     - 다음/이전 hunk 이동
--   <leader>gp  - hunk 미리보기
--   <leader>gb  - blame 토글
--   <leader>gr  - hunk 되돌리기
--   <leader>gR  - 버퍼 전체 되돌리기
-- ============================================================================

return {
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
			},
			current_line_blame = false,
		},
	},
}

-- ============================================================================
-- 파일명: ui-which-key.lua
--
-- 플러그인: folke/which-key.nvim
-- 저장소: https://github.com/folke/which-key.nvim
--
-- 설명:
--   leader 키 입력 후 잠시 기다리면 사용 가능한 단축키 목록을 팝업으로 표시.
--   keymaps.lua에 작성한 desc 설명이 자동으로 팝업에 표시되므로
--   단축키를 별도로 암기하지 않아도 된다.
--   spec 설정으로 prefix 그룹 이름을 지정하면 카테고리로 묶어서 표시된다.
--
--   그룹 prefix:
--   <leader>b  - 버퍼 관련 단축키
--   <leader>g  - Git 관련 단축키
--   <leader>f  - 찾기 관련 단축키
--   <leader>l  - LSP 관련 단축키
--   <leader>t  - 터미널 관련 단축키
--
-- 사용법:
--   <Space>      - leader 키 입력 후 500ms 기다리면 팝업 표시
--   <C-h>        - 팝업 표시 중 이전 페이지
--   <C-l>        - 팝업 표시 중 다음 페이지
--   <BS>         - 팝업 표시 중 한 단계 위로
--   <Esc>        - 팝업 닫기
--
-- 커스텀 단축키:
--   없음
-- ============================================================================

return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		delay = 500, -- leader 키 입력 후 팝업이 뜨기까지 대기 시간 (ms)
		icons = {
			mappings = true, -- 단축키 옆에 아이콘 표시
		},
		-- prefix 그룹 이름 지정: which-key 팝업에서 카테고리명으로 표시됨
		-- keymaps.lua에서 해당 prefix를 사용하는 단축키들이 이 그룹 아래 묶임
		spec = {
			{ "<leader>b", group = "버퍼" },
			{ "<leader>g", group = "Git" },
			{ "<leader>f", group = "찾기" },
			{ "<leader>l", group = "LSP" },
			{ "<leader>t", group = "터미널" },
		},
	},
}

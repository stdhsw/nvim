-- ============================================================================
-- 파일명: ui/toggleterm.lua
--
-- 플러그인: akinsho/toggleterm.nvim
-- 저장소: https://github.com/akinsho/toggleterm.nvim
--
-- 설명:
--   단축키로 터미널을 열고 닫을 수 있는 플러그인.
--   float, horizontal, vertical, tab 레이아웃을 지원한다.
--
-- 레이아웃 종류:
--   float      - 화면 중앙에 팝업으로 표시 (가장 많이 사용)
--   horizontal - 하단에 수평 분할로 표시
--   vertical   - 우측에 수직 분할로 표시
--   tab        - 새 탭으로 표시
--
-- 사용법:
--   <C-\>         - 터미널 토글 (기본)
--   <leader>tf    - float 터미널 토글
--   <leader>t1    - 1번 터미널 토글
--   <leader>t2    - 2번 터미널 토글
--   <leader>t3    - 3번 터미널 토글
--
--   번호 입력 후 단축키로도 터미널 전환 가능:
--   1<C-\>, 2<C-\>, 3<C-\> ...
--
--   터미널 내부에서:
--   <Esc><Esc>  - 터미널 노멀 모드로 전환 (config/keymaps.lua 설정)
--   i           - 터미널 노멀 모드 → 터미널 모드로 재진입 (config/autocmds.lua 설정)
--
-- 기본 단축키 (toggleterm 내부 설정):
--   <C-\>       - 터미널 토글
--
-- 커스텀 단축키 (config/keymaps.lua 참고):
--   <leader>tf  - float 터미널 토글
--   <leader>t1  - 1번 터미널 토글
--   <leader>t2  - 2번 터미널 토글
--   <leader>t3  - 3번 터미널 토글
-- ============================================================================

return {
	"akinsho/toggleterm.nvim",
	version = "*",
	keys = { "<C-\\>", "<leader>tf" }, -- 단축키 입력 시 로드
	opts = {
		size = function(term)
			if term.direction == "horizontal" then
				return 15 -- 하단 터미널 높이
			elseif term.direction == "vertical" then
				return math.floor(vim.o.columns * 0.4) -- 우측 터미널 너비 (40%)
			end
		end,
		-- 터미널 토글 단축키
		open_mapping = [[<C-\>]],
		-- 레이아웃
		direction = "float",
		float_opts = {
			border = "rounded", -- float 터미널 테두리 스타일
		},
		-- 터미널이 열릴 때마다 무조건 터미널 모드로 진입
		-- vim.schedule 로 지연 호출하지 않으면 toggleterm 내부 처리 전에
		-- startinsert 가 실행되어 마우스 클릭 후 재오픈 시 무시될 수 있음
		on_open = function(_)
			vim.schedule(function()
				vim.cmd("startinsert!")
			end)
		end,
	},
}

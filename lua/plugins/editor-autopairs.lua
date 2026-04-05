-- ============================================================================
-- 파일명: editor-autopairs.lua
--
-- 플러그인: windwp/nvim-autopairs
-- 저장소: https://github.com/windwp/nvim-autopairs
--
-- 설명:
--   괄호, 따옴표 등을 입력하면 닫는 쌍을 자동으로 추가해주는 플러그인.
--   nvim-cmp와 연동하여 자동완성 확정 시 함수 괄호를 자동으로 추가한다.
--
-- 동작 예시:
--   (  →  ()   커서가 가운데 위치
--   "  →  ""
--   {  →  {}
--   이미 ) 가 있는 경우 → 커서만 이동 (중복 입력 방지)
--   ( + <CR>  →  자동 들여쓰기와 함께 괄호 펼쳐짐
--
-- 사용법:
--   별도 조작 없이 insert 모드에서 자동으로 동작한다.
--
-- 커스텀 단축키:
--   없음
-- ============================================================================

return {
	"windwp/nvim-autopairs",
	event = "InsertEnter", -- insert 모드 진입 시 로드
	dependencies = { "hrsh7th/nvim-cmp" },
	config = function()
		local autopairs = require("nvim-autopairs")
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		local cmp = require("cmp")

		autopairs.setup({
			check_ts = true, -- treesitter로 문맥 파악 (문자열/주석 내부에서는 자동완성 비활성화)
		})

		-- nvim-cmp 자동완성 확정 시 함수 괄호 자동 추가
		-- 예: fmt.Println 선택 시 → fmt.Println() 으로 자동 완성
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
	end,
}

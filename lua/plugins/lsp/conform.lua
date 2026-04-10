-- ============================================================================
-- 파일명: lsp/conform.lua
--
-- 플러그인: stevearc/conform.nvim
-- 저장소: https://github.com/stevearc/conform.nvim
--
-- 설명:
--   파일 저장 시 자동으로 포매터를 실행하는 플러그인.
--   언어별 포매터는 lua/extras/lang/ 의 각 파일에서 관리한다.
--   (extras의 opts function이 formatters_by_ft에 포매터를 추가)
--
-- 사용법:
--   파일 저장(:w) 시 자동으로 실행된다.
--   :ConformInfo  - 현재 버퍼에 적용되는 포매터 확인
--
-- 커스텀 단축키 (config/keymaps.lua 참고):
--   <leader>lf  - 현재 파일 수동 포맷
-- ============================================================================

return {
	"stevearc/conform.nvim",
	event = "BufWritePre",
	opts = {
		-- 언어별 포매터는 extras에서 채움
		formatters_by_ft = {},
		-- 큰 Go/Python 파일에서 gofumpt + goimports 동기 실행이 500ms 안에 못 끝나
		-- 저장 lag 으로 이어지는 경우가 있어 timeout 을 1초로 늘림.
		-- timeout 안에 못 끝나면 conform 이 자동으로 포기하고 저장만 진행한다.
		format_on_save = {
			timeout_ms = 1000,
			lsp_fallback = true,
		},
	},
}

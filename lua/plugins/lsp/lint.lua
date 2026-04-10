-- ============================================================================
-- 파일명: lsp/lint.lua
--
-- 플러그인: mfussenegger/nvim-lint
-- 저장소: https://github.com/mfussenegger/nvim-lint
--
-- 설명:
--   LSP가 지원하지 않는 외부 린터를 통합 관리하는 플러그인.
--   언어별 린터는 lua/extras/lang/ 의 각 파일에서 관리한다.
--   (extras의 opts function이 linters_by_ft에 린터를 추가)
--
-- 사용법:
--   파일 열기 및 저장 시 자동 실행된다.
--   진단 결과는 <leader>ld 로 상세 확인, ]d / [d 로 이동 가능.
--   :lua require("lint").try_lint()  - 현재 버퍼 수동 린트 실행
--
-- 커스텀 단축키:
--   없음 (LSP 단축키와 공유: ]d, [d, <leader>ld)
-- ============================================================================

return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPost", "BufWritePost" },
	-- extras에서 opts function으로 linters_by_ft에 린터를 추가한다.
	opts = {
		linters_by_ft = {}, -- extras에서 채움
	},
	config = function(_, opts)
		local lint = require("lint")
		lint.linters_by_ft = opts.linters_by_ft

		vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}

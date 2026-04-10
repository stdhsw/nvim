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
	-- event: lazy 로드 트리거 (이 이벤트가 처음 발생할 때 플러그인 로드)
	event = { "BufReadPost", "BufNewFile", "BufWritePost" },
	-- extras에서 opts function으로 linters_by_ft에 린터를 추가한다.
	opts = {
		linters_by_ft = {}, -- extras에서 채움
	},
	config = function(_, opts)
		local lint = require("lint")
		lint.linters_by_ft = opts.linters_by_ft

		-- 실제 린팅 트리거 (nvim-lint 권장 이벤트)
		--   BufReadPost / BufNewFile : 새 파일 진입 시
		--   BufWritePost             : 저장 후
		--   InsertLeave              : 코드 작성 후 normal 모드로 돌아왔을 때
		vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufWritePost", "InsertLeave" }, {
			group = vim.api.nvim_create_augroup("nvim_lint_trigger", { clear = true }),
			callback = function()
				lint.try_lint()
			end,
		})

		-- lazy 로드를 트리거한 첫 버퍼는 위 autocmd 가 등록되기 전에 이벤트가 끝났으므로
		-- 한 번 명시적으로 린팅을 호출해야 즉시 진단이 표시된다.
		lint.try_lint()
	end,
}

-- ============================================================================
-- 파일명: lsp-lint.lua
--
-- 플러그인: mfussenegger/nvim-lint
-- 저장소: https://github.com/mfussenegger/nvim-lint
--
-- 설명:
--   LSP가 지원하지 않는 외부 린터를 통합 관리하는 플러그인.
--   파일 열기 및 저장 시 자동으로 린터를 실행하고 진단 결과를 표시한다.
--   진단 결과는 LSP 진단과 동일한 방식으로 표시된다 (gutter 아이콘, 밑줄).
--
--   적용 린터:
--   shellcheck - Bash/Shell 스크립트 버그 및 안티패턴 감지
--   hadolint   - Dockerfile 베스트 프랙티스 위반 감지
--
--   린터 설치 (neovim 시작 후 실행):
--   :MasonInstall shellcheck hadolint
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
	event = { "BufReadPost", "BufWritePost" }, -- 파일 열 때 및 저장 시 실행
	config = function()
		local lint = require("lint")

		-- 언어별 린터 지정
		lint.linters_by_ft = {
			sh = { "shellcheck" }, -- Bash/Shell 스크립트
			dockerfile = { "hadolint" }, -- Dockerfile
		}

		-- 파일 저장 및 열 때 자동으로 린트 실행
		vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}

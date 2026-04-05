-- ============================================================================
-- 파일명: lsp-conform.lua
--
-- 플러그인: stevearc/conform.nvim
-- 저장소: https://github.com/stevearc/conform.nvim
--
-- 설명:
--   파일 저장 시 자동으로 포매터를 실행하는 플러그인.
--   언어별 포매터를 순서대로 실행하며, 포매터가 없으면 LSP 포맷으로 fallback.
--
--   적용 포매터:
--   Go     - gofumpt (엄격한 포맷) → goimports (import 정리)
--   Python - black (PEP8 포맷) → isort (import 순서 정렬)
--   YAML   - prettier
--   JSON   - prettier
--   Bash   - shfmt
--   SQL    - sqlfluff
--   Lua    - stylua
--
--   포매터 설치 방법:
--   go install mvdan.cc/gofumpt@latest
--   go install golang.org/x/tools/cmd/goimports@latest
--   pip install black isort sqlfluff
--   npm install -g prettier
--   brew install shfmt
--   brew install stylua
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
	event = "BufWritePre", -- 저장 직전에 로드
	opts = {
		formatters_by_ft = {
			-- 순서대로 실행: gofumpt 포맷 후 goimports로 import 정리
			go = { "gofumpt", "goimports" },
			python = { "black", "isort" },
			yaml = { "prettier" },
			json = { "prettier" },
			sh = { "shfmt" },
			sql = { "sqlfluff" },
			lua = { "stylua" },
		},
		format_on_save = {
			timeout_ms = 500, -- 포맷 타임아웃 (ms). 초과 시 저장만 진행
			lsp_fallback = true, -- 포매터가 없는 언어는 LSP 포맷으로 대체
		},
	},
}

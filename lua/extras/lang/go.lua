-- ============================================================================
-- 파일명: extras/lang/go.lua
--
-- 설명:
--   Go 언어 지원 extra.
--   LSP, 포매터, 린터, Treesitter 파서, DAP 디버거를 한 파일에서 관리한다.
--
-- 포함 구성:
--   LSP       - gopls (Go 공식 LSP)
--   포매터    - gofumpt (엄격한 포맷) → goimports (import 정렬)
--   린터      - (gopls staticcheck으로 대체)
--   파서      - go, gomod, gosum, gowork
--   DAP       - nvim-dap-go (delve 연동)
--
-- 사전 요구사항:
--   go install mvdan.cc/gofumpt@latest
--   go install golang.org/x/tools/cmd/goimports@latest
--   brew install delve
-- ============================================================================

return {
	-- Mason: gopls 자동 설치
	{
		"williamboman/mason-lspconfig.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "gopls" })
		end,
	},

	-- LSP: gopls 설정 및 활성화
	{
		"neovim/nvim-lspconfig",
		opts = function(_, opts)
			opts.servers = opts.servers or {}
			opts.configs = opts.configs or {}

			table.insert(opts.servers, "gopls")
			opts.configs.gopls = {
				settings = {
					gopls = {
						analyses = { unusedparams = true }, -- 사용하지 않는 파라미터 경고
						staticcheck = true, -- 정적 분석 활성화
						-- inlay hints: 코드에 타입/파라미터 힌트를 인라인으로 표시
						hints = {
							parameterNames = true, -- 함수 인자 이름 표시
							assignVariableTypes = true, -- 변수 타입 표시
							compositeLiteralFields = true, -- 구조체 필드명 표시
							functionTypeParameters = true, -- 제네릭 타입 파라미터 표시
							rangeVariableTypes = true, -- range 변수 타입 표시
						},
					},
				},
			}
		end,
	},

	-- Treesitter: Go 파서 설치
	-- init은 config보다 먼저 실행되어 vim.g.extra_treesitter_parsers에 파서를 추가
	{
		"nvim-treesitter/nvim-treesitter",
		init = function()
			vim.g.extra_treesitter_parsers = vim.g.extra_treesitter_parsers or {}
			vim.list_extend(vim.g.extra_treesitter_parsers, { "go", "gomod", "gosum", "gowork" })
		end,
	},

	-- Conform: Go 포매터 등록
	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			opts.formatters_by_ft = opts.formatters_by_ft or {}
			-- gofumpt: 엄격한 포맷 (gofmt 상위 호환)
			-- goimports: import 구문 자동 정렬/추가/제거
			opts.formatters_by_ft.go = { "gofumpt", "goimports" }
		end,
	},

	-- DAP: Go 디버거 (debug/dap.lua에서 전체 DAP 설정 관리)
}

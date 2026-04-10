-- ============================================================================
-- 파일명: extras/lang/ops.lua
--
-- 설명:
--   인프라/운영 관련 언어 지원 extra.
--   YAML, JSON, Bash, Dockerfile, SQL, Makefile을 한 파일에서 관리한다.
--
-- 포함 구성:
--   LSP       - yamlls (YAML + K8s 스키마), jsonls, bashls, dockerls
--   포매터    - prettier (yaml/json), shfmt (bash), sqlfluff (sql)
--   린터      - shellcheck (bash), hadolint (dockerfile)
--   파서      - yaml, json, bash, dockerfile, sql, make
--
-- 사전 요구사항:
--   npm install -g prettier
--   brew install shfmt
--   pip install sqlfluff
--   shellcheck / hadolint 는 mason-tool-installer 가 자동 설치
-- ============================================================================

return {
	-- Mason: LSP 서버 자동 설치
	{
		"williamboman/mason-lspconfig.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, {
				"yamlls", -- YAML / K8s
				"jsonls", -- JSON
				"bashls", -- Bash
				"dockerls", -- Dockerfile
			})
		end,
	},

	-- LSP: 서버 설정 및 활성화
	{
		"neovim/nvim-lspconfig",
		opts = function(_, opts)
			opts.servers = opts.servers or {}
			opts.configs = opts.configs or {}

			vim.list_extend(opts.servers, { "yamlls", "jsonls", "bashls", "dockerls" })

			-- yamlls: YAML + Kubernetes 스키마 검증
			opts.configs.yamlls = {
				settings = {
					yaml = {
						validate = true,
						schemaStore = {
							enable = true, -- 파일명/내용 기반 스키마 자동 감지
							url = "https://www.schemastore.org/api/json/catalog.json",
						},
						schemas = {
							-- K8s 스키마는 명시적 경로 패턴에만 적용
							kubernetes = {
								"k8s/**/*.yaml",
								"kubernetes/**/*.yaml",
								"manifests/**/*.yaml",
							},
						},
					},
				},
			}
		end,
	},

	-- Treesitter: 파서 설치
	{
		"nvim-treesitter/nvim-treesitter",
		init = function()
			vim.g.extra_treesitter_parsers = vim.g.extra_treesitter_parsers or {}
			vim.list_extend(vim.g.extra_treesitter_parsers, {
				"yaml",
				"json",
				"bash",
				"dockerfile",
				"sql",
				"make",
			})
		end,
	},

	-- Conform: 포매터 등록
	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			opts.formatters_by_ft = opts.formatters_by_ft or {}
			opts.formatters_by_ft.yaml = { "prettier" }
			opts.formatters_by_ft.json = { "prettier" }
			opts.formatters_by_ft.sh = { "shfmt" }
			opts.formatters_by_ft.sql = { "sqlfluff" }
		end,
	},

	-- nvim-lint: 린터 등록
	{
		"mfussenegger/nvim-lint",
		opts = function(_, opts)
			opts.linters_by_ft = opts.linters_by_ft or {}
			opts.linters_by_ft.sh = { "shellcheck" }
			opts.linters_by_ft.dockerfile = { "hadolint" }
		end,
	},

	-- mason-tool-installer: 린터 자동 설치 (mason-lspconfig 는 LSP 서버만 다루므로)
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "shellcheck", "hadolint" })
		end,
	},
}

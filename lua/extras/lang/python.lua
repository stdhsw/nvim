-- ============================================================================
-- 파일명: extras/lang/python.lua
--
-- 설명:
--   Python 언어 지원 extra.
--   LSP, 포매터, Treesitter 파서를 한 파일에서 관리한다.
--
-- 포함 구성:
--   LSP       - pyright (정적 타입 분석 기반 LSP)
--   포매터    - black (PEP8 포맷) → isort (import 순서 정렬)
--   파서      - python
--
-- 사전 요구사항:
--   pip install black isort
-- ============================================================================

return {
	-- Mason: pyright 자동 설치
	{
		"williamboman/mason-lspconfig.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "pyright" })
		end,
	},

	-- LSP: pyright 설정 및 활성화
	{
		"neovim/nvim-lspconfig",
		opts = function(_, opts)
			opts.servers = opts.servers or {}
			table.insert(opts.servers, "pyright")
		end,
	},

	-- Treesitter: Python 파서 설치
	{
		"nvim-treesitter/nvim-treesitter",
		init = function()
			vim.g.extra_treesitter_parsers = vim.g.extra_treesitter_parsers or {}
			vim.list_extend(vim.g.extra_treesitter_parsers, { "python" })
		end,
	},

	-- Conform: Python 포매터 등록
	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			opts.formatters_by_ft = opts.formatters_by_ft or {}
			-- black: PEP8 스타일 포맷
			-- isort: import 구문 자동 정렬
			opts.formatters_by_ft.python = { "black", "isort" }
		end,
	},
}

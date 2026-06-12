-- ============================================================================
-- 파일명: extras/util.lua
--
-- 설명:
--   extras/lang/ 의 각 언어 파일에서 반복되던 lazy.nvim spec 조각을 생성하는
--   공통 헬퍼 모듈. 동일한 플러그인에 대해 ensure_installed / servers / parsers /
--   formatters / linters 를 추가하는 보일러플레이트(opts function + or-default +
--   list_extend)를 한 곳으로 모은다.
--
--   각 함수는 lazy.nvim 플러그인 spec 테이블(조각)을 반환한다. 동일 플러그인에
--   대한 여러 조각은 lazy.nvim 이 자동으로 병합하므로, 여러 언어 extras 가 같은
--   플러그인(mason-lspconfig 등)에 각자 항목을 더해도 충돌 없이 합산된다.
--
-- 사용 예 (extras/lang/<언어>.lua):
--   local util = require("extras.util")
--   return {
--     util.mason_lsp({ "gopls" }),
--     util.lsp({ "gopls" }, { gopls = { settings = {...} } }),
--     util.treesitter({ "go", "gomod" }),
--     util.formatters({ go = { "gofumpt", "goimports" } }),
--   }
-- ============================================================================

local M = {}

-- mason-lspconfig: LSP 서버 자동 설치 목록(ensure_installed)에 servers 추가.
function M.mason_lsp(servers)
	return {
		"williamboman/mason-lspconfig.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, servers)
		end,
	}
end

-- mason-tool-installer: 포매터/린터/DAP 등 도구 자동 설치 목록에 tools 추가.
function M.mason_tools(tools)
	return {
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, tools)
		end,
	}
end

-- nvim-lspconfig: LSP 서버 활성화 목록(servers)에 추가하고, 서버별 세부 설정을 주입.
--   servers : { "gopls", ... }
--   configs : { gopls = { settings = {...} } }  (선택, 없으면 nil)
function M.lsp(servers, configs)
	return {
		"neovim/nvim-lspconfig",
		opts = function(_, opts)
			opts.servers = opts.servers or {}
			opts.configs = opts.configs or {}
			vim.list_extend(opts.servers, servers)
			for name, cfg in pairs(configs or {}) do
				opts.configs[name] = cfg
			end
		end,
	}
end

-- nvim-treesitter: 언어 파서 설치 목록에 parsers 추가.
-- init 단계에서 vim.g.extra_treesitter_parsers 에 누적하고, treesitter.lua 의
-- config 가 base_parsers 와 합산하여 설치한다.
function M.treesitter(parsers)
	return {
		"nvim-treesitter/nvim-treesitter",
		init = function()
			vim.g.extra_treesitter_parsers = vim.g.extra_treesitter_parsers or {}
			vim.list_extend(vim.g.extra_treesitter_parsers, parsers)
		end,
	}
end

-- conform.nvim: filetype 별 포매터 등록.
--   by_ft : { go = { "gofumpt", "goimports" }, lua = { "stylua" } }
function M.formatters(by_ft)
	return {
		"stevearc/conform.nvim",
		opts = function(_, opts)
			opts.formatters_by_ft = opts.formatters_by_ft or {}
			for ft, list in pairs(by_ft) do
				opts.formatters_by_ft[ft] = list
			end
		end,
	}
end

-- nvim-lint: filetype 별 린터 등록.
--   by_ft : { sh = { "shellcheck" }, dockerfile = { "hadolint" } }
function M.linters(by_ft)
	return {
		"mfussenegger/nvim-lint",
		opts = function(_, opts)
			opts.linters_by_ft = opts.linters_by_ft or {}
			for ft, list in pairs(by_ft) do
				opts.linters_by_ft[ft] = list
			end
		end,
	}
end

return M

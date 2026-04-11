-- ============================================================================
-- 파일명: extras/lang/lua.lua
--
-- 설명:
--   Lua 언어 지원 extra (neovim 설정 작성에 최적화).
--   LSP, 포매터를 한 파일에서 관리한다.
--   treesitter lua 파서는 plugins/editor/treesitter.lua 의 base_parsers 에
--   이미 포함되어 있으므로 여기서 추가하지 않는다.
--
-- 포함 구성:
--   LSP       - lua_ls (vim 전역 인식, neovim runtime 라이브러리 포함)
--   포매터    - stylua (BufWritePre 시 conform.nvim 으로 자동 실행)
--
-- 사전 요구사항:
--   stylua 와 lua-language-server 는 mason-tool-installer 가 자동 설치한다.
--   (이미 brew 로 설치된 stylua 도 PATH 에 있으면 사용 가능)
--
-- 설정 파일:
--   stylua 설정은 프로젝트 루트의 stylua.toml 또는 .stylua.toml 에서 관리한다.
--   파일이 없으면 stylua 기본값 사용 (탭 들여쓰기, 120 컬럼 폭).
-- ============================================================================

return {
	-- Mason: lua-language-server 자동 설치
	{
		"williamboman/mason-lspconfig.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "lua_ls" })
		end,
	},

	-- LSP: lua_ls 설정 및 활성화
	-- neovim 설정 파일 작성에 필요한 vim 전역 인식 + runtime 라이브러리 등록
	{
		"neovim/nvim-lspconfig",
		opts = function(_, opts)
			opts.servers = opts.servers or {}
			opts.configs = opts.configs or {}

			table.insert(opts.servers, "lua_ls")

			-- lua_ls: neovim 설정 작성용 세팅
			--   runtime.version  - LuaJIT 런타임 (neovim 내장)
			--   diagnostics.globals - vim 전역 변수를 미정의 경고에서 제외
			--   workspace.library - neovim runtime 파일을 라이브러리로 등록
			--                       (vim.api, vim.fn 등 자동완성 활성화)
			--   telemetry.enable - 사용 통계 전송 비활성화
			opts.configs.lua_ls = {
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							checkThirdParty = false,
							library = vim.api.nvim_get_runtime_file("", true),
						},
						telemetry = {
							enable = false,
						},
					},
				},
			}
		end,
	},

	-- Conform: Lua 포매터 등록
	-- stylua: 저장 시 자동 포맷 (conform.nvim format_on_save 가 BufWritePre 에서 실행)
	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			opts.formatters_by_ft = opts.formatters_by_ft or {}
			opts.formatters_by_ft.lua = { "stylua" }
		end,
	},

	-- mason-tool-installer: stylua 자동 설치
	-- (Homebrew 로 설치된 stylua 도 PATH 에서 사용 가능하지만,
	--  팀원/다른 환경에서도 동일하게 동작하도록 mason 으로도 관리)
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "stylua" })
		end,
	},
}

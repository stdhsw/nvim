-- ============================================================================
-- 파일명: lsp-mason.lua
--
-- 플러그인: williamboman/mason.nvim
--           williamboman/mason-lspconfig.nvim
-- 저장소: https://github.com/williamboman/mason.nvim
--         https://github.com/williamboman/mason-lspconfig.nvim
--
-- 설명:
--   mason      - LSP 서버, 포매터, 린터를 neovim 안에서 설치/업데이트/삭제 관리.
--                설치된 바이너리는 ~/.local/share/nvim/mason/bin/ 에 저장된다.
--   mason-lspconfig - mason으로 설치한 LSP 서버를 lspconfig에 자동 연결.
--                     ensure_installed 목록의 서버를 neovim 시작 시 자동 설치.
--
--   자동 설치 LSP 서버:
--   gopls    - Go          pyright  - Python
--   yamlls   - YAML/K8s   jsonls   - JSON
--   bashls   - Bash        dockerls - Dockerfile
--
--   수동 설치 필요한 린터 (자동 설치 안됨):
--   :MasonInstall shellcheck hadolint
--
-- 사용법:
--   :Mason                       - GUI로 설치 목록 관리 (j/k 이동, i 설치, X 삭제)
--   :MasonInstall <패키지명>     - 패키지 설치
--   :MasonUninstall <패키지명>   - 패키지 삭제
--   :MasonUpdate                 - 설치된 패키지 전체 업데이트
--   :MasonLog                    - 설치 로그 확인
--
-- 커스텀 단축키:
--   없음
-- ============================================================================

return {
	"williamboman/mason.nvim",
	dependencies = { "williamboman/mason-lspconfig.nvim" },
	config = function()
		require("mason").setup({
			ui = {
				border = "rounded",
				icons = {
					package_installed = "✅",
					package_pending = "⏳",
					package_uninstalled = "⬜",
				},
			},
		})

		require("mason-lspconfig").setup({
			-- neovim 시작 시 미설치 서버를 자동으로 설치
			ensure_installed = {
				"gopls", -- Go
				"pyright", -- Python
				"yamlls", -- YAML / K8s
				"jsonls", -- JSON
				"bashls", -- Bash
				"dockerls", -- Dockerfile
			},
			-- ensure_installed 외에 수동으로 설치한 서버도 자동 연결
			automatic_installation = true,
		})
	end,
}

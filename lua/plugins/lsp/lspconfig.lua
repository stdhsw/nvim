-- ============================================================================
-- 파일명: lsp/lspconfig.lua
--
-- 플러그인: neovim/nvim-lspconfig
-- 저장소: https://github.com/neovim/nvim-lspconfig
--
-- 설명:
--   LSP(Language Server Protocol) 서버와 neovim을 연결하는 플러그인.
--   neovim 0.11+의 vim.lsp.config / vim.lsp.enable API를 사용한다.
--   (구 API: require("lspconfig").server.setup() 방식은 deprecated)
--
--   언어별 LSP 서버 설정은 lua/extras/lang/ 의 각 파일에서 관리한다.
--   이 파일은 공통 capabilities 설정과 extras에서 주입된 서버를 활성화하는
--   역할만 담당한다.
--
-- 사용법:
--   :LspInfo     - 현재 버퍼의 LSP 서버 연결 상태 확인
--   :LspLog      - LSP 로그 확인 (오류 디버깅 시 사용)
--   :LspRestart  - LSP 서버 재시작
--
-- 커스텀 단축키 (config/keymaps.lua 참고):
--   gd           - 정의로 이동
--   gD           - 선언으로 이동
--   gi           - 구현으로 이동
--   gr           - 참조 찾기 (telescope로 표시)
--   K            - hover 문서 표시
--   <leader>lk   - 함수 시그니처 표시
--   <leader>lr   - 이름 변경 (rename)
--   <leader>la   - 코드 액션 (자동 수정, import 추가 등)
--   <leader>ld   - 진단 상세 메시지 팝업
--   <leader>lf   - 포맷 (conform → LSP fallback)
--   ]d / [d      - 다음/이전 진단으로 이동
-- ============================================================================

return {
	"neovim/nvim-lspconfig",
	dependencies = { "williamboman/mason-lspconfig.nvim", "saghen/blink.cmp" },
	lazy = false,
	-- extras에서 opts function으로 서버와 설정을 주입한다.
	-- opts.servers  : 활성화할 LSP 서버 목록 (예: { "gopls", "pyright" })
	-- opts.configs  : 서버별 세부 설정 (예: { gopls = { settings = {...} } })
	opts = {
		servers = {},
		configs = {},
	},
	config = function(_, opts)
		-- blink.cmp와 연동하여 LSP 자동완성 항목을 전달하는 capabilities 설정
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		-- 모든 LSP 서버에 공통으로 적용되는 설정
		vim.lsp.config("*", {
			capabilities = capabilities,
		})

		-- extras에서 주입된 서버별 세부 설정 적용
		for server, config in pairs(opts.configs or {}) do
			vim.lsp.config(server, config)
		end

		-- extras에서 주입된 LSP 서버 활성화
		if opts.servers and #opts.servers > 0 then
			vim.lsp.enable(opts.servers)
		end
	end,
}

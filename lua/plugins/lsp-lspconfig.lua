-- ============================================================================
-- 파일명: lsp-lspconfig.lua
--
-- 플러그인: neovim/nvim-lspconfig
-- 저장소: https://github.com/neovim/nvim-lspconfig
--
-- 설명:
--   LSP(Language Server Protocol) 서버와 neovim을 연결하는 플러그인.
--   neovim 0.11+의 vim.lsp.config / vim.lsp.enable API를 사용한다.
--   (구 API: require("lspconfig").server.setup() 방식은 deprecated)
--
--   활성화된 LSP 서버:
--   gopls    - Go 공식 LSP. 타입 추론, 자동완성, import 관리, inlay hints
--   pyright  - Python 정적 타입 분석 기반 LSP
--   yamlls   - YAML LSP. Kubernetes manifest 스키마 검증 포함
--   jsonls   - JSON 스키마 검증 및 자동완성
--   bashls   - Bash/Shell 스크립트 자동완성 및 오류 감지
--   dockerls - Dockerfile 명령어 자동완성 및 문법 검사
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
	dependencies = { "williamboman/mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp" },
	lazy = false, -- 시작 시 즉시 로드 (지연 로드 시 첫 파일에서 LSP 미연결)
	config = function()
		-- nvim-cmp와 연동하여 LSP 자동완성 항목을 cmp에 전달하는 capabilities 설정
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- 모든 LSP 서버에 공통으로 적용되는 설정
		vim.lsp.config("*", {
			capabilities = capabilities,
		})

		-- gopls: Go 공식 LSP 서버 설정
		vim.lsp.config("gopls", {
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
		})

		-- yamlls: YAML LSP 서버 설정 (K8s manifest 검증 포함)
		vim.lsp.config("yamlls", {
			settings = {
				yaml = {
					validate = true, -- YAML 문법 검증 활성화
					schemas = {
						kubernetes = "*.yaml", -- 모든 .yaml 파일에 K8s 스키마 적용
					},
				},
			},
		})

		-- LSP 서버 활성화 (vim.lsp.enable = 서버를 neovim에 등록)
		vim.lsp.enable({
			"gopls",
			"pyright",
			"yamlls",
			"jsonls",
			"bashls",
			"dockerls",
		})
	end,
}

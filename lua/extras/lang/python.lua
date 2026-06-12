-- ============================================================================
-- 파일명: extras/lang/python.lua
--
-- 설명:
--   Python 언어 지원 extra.
--   LSP, 포매터, Treesitter 파서, DAP 디버거를 한 파일에서 관리한다.
--
-- 포함 구성:
--   LSP       - pyright (정적 타입 분석 기반 LSP)
--   포매터    - black (PEP8 포맷) → isort (import 순서 정렬)
--   파서      - python
--   DAP       - debugpy (Python 디버거, plugins/debug/dap.lua 의 nvim-dap-python 이 사용)
--
-- 사전 요구사항:
--   pip install black isort
--   debugpy 는 mason-tool-installer 가 자동 설치
-- ============================================================================

local util = require("extras.util")

return {
	-- Mason: pyright 자동 설치
	util.mason_lsp({ "pyright" }),

	-- LSP: pyright 설정 및 활성화
	util.lsp({ "pyright" }),

	-- Treesitter: Python 파서 설치
	util.treesitter({ "python" }),

	-- Conform: black(PEP8 스타일 포맷) → isort(import 구문 자동 정렬)
	util.formatters({ python = { "black", "isort" } }),

	-- mason-tool-installer: debugpy (Python DAP 어댑터) 자동 설치
	-- 실제 어댑터 등록은 plugins/debug/dap.lua 의 nvim-dap-python 에서 수행한다.
	util.mason_tools({ "debugpy" }),
}

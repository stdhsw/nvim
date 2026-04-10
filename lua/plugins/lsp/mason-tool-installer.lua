-- ============================================================================
-- 파일명: lsp/mason-tool-installer.lua
--
-- 플러그인: WhoIsSethDaniel/mason-tool-installer.nvim
-- 저장소: https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
--
-- 설명:
--   mason 으로 설치 가능한 도구(LSP / 포매터 / 린터 / DAP)를
--   ensure_installed 리스트에 명시하면 nvim 시작 시 자동 설치한다.
--   mason-lspconfig 의 ensure_installed 는 LSP 서버만 다루므로,
--   shellcheck / hadolint 같은 외부 린터는 이 플러그인으로 자동 설치한다.
--
--   ensure_installed 는 lua/extras/lang/ 의 각 파일에서 opts function 으로 추가한다.
--
-- 사용법:
--   :MasonToolsInstall       - ensure_installed 목록의 도구 즉시 설치
--   :MasonToolsUpdate        - 설치된 도구 업데이트
--   :MasonToolsClean         - ensure_installed 에 없는 도구 제거
--
-- 커스텀 단축키:
--   없음
-- ============================================================================

return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	dependencies = { "williamboman/mason.nvim" },
	event = "VeryLazy",
	-- extras 에서 opts function 으로 ensure_installed 에 도구를 추가한다.
	opts = {
		ensure_installed = {}, -- extras 에서 채움
		run_on_start = true, -- nvim 시작 시 미설치 도구 자동 설치
		auto_update = false, -- 자동 업데이트 비활성화 (수동 :MasonToolsUpdate)
	},
}

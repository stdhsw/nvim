-- ============================================================================
-- 파일명: input/im-select.lua
--
-- 플러그인: keaising/im-select.nvim
-- 저장소: https://github.com/keaising/im-select.nvim
--
-- 설명:
--   neovim 모드 전환 시 입력기(Input Method)를 자동으로 전환하는 플러그인.
--   Insert 모드를 벗어나 Normal / Visual / Command 모드로 전환될 때
--   자동으로 영어 입력기로 전환하여 단축키 오작동을 방지한다.
--   Insert 모드 재진입 시에는 자동 복원하지 않으며, 한국어 전환은
--   사용자가 직접 수행한다.
--
-- 사전 요구사항:
--   brew install im-select
--
-- 사용법:
--   별도 조작 없이 모드 전환 시 자동으로 동작한다.
--   - Insert 모드 탈출 → 영어 입력기로 자동 전환
--   - Insert 모드 진입 → 입력기 자동 복원 없음 (사용자가 직접 전환)
--
-- 기본 단축키:
--   없음 (자동 동작)
--
-- 입력기 식별자 (macOS):
--   영어: com.apple.keylayout.ABC
--   한국어: com.apple.inputmethod.Korean.2SetKorean
-- ============================================================================

return {
	"keaising/im-select.nvim",
	lazy = false,
	config = function()
		require("im_select").setup({
			-- Insert 모드 탈출 시 전환할 영어 입력기 식별자
			default_im_select = "com.apple.keylayout.ABC",

			-- im-select CLI 경로 (brew install im-select)
			default_command = "im-select",

			-- Insert 모드 재진입 시 자동 복원 비활성화 (한국어 전환은 사용자가 직접)
			set_previous_events = {},
			-- Insert/Cmdline 탈출 + 다른 앱에서 nvim 으로 포커스 복귀 시 영문 입력기로 전환
			set_default_events = { "InsertLeave", "CmdlineLeave", "FocusGained" },
		})
	end,
}

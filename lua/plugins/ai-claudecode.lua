-- ============================================================================
-- 파일명: ai-claudecode.lua
--
-- 플러그인: coder/claudecode.nvim
-- 저장소: https://github.com/coder/claudecode.nvim
--
-- 설명:
--   Claude Code CLI와 Neovim을 연결하는 공식 IDE 통합 플러그인.
--   WebSocket 기반 MCP(Model Context Protocol)로 VS Code 확장과 동일한 방식으로 동작.
--   현재 편집 중인 파일과 선택 영역을 Claude가 실시간으로 인식한다.
--
--   주요 기능:
--   - Claude Code 터미널을 Neovim 내에서 토글
--   - 선택한 코드를 Claude에게 직접 전송
--   - 파일을 Claude 컨텍스트에 추가
--   - Claude가 제안한 변경사항을 diff로 확인 후 수락/거절
--   - 현재 커서 위치 및 선택 영역 실시간 공유
--
-- 사전 요구사항:
--   Claude Code CLI 설치 필요
--   npm install -g @anthropic-ai/claude-code
--   또는 https://claude.ai/code 에서 설치
--
-- 사용법:
--   :ClaudeCode                  - Claude 터미널 토글
--   :ClaudeCodeFocus             - Claude 터미널 포커스/토글
--   :ClaudeCodeSend              - 선택 영역을 Claude에 전송 (Visual 모드)
--   :ClaudeCodeAdd <파일경로>    - 파일을 Claude 컨텍스트에 추가
--   :ClaudeCodeDiffAccept        - Claude 제안 변경사항 수락
--   :ClaudeCodeDiffDeny          - Claude 제안 변경사항 거절
--   :ClaudeCodeCloseAllDiffTabs  - 모든 diff 창 닫기
--
-- 커스텀 단축키 (config/keymaps.lua 참고):
--   <leader>ac  - Claude 터미널 토글
--   <leader>af  - Claude 터미널 포커스
--   <leader>as  - 선택 영역 Claude에 전송 (Visual 모드)
--   <leader>aa  - 현재 파일 Claude 컨텍스트에 추가
--   <leader>ay  - Claude 제안 변경사항 수락 (Yes)
--   <leader>an  - Claude 제안 변경사항 거절 (No)
-- ============================================================================

return {
	"coder/claudecode.nvim",
	lazy = true,
	cmd = {
		"ClaudeCode",
		"ClaudeCodeFocus",
		"ClaudeCodeSend",
		"ClaudeCodeAdd",
		"ClaudeCodeDiffAccept",
		"ClaudeCodeDiffDeny",
		"ClaudeCodeCloseAllDiffTabs",
	},
	opts = {
		-- 터미널 백엔드: snacks.nvim 없이 neovim 기본 터미널 사용
		terminal_provider = "native",

		-- 포트 범위: WebSocket 서버가 사용할 포트 범위
		port_range = { min = 10000, max = 65535 },

		-- Claude Code 실행 시 자동으로 연결 시도
		auto_start = true,

		-- 현재 선택 영역을 Claude에 실시간으로 공유
		track_selection = true,

		-- 코드 전송 후 터미널로 포커스 이동 여부
		focus_after_send = true,

		-- diff 표시 옵션
		diff_opts = {
			layout = "vertical",       -- 좌우 분할로 diff 표시
			open_in_new_tab = false,
			keep_terminal_focus = false,
		},
	},
}

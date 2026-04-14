-- ============================================================================
-- 파일명: ai/claudecode.lua
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
--   - Claude가 제안한 변경사항을 새 탭에서 diff로 확인 후 수락/거절
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
		-- 포트 범위: WebSocket 서버가 사용할 포트 범위 (충돌 가능성 최소화 위해 좁게 지정)
		port_range = { min = 40000, max = 41000 },

		-- Claude Code 실행 시 자동으로 연결 시도
		auto_start = true,

		-- 현재 선택 영역을 Claude에 실시간으로 공유
		track_selection = true,

		-- 코드 전송 후 터미널로 포커스 이동 여부 (external 에서는 외부 창이라 실효 없음)
		focus_after_send = true,

		-- ====================================================================
		-- diff 표시 옵션
		-- --------------------------------------------------------------------
		-- Claude 가 제안한 변경사항을 diff 로 띄울 때의 동작을 제어한다.
		-- 각 옵션의 의미와 허용 값은 아래 주석 참고.
		-- ====================================================================
		diff_opts = {
			-- diff 창을 어느 방향으로 분할할지 지정한다.
			--   "vertical"   : 좌/우 세로 분할 (기본값). 넓은 모니터에 적합.
			--   "horizontal" : 위/아래 가로 분할. 세로 화면이나 좁은 창에서 유리.
			layout = "vertical",

			-- diff 를 새 탭에서 열지 여부.
			--   true  : 새 탭에 diff 전용 화면 구성 (현재 작업 창 보존)
			--   false : 현재 탭에서 창을 분할해 diff 표시 (기본값)
			open_in_new_tab = true,

			-- diff 가 열린 직후 포커스를 Claude 터미널로 되돌릴지 여부.
			--   true  : diff 를 띄운 뒤에도 터미널에 포커스 유지 (floating 터미널 포함).
			--           Claude 와 대화를 이어가기 편함.
			--   false : diff 창에 포커스 이동 (기본값). 변경사항을 바로 검토할 때 유리.
			keep_terminal_focus = false,

			-- open_in_new_tab = true 일 때, 새 탭에서 Claude 터미널을 함께 표시할지 여부.
			--   true  : 새 탭에는 diff 만 표시하고 Claude 터미널은 숨김 (diff 에 집중).
			--   false : 새 탭에도 Claude 터미널을 함께 표시 (기본값).
			hide_terminal_in_new_tab = false,

			-- Claude 가 "새 파일" 생성 제안을 거절(DiffDeny) 했을 때의 처리 방식.
			--   "keep_empty"  : 빈 버퍼를 그대로 둔다 (기본값). 이후 직접 내용 입력 가능.
			--   "close_window": 자리표시용으로 열린 창/스플릿을 닫아 정리.
			on_new_file_reject = "keep_empty",
		},

		-- ====================================================================
		-- Terminal: 별도 iTerm2 창에서 claude CLI 실행
		-- ====================================================================
		-- external provider 로 동작하므로 Neovim 내부 split 을 차지하지 않는다.
		-- AppleScript 로 iTerm2 에 새 창을 띄우고 그 세션에서 claude 를 실행한다.
		-- IDE 통합용 환경 변수(CLAUDE_CODE_SSE_PORT 등)는 iTerm 세션 내 셸에서
		-- 직접 export 하여 전달한다 (AppleScript 로 생성된 세션은 osascript 의
		-- env 를 상속받지 않기 때문).
		terminal = {
			provider = "external",
			provider_opts = {
				external_terminal_cmd = function(cmd_string, env_table)
					local cwd = vim.fn.getcwd()
					local parts = {}
					for k, v in pairs(env_table) do
						table.insert(parts, string.format("export %s=%s", k, vim.fn.shellescape(v)))
					end
					table.insert(parts, string.format("cd %s", vim.fn.shellescape(cwd)))
					table.insert(parts, cmd_string)
					local shell_cmd = table.concat(parts, "; ")

					local applescript = string.format(
						'tell application "iTerm"\n'
							.. "  activate\n"
							.. "  set newWindow to (create window with default profile)\n"
							.. "  tell current session of newWindow to write text %q\n"
							.. "end tell",
						shell_cmd
					)
					return { "osascript", "-e", applescript }
				end,
			},
		},
	},
}

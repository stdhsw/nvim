-- ============================================================================
-- 파일명: debug-dap.lua
--
-- 플러그인: mfussenegger/nvim-dap
--           rcarriga/nvim-dap-ui
--           nvim-neotest/nvim-nio
--           leoluz/nvim-dap-go
-- 저장소: https://github.com/mfussenegger/nvim-dap
--         https://github.com/rcarriga/nvim-dap-ui
--         https://github.com/nvim-neotest/nvim-nio
--         https://github.com/leoluz/nvim-dap-go
--
-- 설명:
--   Go 디버깅 환경 플러그인 묶음.
--   nvim-dap    - DAP(Debug Adapter Protocol) 클라이언트 코어
--   nvim-dap-ui - 변수/콜스택/브레이크포인트를 패널로 표시하는 DAP UI
--   nvim-nio    - nvim-dap-ui 비동기 처리 의존성
--   nvim-dap-go - Go 전용 DAP 설정 (delve 디버거 연동)
--
--   사전 준비:
--   brew install delve   (Go 디버거 설치)
--
-- 사용법:
--   DAP UI 패널:
--   - scopes      : 현재 스코프의 변수 목록
--   - watches     : 감시할 표현식 추가
--   - stacks      : 콜스택 (함수 호출 경로)
--   - breakpoints : 설정된 브레이크포인트 목록
--   - console     : 디버거 출력 콘솔
--   - repl        : 디버거 REPL (표현식 평가)
--
--   .env 환경변수 자동 로드:
--   디버깅/테스트 시작 시 현재 작업 디렉토리(cwd)의 .env 파일을 자동으로 읽어
--   테스트 프로세스의 환경변수로 주입한다.
--   .env 파일 형식:
--     KEY=VALUE        (기본)
--     KEY="VALUE"      (큰따옴표)
--     KEY='VALUE'      (작은따옴표)
--     # 주석           (무시)
--                      (빈 줄 무시)
--   .env 파일이 없으면 무시된다. dap_configurations에 명시된 env가 .env보다 우선된다.
--
-- 커스텀 단축키 (config/keymaps.lua 참고):
--   <F5>        - 디버깅 시작 / 다음 브레이크포인트까지 계속 실행
--   <F9>        - 브레이크포인트 토글 (현재 줄에 설정/해제)
--   <F10>       - Step Over (다음 줄 실행, 함수 진입 안 함)
--   <F11>       - Step Into (함수 내부로 진입)
--   <S-F11>     - Step Out (현재 함수에서 빠져나오기)
--   <S-F5>      - 디버깅 종료
--   <F7>        - DAP UI 토글 (변수/콜스택 패널 열기/닫기)
--   <F8>        - 디버거 세션 종료 및 UI 닫기
--   <leader>dt  - 커서 위치의 Go 테스트 함수 디버깅 (.env 자동 로드)
-- ============================================================================

-- .env 파일을 파싱하여 환경변수 테이블로 반환
-- 파일이 없으면 빈 테이블 반환 (오류 없이 무시)
local function load_dotenv(path)
	local env = {}
	local file = io.open(path, "r")
	if not file then
		return env
	end
	for line in file:lines() do
		-- 빈 줄과 주석(#) 무시
		if line ~= "" and not line:match("^%s*#") then
			local key, value = line:match("^%s*([^=]+)%s*=%s*(.-)%s*$")
			if key and value then
				-- 따옴표로 감싼 값 처리: "value" 또는 'value'
				value = value:match('^"(.*)"$') or value:match("^'(.*)'$") or value
				env[key] = value
			end
		end
	end
	file:close()
	return env
end

return {
	-- DAP 코어
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			-- DAP UI
			{
				"rcarriga/nvim-dap-ui",
				dependencies = { "nvim-neotest/nvim-nio" },
				config = function()
					local dap = require("dap")
					local dapui = require("dapui")

					dapui.setup({
						icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
						layouts = {
							{
								elements = {
									{ id = "scopes", size = 0.40 },
									{ id = "breakpoints", size = 0.20 },
									{ id = "stacks", size = 0.25 },
									{ id = "watches", size = 0.15 },
								},
								size = 40,
								position = "left",
							},
							{
								elements = {
									{ id = "repl", size = 0.5 },
									{ id = "console", size = 0.5 },
								},
								size = 10,
								position = "bottom",
							},
						},
						floating = {
							max_height = 0.9,
							max_width = 0.9,
							border = "rounded",
						},
					})

					-- 디버깅 시작/종료 시 UI 자동 열기/닫기
					dap.listeners.after.event_initialized["dapui_config"] = function()
						dapui.open()
					end
					dap.listeners.before.event_terminated["dapui_config"] = function()
						dapui.close()
					end
					dap.listeners.before.event_exited["dapui_config"] = function()
						dapui.close()
					end
				end,
			},
			-- Go 전용 DAP
			{
				"leoluz/nvim-dap-go",
				config = function()
					require("dap-go").setup({
						dap_configurations = {
							{
								type = "go",
								name = "Attach remote",
								mode = "remote",
								request = "attach",
							},
						},
						delve = {
							path = "dlv",
							initialize_timeout_sec = 20,
							port = "${port}",
							args = {},
							build_flags = "",
						},
					})
				end,
			},
		},
		event = "VeryLazy",
		config = function()
			local dap = require("dap")

			-- dap.run을 래핑하여 launch 직전에 .env 환경변수를 config에 주입
			-- dap.listeners.before.launch은 응답 리스너라 config 수정 불가 →
			-- dap.run 자체를 오버라이드하는 방식이 유일하게 config를 변경할 수 있는 시점
			local original_run = dap.run
			dap.run = function(config, opts)
				local env = load_dotenv(vim.fn.getcwd() .. "/.env")
				if next(env) ~= nil then
					-- 명시적 설정(config.env)이 .env보다 우선되도록 force로 병합
					config.env = vim.tbl_extend("force", env, config.env or {})
					vim.notify(
						"[DAP] .env " .. vim.tbl_count(env) .. "개 환경변수 로드됨",
						vim.log.levels.INFO
					)
				end
				return original_run(config, opts)
			end

			-- 브레이크포인트 아이콘 설정
			vim.fn.sign_define("DapBreakpoint", {
				text = "●",
				texthl = "DapBreakpoint",
				linehl = "",
				numhl = "",
			})
			vim.fn.sign_define(
				"DapBreakpointCondition",
				{ text = "◆", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
			)
			vim.fn.sign_define(
				"DapBreakpointRejected",
				{ text = "○", texthl = "DapBreakpointRejected", linehl = "", numhl = "" }
			)
			vim.fn.sign_define("DapLogPoint", {
				text = "◇",
				texthl = "DapLogPoint",
				linehl = "",
				numhl = "",
			})
			vim.fn.sign_define(
				"DapStopped",
				{ text = "▸", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" }
			)

			-- 브레이크포인트 색상
			vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#ef596f" })
			vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#e5c07b" })
			vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = "#7f848e" })
			vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#61afef" })
			vim.api.nvim_set_hl(0, "DapStopped", { fg = "#89ca78" })
			vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#2e3440" })
		end,
	},
}

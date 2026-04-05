-- debug-dap.lua
-- Go 디버깅 플러그인 설정 (nvim-dap + nvim-dap-ui + nvim-dap-go)
--
-- 플러그인:
--   - mfussenegger/nvim-dap    : DAP(Debug Adapter Protocol) 클라이언트 코어
--                                https://github.com/mfussenegger/nvim-dap
--   - rcarriga/nvim-dap-ui     : DAP UI (변수, 콜스택, 브레이크포인트 패널)
--                                https://github.com/rcarriga/nvim-dap-ui
--   - nvim-neotest/nvim-nio    : nvim-dap-ui 비동기 처리 의존성
--                                https://github.com/nvim-neotest/nvim-nio
--   - leoluz/nvim-dap-go       : Go 전용 DAP 설정 (delve 디버거 연동)
--                                https://github.com/leoluz/nvim-dap-go
--
-- 사전 준비:
--   brew install delve          (Go 디버거)
--
-- 사용법:
--   F5         : 디버깅 시작 / 다음 브레이크포인트까지 계속 실행
--   F9         : 브레이크포인트 토글 (현재 줄에 설정/해제)
--   F10        : Step Over (다음 줄 실행, 함수 진입 안 함)
--   F11        : Step Into (함수 내부로 진입)
--   Shift+F11  : Step Out (현재 함수에서 빠져나오기)
--   Shift+F5   : 디버깅 종료
--   F7         : DAP UI 토글 (변수/콜스택 패널 열기/닫기)
--   F8         : 디버거 세션 종료 및 UI 닫기
--   <leader>dt : 커서 위치의 Go 테스트 함수 디버깅
--
-- DAP UI 패널 설명:
--   - scopes      : 현재 스코프의 변수 목록
--   - watches     : 감시할 표현식 추가
--   - stacks      : 콜스택 (함수 호출 경로)
--   - breakpoints : 설정된 브레이크포인트 목록
--   - console     : 디버거 출력 콘솔
--   - repl        : 디버거 REPL (표현식 평가)

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

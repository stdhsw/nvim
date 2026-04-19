-- ============================================================================
-- 파일명: debug/dap.lua
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
--   <F6>        - 디버깅 종료
--   <F7>        - DAP UI 토글 (변수/콜스택 패널 열기/닫기)
--   <F8>        - 조건부 브레이크포인트 설정 (조건식 입력 후 Enter)
--   <F9>        - 브레이크포인트 토글 (현재 줄에 설정/해제)
--   <F10>       - Step Over (다음 줄 실행, 함수 진입 안 함)
--   <F11>       - Step Into (함수 내부로 진입)
--   <F12>       - Step Out (현재 함수에서 빠져나오기)
--   <leader>dt  - 커서 위치의 Go 테스트 함수 디버깅 (.env 자동 로드)
--   <leader>dT  - 빌드 태그를 입력받아 커서 위치의 Go 테스트 함수 디버깅
--                 (예: integration, e2e 등 //go:build 태그가 필요한 테스트)
-- ============================================================================

-- .env 파일을 파싱하여 환경변수 테이블로 반환 (파일 없으면 빈 테이블)
-- 지원 형식: KEY=VALUE / KEY="VALUE" / KEY='VALUE' / # 주석 / 빈 줄
local function load_dotenv(path)
	local env = {}
	local file = io.open(path, "r")
	if not file then
		return env
	end

	for line in file:lines() do
		if line ~= "" and not line:match("^%s*#") then
			local key, value = line:match("^%s*([^=]+)%s*=%s*(.-)%s*$")
			if key and value then
				-- 감싸는 따옴표 제거 (없으면 원본 유지)
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

					-- DAP 이벤트 훅으로 UI 자동 열기/닫기
					-- event_initialized : 어댑터가 준비되어 디버깅이 시작된 직후 → UI 열기
					-- event_terminated  : 프로세스가 정상 종료된 직후 → UI 닫기
					-- event_exited      : 프로세스가 비정상 종료(exit code)된 직후 → UI 닫기
					-- "dapui_config" 는 리스너 식별 키 (임의 문자열, 중복 방지용)
					-- nvim-dap 의 listeners 필드는 런타임에 확장되는 구조라 lua_ls 정적 분석에서
					-- undefined-field 로 잡힌다. 실사용에는 문제없으므로 해당 라인만 진단을 끈다.
					---@diagnostic disable-next-line: undefined-field
					dap.listeners.after.event_initialized["dapui_config"] = function()
						dapui.open()
					end
					---@diagnostic disable-next-line: undefined-field
					dap.listeners.before.event_terminated["dapui_config"] = function()
						dapui.close()
					end
					---@diagnostic disable-next-line: undefined-field
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
							-- 빌드 태그가 필요한 테스트 파일 디버깅용
							-- //go:build integration 같은 태그가 있는 *_test.go 파일에 사용
							-- <F5> 실행 후 이 설정을 선택하면 빌드 태그 입력 프롬프트가 표시됨
							{
								type = "go",
								name = "Debug test (빌드 태그 입력)",
								request = "launch",
								mode = "test",
								program = "${file}",
								buildFlags = function()
									return vim.fn.input("빌드 태그: ", "-tags ")
								end,
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

			-- dap.run 오버라이드: 디버깅 시작 직전에 .env 환경변수를 config에 주입
			-- dap.listeners.before.launch 는 이미 어댑터에 config가 전달된 이후이므로
			-- config를 수정해도 반영되지 않음. dap.run 자체를 교체하는 것이
			-- config 변경이 가능한 유일한 시점
			-- dap.run 은 함수 타입으로 선언되어 있어 재할당 시 lua_ls 가 inject-field 경고를
			-- 내지만, 런타임에 함수 교체는 정상 동작하므로 해당 라인만 진단을 끈다.
			local original_run = dap.run
			---@diagnostic disable-next-line: inject-field
			dap.run = function(config, opts)
				local env = load_dotenv(vim.fn.getcwd() .. "/.env")
				if next(env) ~= nil then
					-- vim.tbl_extend("force", base, override)
					-- "force" : 키 충돌 시 오른쪽(config.env) 값이 우선됨
					-- .env 를 base에 두고 config.env 를 우선시하여
					-- 명시적 설정이 .env 보다 항상 우선되도록 보장
					config.env = vim.tbl_extend("force", env, config.env or {})
					vim.notify("[DAP] .env " .. vim.tbl_count(env) .. "개 환경변수 로드됨", vim.log.levels.INFO)
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

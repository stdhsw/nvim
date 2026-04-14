-- ============================================================================
-- 파일명: extras/lang/go.lua
--
-- 설명:
--   Go 언어 지원 extra.
--   LSP, 포매터, 린터, Treesitter 파서, DAP 디버거, struct 태그 편집을
--   한 파일에서 관리한다.
--
-- 포함 구성:
--   LSP       - gopls (Go 공식 LSP)
--   포매터    - gofumpt (엄격한 포맷) → goimports (import 정렬)
--   린터      - (gopls staticcheck으로 대체)
--   파서      - go, gomod, gosum, gowork
--   DAP       - nvim-dap-go (delve 연동)
--   태그 편집 - gomodifytags (struct 필드 json/yaml 태그 자동 생성)
--
-- 사전 요구사항:
--   go install mvdan.cc/gofumpt@latest
--   go install golang.org/x/tools/cmd/goimports@latest
--   brew install delve
--   (gomodifytags 는 mason-tool-installer 가 자동 설치)
--
-- 사용자 명령:
--   :GoAddTag [tags]   - 커서가 속한 struct 의 모든 필드에 태그 추가 (기본: json)
--                        예) :GoAddTag json,yaml
--   :GoRmTag  [tags]   - 커서가 속한 struct 의 모든 필드에서 지정한 태그 제거
--                        예) :GoRmTag yaml
--   :GoClearTag        - 커서가 속한 struct 의 모든 필드에서 태그 전체 제거
--
--   ※ 커서는 struct 블록 안 어디든 (필드 선언, 빈 줄, `type ... struct {` /
--     닫는 `}` 줄 포함) 위치하면 된다. 커서가 속한 struct 를 찾아 그 struct 의
--     모든 필드에 일괄 적용된다.
-- ============================================================================

-- gomodifytags 실행 래퍼
-- -offset: 커서의 바이트 오프셋을 넘기면 해당 오프셋을 감싸는 struct 를 찾아
--          그 struct 의 "모든 필드" 에 일괄 적용한다.
--          (과거에는 -line 으로 현재 줄의 단일 필드에만 적용됐다)
-- -w 옵션: 파일을 직접 수정 (stdout 대신 원본 덮어쓰기)
-- -transform snakecase: 필드명 FooBar → foo_bar 로 변환해 태그 생성
local function run_gomodifytags(extra_args, success_msg)
	if vim.bo.filetype ~= "go" then
		vim.notify("[gomodifytags] Go 파일에서만 사용할 수 있습니다.", vim.log.levels.WARN)
		return
	end
	if vim.fn.executable("gomodifytags") == 0 then
		vim.notify(
			"[gomodifytags] 실행 파일이 없습니다. :MasonInstall gomodifytags 를 실행하세요.",
			vim.log.levels.ERROR
		)
		return
	end

	-- 저장되지 않은 변경이 있으면 먼저 저장 (gomodifytags 는 디스크 파일을 직접 편집)
	if vim.bo.modified then
		vim.cmd("silent write")
	end

	local file = vim.fn.expand("%:p")
	-- 커서의 바이트 오프셋 계산 (nvim_win_get_cursor: row=1-based, col=0-based byte)
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local offset = vim.api.nvim_buf_get_offset(0, row - 1) + col
	local cmd = vim.list_extend({
		"gomodifytags",
		"-file",
		file,
		"-offset",
		tostring(offset),
		"-w",
	}, extra_args)

	local result = vim.system(cmd, { text = true }):wait()
	if result.code ~= 0 then
		vim.notify("[gomodifytags] 실패: " .. (result.stderr or ""), vim.log.levels.ERROR)
		return
	end

	-- 디스크 변경분을 버퍼로 다시 읽어들임
	vim.cmd("silent edit")
	vim.notify("[gomodifytags] " .. success_msg, vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("GoAddTag", function(opts)
	local tags = opts.args ~= "" and opts.args or "json"
	run_gomodifytags({ "-add-tags", tags, "-transform", "snakecase" }, "태그 추가: " .. tags)
end, {
	nargs = "?",
	desc = "Go struct 에 태그 추가 (기본: json). 예) :GoAddTag json,yaml",
})

vim.api.nvim_create_user_command("GoRmTag", function(opts)
	local tags = opts.args ~= "" and opts.args or "json"
	run_gomodifytags({ "-remove-tags", tags }, "태그 제거: " .. tags)
end, {
	nargs = "?",
	desc = "Go struct 에서 지정한 태그 제거. 예) :GoRmTag yaml",
})

vim.api.nvim_create_user_command("GoClearTag", function()
	run_gomodifytags({ "-clear-tags" }, "모든 태그 제거")
end, {
	desc = "Go struct 의 모든 태그 제거",
})

return {
	-- Mason: gopls 자동 설치
	{
		"williamboman/mason-lspconfig.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "gopls" })
		end,
	},

	-- Mason tool installer: gomodifytags (struct 태그 편집 도구) 자동 설치
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "gomodifytags" })
		end,
	},

	-- LSP: gopls 설정 및 활성화
	{
		"neovim/nvim-lspconfig",
		opts = function(_, opts)
			opts.servers = opts.servers or {}
			opts.configs = opts.configs or {}

			table.insert(opts.servers, "gopls")
			opts.configs.gopls = {
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
			}
		end,
	},

	-- Treesitter: Go 파서 설치
	-- init은 config보다 먼저 실행되어 vim.g.extra_treesitter_parsers에 파서를 추가
	{
		"nvim-treesitter/nvim-treesitter",
		init = function()
			vim.g.extra_treesitter_parsers = vim.g.extra_treesitter_parsers or {}
			vim.list_extend(vim.g.extra_treesitter_parsers, { "go", "gomod", "gosum", "gowork" })
		end,
	},

	-- Conform: Go 포매터 등록
	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			opts.formatters_by_ft = opts.formatters_by_ft or {}
			-- gofumpt: 엄격한 포맷 (gofmt 상위 호환)
			-- goimports: import 구문 자동 정렬/추가/제거
			opts.formatters_by_ft.go = { "gofumpt", "goimports" }
		end,
	},

	-- DAP: Go 디버거 (debug/dap.lua에서 전체 DAP 설정 관리)
}

-- ============================================================================
-- 파일명: ui/colorscheme.lua
--
-- 플러그인:
--   1. projekt0n/github-nvim-theme  - GitHub 공식 색감 기반 테마 (기본 적용)
--   2. rebelot/kanagawa.nvim        - 일본 우키요에 감성 다크 테마 (대체 테마)
--
-- 저장소:
--   https://github.com/projekt0n/github-nvim-theme
--   https://github.com/rebelot/kanagawa.nvim
--
-- 설명:
--   github-theme  - GitHub UI 색감 기반. dark_high_contrast variant는 고대비 다크 테마. (기본값)
--   kanagawa      - 호쿠사이의 '가나가와 해변의 큰 파도'에서 영감받은 테마.
--                   wave(기본 다크) / dragon(더 어두운 다크) / lotus(라이트) 3종 variant 제공.
--                   lazy=true 이므로 :colorscheme 명령 또는 Telescope colorscheme 선택 시 로드된다.
--
-- 기본 테마: github_dark_high_contrast
-- 테마 전환:
--   :colorscheme github_dark_high_contrast - github 고대비 적용 (기본)
--   :colorscheme kanagawa                  - kanagawa 적용 (background 옵션에 따라 wave/lotus 자동 선택)
--   :colorscheme kanagawa-wave             - kanagawa wave (다크, 기본)
--   :colorscheme kanagawa-dragon           - kanagawa dragon (더 어두운 다크)
--   :colorscheme kanagawa-lotus            - kanagawa lotus (라이트)
--   <leader>tc                             - Telescope 로 실시간 테마 전환 (keymaps.lua)
--
-- 커스텀 단축키:
--   없음 (테마 선택은 <leader>tc 의 Telescope colorscheme 사용)
-- ============================================================================

return {
	-- github-nvim-theme: dark_high_contrast variant 기본 적용
	{
		"projekt0n/github-nvim-theme",
		lazy = false,
		priority = 1000, -- 다른 플러그인보다 먼저 로드
		config = function()
			require("github-theme").setup({
				options = {
					transparent = false,
					styles = {
						comments = "italic",
					},
				},
				groups = {
					all = {
						-- ----------------------------------------------------------------
						-- 변수
						-- ----------------------------------------------------------------
						["@variable"] = { fg = "#e6edf3" }, -- 일반 변수 (밝은 흰색)
						["@variable.parameter"] = { fg = "#d2a8ff" }, -- 함수 파라미터 (연보라)
						["@variable.member"] = { fg = "#79c0ff" }, -- 구조체 필드 (하늘)

						-- ----------------------------------------------------------------
						-- 함수
						-- ----------------------------------------------------------------
						["@function"] = { fg = "#d2a8ff" }, -- 함수 선언 (연보라)
						["@function.call"] = { fg = "#d2a8ff" }, -- 함수 호출 (연보라)
						["@function.method"] = { fg = "#d2a8ff" }, -- 메서드 선언 (연보라)
						["@function.method.call"] = { fg = "#d2a8ff" }, -- 메서드 호출 (연보라)
						["@function.builtin"] = { fg = "#79c0ff" }, -- 내장 함수: make, len, append (하늘)

						-- ----------------------------------------------------------------
						-- 타입
						-- ----------------------------------------------------------------
						["@type"] = { fg = "#79c0ff" }, -- 커스텀 타입: struct, interface (하늘)
						["@type.builtin"] = { fg = "#79c0ff" }, -- 내장 타입: int, string, bool, error (하늘)

						-- ----------------------------------------------------------------
						-- 상수
						-- ----------------------------------------------------------------
						["@constant"] = { fg = "#79c0ff" }, -- 상수 (하늘)
						["@constant.builtin"] = { fg = "#79c0ff" }, -- 내장 상수: true, false, nil, iota (하늘)

						-- ----------------------------------------------------------------
						-- 패키지
						-- ----------------------------------------------------------------
						["@module"] = { fg = "#e6edf3" }, -- 패키지명: fmt, os, http (흰색)

						-- ----------------------------------------------------------------
						-- 키워드
						-- ----------------------------------------------------------------
						["@keyword"] = { fg = "#ff7b72" }, -- 일반 키워드: var, type, go, defer (산호)
						["@keyword.function"] = { fg = "#ff7b72" }, -- func 키워드 (산호)
						["@keyword.return"] = { fg = "#ff7b72" }, -- return 키워드 (산호)
						["@keyword.operator"] = { fg = "#ff7b72" }, -- 연산자형 키워드 (산호)

						-- ----------------------------------------------------------------
						-- 연산자 / 구두점
						-- ----------------------------------------------------------------
						["@operator"] = { fg = "#e6edf3" }, -- 연산자: +, -, *, / (기본)

						-- ----------------------------------------------------------------
						-- 문자열 / 숫자
						-- ----------------------------------------------------------------
						["@string"] = { fg = "#a5d6ff" }, -- 문자열 (연하늘)
						["@number"] = { fg = "#79c0ff" }, -- 정수 (하늘)
						["@number.float"] = { fg = "#79c0ff" }, -- 실수 (하늘)

						-- ----------------------------------------------------------------
						-- 주석
						-- ----------------------------------------------------------------
						["@comment"] = { fg = "#8b949e", italic = true }, -- 주석 (회색, 이탤릭)

						-- ----------------------------------------------------------------
						-- Telescope
						-- ----------------------------------------------------------------
						["TelescopeSelection"] = { fg = "#000000", bg = "#ff9900", bold = true }, -- 선택된 항목 (밝은 파란 배경)

						-- ----------------------------------------------------------------
						-- 검색 하이라이트
						-- ----------------------------------------------------------------
						["Search"] = { fg = "#0d1117", bg = "#ecc669", bold = true }, -- 검색 결과 전체 (노랑 배경)
						["IncSearch"] = { fg = "#0d1117", bg = "#ff9900", bold = true }, -- 현재 검색 위치 (네온 오렌지 배경)
						["CurSearch"] = { fg = "#0d1117", bg = "#ff9900", bold = true }, -- 현재 커서 검색 위치 (네온 오렌지 배경)
					},
				},
			})
			vim.cmd("colorscheme github_dark_high_contrast") -- 기본 테마로 적용
		end,
	},

	-- kanagawa.nvim: 우키요에 감성 다크 테마 (대체 테마)
	-- lazy=true 이므로 :colorscheme kanagawa 실행 또는 Telescope colorscheme 선택 시 자동 로드.
	-- (lazy.nvim 은 colors/*.lua 디렉토리를 자동 인식하여 지연 로드 트리거를 걸어준다)
	{
		"rebelot/kanagawa.nvim",
		lazy = true,
		priority = 900, -- github-theme 보다 낮게 (기본 테마가 아니므로)
		config = function()
			require("kanagawa").setup({
				compile = false, -- 컴파일된 바이트코드 캐시 비활성
				undercurl = true, -- LSP 진단 언더컬 활성
				commentStyle = { italic = true }, -- 주석 이탤릭
				functionStyle = {},
				keywordStyle = { italic = true }, -- 키워드 이탤릭
				statementStyle = { bold = true }, -- 제어문 굵게
				typeStyle = {},
				transparent = false, -- 배경 투명 비활성
				dimInactive = false, -- 비활성 창 어둡게 비활성
				terminalColors = true, -- 내장 터미널 버퍼에도 색상 적용
				background = {
					dark = "wave", -- 다크 모드 기본 variant: wave (가나가와 파도)
					light = "lotus", -- 라이트 모드 기본 variant: lotus
				},
			})
		end,
	},
}

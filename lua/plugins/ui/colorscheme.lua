-- ============================================================================
-- 파일명: ui/colorscheme.lua
--
-- 플러그인:
--   1. projekt0n/github-nvim-theme  - GitHub 공식 색감 기반 테마 (기본 적용)
--   2. rebelot/kanagawa.nvim        - 일본 우키요에 감성 다크 테마 (대체 테마)
--   3. EdenEast/nightfox.nvim       - 여우 컨셉의 다양한 감성 테마 모음 (대체 테마)
--   4. vague-theme/vague.nvim       - 뮤트한 파스텔 톤 미니멀 다크 테마 (대체 테마)
--   5. rakr/vim-one                 - Atom One 감성의 다크/라이트 테마 (대체 테마)
--
-- 저장소:
--   https://github.com/projekt0n/github-nvim-theme
--   https://github.com/rebelot/kanagawa.nvim
--   https://github.com/EdenEast/nightfox.nvim
--   https://github.com/vague-theme/vague.nvim
--   https://github.com/rakr/vim-one
--
-- 설명:
--   github-theme - GitHub UI 색감 기반. dark_high_contrast variant는 고대비 다크 테마. (기본값)
--   kanagawa     - 호쿠사이의 '가나가와 해변의 큰 파도'에서 영감받은 테마.
--                  wave(기본 다크) / dragon(더 어두운 다크) / lotus(라이트) 3종 variant 제공.
--                  lazy=true 이므로 :colorscheme 명령 또는 Telescope colorscheme 선택 시 로드된다.
--   nightfox     - 여우 컨셉의 풍부한 variant 제공.
--                  nightfox(기본 다크) / duskfox(자줏빛 다크) / nordfox(nord 감성) /
--                  terafox(청록 톤 다크) / carbonfox(가장 어두운 다크) / dayfox(라이트) /
--                  dawnfox(파스텔 라이트) 7종 variant 제공.
--                  lazy=true 이므로 :colorscheme 명령 또는 Telescope colorscheme 선택 시 로드된다.
--   vague        - 채도를 낮춘 파스텔 톤의 미니멀 다크 테마. variant 없이 단일 colorscheme 제공.
--                  lazy=true 이므로 :colorscheme vague 실행 또는 Telescope colorscheme 선택 시 로드된다.
--   vim-one      - Atom 의 One 테마 감성을 옮긴 vim 플러그인. background 옵션(dark/light)에 따라
--                  단일 colorscheme 이름(one)이 다크/라이트로 동작한다.
--                  lazy=true 이므로 :colorscheme one 실행 또는 Telescope colorscheme 선택 시 로드된다.
--
-- 기본 테마: github_dark_high_contrast
-- 테마 전환:
--   :colorscheme github_dark_high_contrast - github 고대비 적용 (기본)
--   :colorscheme kanagawa                  - kanagawa 적용 (background 옵션에 따라 wave/lotus 자동 선택)
--   :colorscheme kanagawa-wave             - kanagawa wave (다크, 기본)
--   :colorscheme kanagawa-dragon           - kanagawa dragon (더 어두운 다크)
--   :colorscheme kanagawa-lotus            - kanagawa lotus (라이트)
--   :colorscheme nightfox                  - nightfox (다크, 기본)
--   :colorscheme duskfox                   - nightfox duskfox (자줏빛 다크)
--   :colorscheme nordfox                   - nightfox nordfox (nord 감성 다크)
--   :colorscheme terafox                   - nightfox terafox (청록 톤 다크)
--   :colorscheme carbonfox                 - nightfox carbonfox (가장 어두운 다크)
--   :colorscheme dayfox                    - nightfox dayfox (라이트)
--   :colorscheme dawnfox                   - nightfox dawnfox (파스텔 라이트)
--   :colorscheme vague                     - vague (뮤트한 파스텔 톤 다크)
--   :colorscheme one                       - vim-one (background 옵션에 따라 다크/라이트 자동 선택)
--   <leader>tc                             - Telescope 로 실시간 테마 전환 (keymaps.lua)
--
-- 커스텀 단축키:
--   없음 (테마 선택은 <leader>tc 의 Telescope colorscheme 사용)
-- ============================================================================

-- ============================================================================
-- 기본 테마 변수
--   아래 default_colorscheme 한 줄만 변경하면 nvim 시작 시 적용되는 기본 테마가 바뀐다.
--   변수에 들어갈 수 있는 값은 colorscheme_providers 의 각 리스트에 나열된 이름들.
--   변수 값이 어느 플러그인 소유인지에 따라 해당 플러그인만 lazy=false / priority=1000 으로
--   우선 로드되고, 나머지 플러그인은 lazy=true / priority=100 으로 지연 로드된다.
-- ============================================================================
local default_colorscheme = "github_dark_high_contrast"

-- 각 플러그인이 제공하는 colorscheme 이름 매핑.
-- default_colorscheme 가 어느 플러그인 소유인지 판별하는 데 사용된다.
local colorscheme_providers = {
	github = {
		"github_dark",
		"github_dark_default",
		"github_dark_dimmed",
		"github_dark_high_contrast",
		"github_dark_colorblind",
		"github_dark_tritanopia",
		"github_light",
		"github_light_default",
		"github_light_high_contrast",
		"github_light_colorblind",
		"github_light_tritanopia",
	},
	kanagawa = { "kanagawa", "kanagawa-wave", "kanagawa-dragon", "kanagawa-lotus" },
	nightfox = { "nightfox", "duskfox", "nordfox", "terafox", "carbonfox", "dayfox", "dawnfox" },
	vague = { "vague" },
	one = { "one" },
}

-- default_colorscheme 가 주어진 provider(플러그인) 소유인지 반환한다.
local function is_default_owner(provider)
	for _, name in ipairs(colorscheme_providers[provider]) do
		if name == default_colorscheme then
			return true
		end
	end
	return false
end

return {
	-- github-nvim-theme: GitHub 색감 기반 테마
	{
		"projekt0n/github-nvim-theme",
		lazy = not is_default_owner("github"), -- 기본 테마 소유 시 즉시 로드
		priority = is_default_owner("github") and 1000 or 100, -- 기본 테마면 최우선
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
						["@variable"] = { fg = "#e6edf3" }, -- 일반 변수
						["@variable.parameter"] = { fg = "#e6edf3" }, -- 함수 파라미터
						["@variable.member"] = { fg = "#79c0ff" }, -- 구조체 필드 (하늘)

						-- ----------------------------------------------------------------
						-- 함수
						-- ----------------------------------------------------------------
						["@function"] = { fg = "#f8e1a1" }, -- 함수 선언 (소프트 골드)
						["@function.call"] = { fg = "#f8e1a1" }, -- 함수 호출 (소프트 골드)
						["@function.method"] = { fg = "#f8e1a1" }, -- 메서드 선언 (소프트 골드)
						["@function.method.call"] = { fg = "#f8e1a1" }, -- 메서드 호출 (소프트 골드)
						["@function.builtin"] = { fg = "#f8e1a1" }, -- 내장 함수: make, len, append (소프트 골드)

						-- ----------------------------------------------------------------
						-- 타입
						-- ----------------------------------------------------------------
						["@type"] = { fg = "#d2a8ff" }, -- 커스텀 타입: struct, interface (연보라)
						["@type.builtin"] = { fg = "#d2a8ff" }, -- 내장 타입: int, string, bool, error (연보라)

						-- ----------------------------------------------------------------
						-- 상수
						-- ----------------------------------------------------------------
						["@constant"] = { fg = "#7ee787" }, -- 상수 (민트 그린)
						["@constant.builtin"] = { fg = "#7ee787" }, -- 내장 상수: true, false, nil, iota (민트 그린)

						-- ----------------------------------------------------------------
						-- 패키지
						-- ----------------------------------------------------------------
						["@module"] = { fg = "#e6edf3" }, -- 패키지명: fmt, os, http (흰색)

						-- ----------------------------------------------------------------
						-- 키워드
						-- ----------------------------------------------------------------
						["@keyword"] = { fg = "#79c0ff" }, -- 일반 키워드: var, type, go, defer (하늘)
						["@keyword.function"] = { fg = "#79c0ff" }, -- func 키워드 (하늘)
						["@keyword.return"] = { fg = "#79c0ff" }, -- return 키워드 (하늘)
						["@keyword.operator"] = { fg = "#79c0ff" }, -- 연산자형 키워드 (하늘)

						-- ----------------------------------------------------------------
						-- 연산자 / 구두점
						-- ----------------------------------------------------------------
						["@operator"] = { fg = "#e6edf3" }, -- 연산자: +, -, *, / (기본)

						-- ----------------------------------------------------------------
						-- 문자열 / 숫자
						-- ----------------------------------------------------------------
						["@string"] = { fg = "#d18c4f" }, -- 문자열
						["@string.escape"] = { fg = "#a3d6f1", bold = true }, -- 이스케이프 문자 (\n, \t 등)
						["@number"] = { fg = "#d2a8ff" }, -- 정수 (연보라)
						["@number.float"] = { fg = "#d2a8ff" }, -- 실수 (연보라)
						["@string.special"] = { fg = "#a3d6f1", bold = true }, -- 특수 문자 추가 지원

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

						-- ----------------------------------------------------------------
						-- Diff 하이라이트 (claudecode / diffview / fugitive 등 공용)
						--   Vim 의 DiffChange/DiffText 모델은 IDE 식이라 Change 는 오렌지 계열로 둔다.
						--   DiffChange (줄 전체 오렌지) ↔ DiffText (글자 형광 라임) 보색 대비로 변경 위치를 강조.
						-- ----------------------------------------------------------------
						["DiffAdd"] = { bg = "#0d2a4a" }, -- 추가 줄 (어두운 파랑 배경)
						["DiffDelete"] = { fg = "#ff7b72", bg = "#67060c" }, -- 삭제 줄 (산호 글씨 + 어두운 빨강)
						["DiffChange"] = { bg = "#3a2e0a" }, -- 변경 줄 전체 (어두운 황금 배경)
						["DiffText"] = { fg = "#0d1117", bg = "#00ff7f", bold = true }, -- 변경된 글자 (형광 라임 + 검은 글씨, bold)

						-- ----------------------------------------------------------------
						-- WinBar (창 분할 시 각 창 상단 파일명 바)
						-- ----------------------------------------------------------------
						["WinBar"] = { fg = "#ffffff", bg = "#1f6feb", bold = true }, -- 활성 창 winbar (고대비 파란 배경 바)
						["WinBarNC"] = { fg = "#484f58", bg = "#161b22" }, -- 비활성 창 winbar (어두운 배경 바)

						-- ----------------------------------------------------------------
						-- 디렉토리 (리눅스 터미널 스타일 파란색)
						-- ----------------------------------------------------------------
						["Directory"] = { fg = "#79c0ff", bold = true }, -- 공통 디렉토리 하이라이트 (netrw 등 fallback)
						["NeoTreeDirectoryName"] = { fg = "#79c0ff", bold = true }, -- neo-tree 디렉토리 이름
						["NeoTreeDirectoryIcon"] = { fg = "#79c0ff" }, -- neo-tree 디렉토리 아이콘
						["NeoTreeRootName"] = { fg = "#79c0ff", bold = true }, -- neo-tree 루트 디렉토리
					},
				},
			})
			if is_default_owner("github") then
				vim.cmd("colorscheme " .. default_colorscheme) -- 기본 테마로 적용
			end
		end,
	},

	-- kanagawa.nvim: 우키요에 감성 다크 테마
	-- 기본 테마 소유 시 lazy=false 로 즉시 로드되고, 아니면 :colorscheme 명령 또는
	-- Telescope colorscheme 선택 시 자동 로드된다.
	-- (lazy.nvim 은 colors/*.lua 디렉토리를 자동 인식하여 지연 로드 트리거를 걸어준다)
	{
		"rebelot/kanagawa.nvim",
		lazy = not is_default_owner("kanagawa"),
		priority = is_default_owner("kanagawa") and 1000 or 100,
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
			if is_default_owner("kanagawa") then
				vim.cmd("colorscheme " .. default_colorscheme) -- 기본 테마로 적용
			end
		end,
	},

	-- nightfox.nvim: 여우 컨셉의 다양한 감성 테마 모음
	-- 기본 테마 소유 시 lazy=false 로 즉시 로드되고, 아니면 :colorscheme 명령 또는
	-- Telescope colorscheme 선택 시 자동 로드된다.
	-- variant 별로 별도의 colorscheme 이름을 가진다 (nightfox / duskfox / nordfox / terafox / carbonfox / dayfox / dawnfox)
	{
		"EdenEast/nightfox.nvim",
		lazy = not is_default_owner("nightfox"),
		priority = is_default_owner("nightfox") and 1000 or 100,
		config = function()
			require("nightfox").setup({
				options = {
					compile_path = vim.fn.stdpath("cache") .. "/nightfox", -- 컴파일 캐시 경로
					compile_file_suffix = "_compiled", -- 컴파일 파일 접미사
					transparent = false, -- 배경 투명 비활성
					terminal_colors = true, -- 내장 터미널 버퍼에도 색상 적용
					dim_inactive = false, -- 비활성 창 어둡게 비활성
					module_default = true, -- 모든 모듈(플러그인 연동) 기본 활성
					colorblind = {
						enable = false, -- 색약 모드 비활성
						severity = {
							protan = 0,
							deutan = 0,
							tritan = 0,
						},
					},
					styles = {
						comments = "italic", -- 주석 이탤릭
						conditionals = "NONE",
						constants = "NONE",
						functions = "NONE",
						keywords = "italic", -- 키워드 이탤릭
						numbers = "NONE",
						operators = "NONE",
						strings = "NONE",
						types = "NONE",
						variables = "NONE",
					},
					inverse = {
						match_paren = false,
						visual = false,
						search = false,
					},
					modules = {}, -- 모듈별 세부 설정 (비워두면 module_default 적용)
				},
				palettes = {}, -- 팔레트 커스터마이즈 (기본값 사용)
				specs = {}, -- spec 커스터마이즈 (기본값 사용)
				groups = {}, -- 하이라이트 그룹 커스터마이즈 (기본값 사용)
			})
			if is_default_owner("nightfox") then
				vim.cmd("colorscheme " .. default_colorscheme) -- 기본 테마로 적용
			end
		end,
	},

	-- vague.nvim: 뮤트한 파스텔 톤 미니멀 다크 테마
	-- 기본 테마 소유 시 lazy=false 로 즉시 로드되고, 아니면 :colorscheme vague 실행 또는
	-- Telescope colorscheme 선택 시 자동 로드된다. variant 없이 단일 colorscheme 이름(vague)을 가진다.
	{
		"vague-theme/vague.nvim",
		lazy = not is_default_owner("vague"),
		priority = is_default_owner("vague") and 1000 or 100,
		init = function()
			-- :colorscheme vague 적용 시점에 fmt.Printf 의 %d, %s 같은 포맷 지정자를 강조.
			-- ColorScheme 이벤트로 등록하면 colorscheme 적용 직후 마지막에 덮어써져 가장 확실하다.
			-- printf 파서가 잡는 캡처 이름 후보 3종을 모두 동일 색으로 지정해 어떤 캡처여도 적용되게 한다.
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "vague",
				callback = function()
					local hl = { fg = "#7e98e8", bold = true } -- 차가운 파랑 + bold (vague 의 hint 색)
					vim.api.nvim_set_hl(0, "@string.special", hl)
					vim.api.nvim_set_hl(0, "@string.special.placeholder", hl)
					vim.api.nvim_set_hl(0, "@string.escape", hl)
				end,
			})
		end,
		config = function()
			require("vague").setup({
				transparent = false, -- 배경 투명 비활성
				bold = true, -- 굵게 전역 활성
				italic = true, -- 이탤릭 전역 활성
				on_highlights = function(hl, colors) end, -- 추가 하이라이트 커스터마이즈 훅 (autocmd 에서 처리)
				colors = {
					bg = "#141415", -- 배경
					inactiveBg = "#1c1c24", -- 비활성 창 배경
					fg = "#cdcdcd", -- 전경(기본 글자색)
					floatBorder = "#878787", -- 플로팅 창 테두리
					line = "#252530", -- 현재 줄 배경
					comment = "#606079", -- 주석
					builtin = "#b4d4cf", -- 내장 식별자
					func = "#c48282", -- 함수
					string = "#e8b589", -- 문자열
					number = "#e0a363", -- 숫자
					property = "#c3c3d5", -- 프로퍼티/필드
					constant = "#aeaed1", -- 상수
					parameter = "#bb9dbd", -- 함수 파라미터
					visual = "#333738", -- visual 선택 영역
					error = "#d8647e", -- 에러
					warning = "#f3be7c", -- 경고
					hint = "#7e98e8", -- 힌트
					operator = "#90a0b5", -- 연산자
					keyword = "#6e94b2", -- 키워드
					type = "#9bb4bc", -- 타입
					search = "#405065", -- 검색 하이라이트
					plus = "#7fa563", -- diff 추가
					delta = "#f3be7c", -- diff 변경
				},
			})
			if is_default_owner("vague") then
				vim.cmd("colorscheme " .. default_colorscheme) -- 기본 테마로 적용
			end
		end,
	},

	-- vim-one: Atom One 감성의 다크/라이트 테마
	-- viml 기반 플러그인이라 require().setup() 없이 vim.g 변수와 background 옵션으로만 설정한다.
	-- 기본 테마 소유 시 lazy=false 로 즉시 로드되고, 아니면 :colorscheme one 실행 또는
	-- Telescope colorscheme 선택 시 자동 로드된다.
	{
		"rakr/vim-one",
		lazy = not is_default_owner("one"),
		priority = is_default_owner("one") and 1000 or 100,
		init = function()
			vim.g.one_allow_italics = 1 -- 주석/키워드 이탤릭 허용
			-- :colorscheme one 적용 시 fmt.Printf 의 %d, %s 같은 포맷 지정자를 별도 색으로 강조.
			-- ColorScheme 이벤트로 등록해두면 기본 테마든 lazy 로드 후 전환이든 항상 적용된다.
			-- printf 파서가 잡는 캡처 이름 후보 3종을 모두 동일 색으로 지정해 어떤 캡처여도 적용되게 한다.
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "one",
				callback = function()
					local hl = { fg = "#56b6c2", bold = true } -- One Dark 시안 + bold
					vim.api.nvim_set_hl(0, "@string.special", hl)
					vim.api.nvim_set_hl(0, "@string.special.placeholder", hl)
					vim.api.nvim_set_hl(0, "@string.escape", hl)
				end,
			})
		end,
		config = function()
			if is_default_owner("one") then
				vim.opt.background = "dark" -- 다크 모드로 적용 (라이트 원하면 "light")
				vim.cmd("colorscheme " .. default_colorscheme) -- 기본 테마로 적용
			end
		end,
	},
}

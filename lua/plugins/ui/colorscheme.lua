-- ============================================================================
-- 파일명: ui/colorscheme.lua
--
-- 플러그인:
--   1. projekt0n/github-nvim-theme  - GitHub 공식 색감 기반 테마 (기본 적용)
--   2. rebelot/kanagawa.nvim        - 일본 우키요에 감성 다크 테마 (대체 테마)
--   3. rakr/vim-one                 - Atom One 감성의 다크/라이트 테마 (대체 테마)
--
-- 저장소:
--   https://github.com/projekt0n/github-nvim-theme
--   https://github.com/rebelot/kanagawa.nvim
--   https://github.com/rakr/vim-one
--
-- 설명:
--   github-theme - GitHub UI 색감 기반. dark_high_contrast variant는 고대비 다크 테마. (기본값)
--   kanagawa     - 호쿠사이의 '가나가와 해변의 큰 파도'에서 영감받은 테마.
--                  wave(기본 다크) / dragon(더 어두운 다크) / lotus(라이트) 3종 variant 제공.
--                  lazy=true 이므로 :colorscheme 명령 또는 Telescope colorscheme 선택 시 로드된다.
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
	one = { "one" },
}

-- default_colorscheme 를 소유한 provider(플러그인)를 시작 시 한 번만 판별해 둔다.
-- (기존엔 호출마다 리스트를 선형 탐색했지만, 결과는 불변이라 미리 계산해 캐싱한다)
local default_owner
for provider, names in pairs(colorscheme_providers) do
	for _, name in ipairs(names) do
		if name == default_colorscheme then
			default_owner = provider
			break
		end
	end
end

-- default_colorscheme 가 주어진 provider 소유인지 반환한다. (O(1))
local function is_default_owner(provider)
	return provider == default_owner
end

-- provider 가 기본 테마 소유자일 때만 해당 colorscheme 을 적용한다.
-- 각 플러그인 config 끝에서 반복되던 분기를 한 곳으로 모은 헬퍼.
local function apply_default(provider)
	if is_default_owner(provider) then
		vim.cmd("colorscheme " .. default_colorscheme) -- 기본 테마로 적용
	end
end

-- 지정한 colorscheme(pattern) 적용 시 fmt.Printf 포맷 지정자(%d, %s 등)를 hl 색으로 강조한다.
-- printf 파서가 잡는 캡처 이름 후보 3종을 모두 같은 색으로 지정해 어떤 캡처여도 적용되게 한다.
local function highlight_printf(pattern, hl)
	vim.api.nvim_create_autocmd("ColorScheme", {
		pattern = pattern,
		callback = function()
			vim.api.nvim_set_hl(0, "@string.special", hl)
			vim.api.nvim_set_hl(0, "@string.special.placeholder", hl)
			vim.api.nvim_set_hl(0, "@string.escape", hl)
		end,
	})
end

return {
	-- github-nvim-theme: GitHub 색감 기반 테마
	{
		"projekt0n/github-nvim-theme",
		lazy = not is_default_owner("github"), -- 기본 테마 소유 시 즉시 로드
		priority = is_default_owner("github") and 1000 or 100, -- 기본 테마면 최우선
		init = function()
			-- fmt.Printf 의 %d, %s 같은 포맷 동사는 printf injection 의 @character.printf 캡처로
			-- 잡히는데, 이 그룹이 @character 로 자동 fallback 되지 않아 색이 비어 문자열 색으로 보인다.
			-- github-theme 은 하이라이트를 컴파일·캐시하므로 setup 의 groups 변경이 늦게 반영될 수 있어,
			-- ColorScheme 직후 직접 덮어써 캐시와 무관하게 항상 적용되도록 한다.
			--
			-- 추가로, gopls(LSP) 는 문자열 리터럴 전체를 하나의 string semantic token 으로 보내고,
			-- semantic token 은 treesitter 보다 우선순위가 높아 %d 까지 문자열 색으로 덮어쓴다.
			-- @lsp.type.string.go 를 비워 gopls 의 문자열 토큰이 색을 입히지 않게 하면,
			-- 문자열 본문은 treesitter @string 이, %d 는 @character.printf 가 칠하게 된다.
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "github*",
				callback = function()
					local hl = { fg = "#a3d6f1", bold = true } -- 특수문자/이스케이프와 통일한 차가운 파랑
					vim.api.nvim_set_hl(0, "@character.printf", hl) -- printf 포맷 동사 (%d, %s 등)
					vim.api.nvim_set_hl(0, "@string.special.placeholder", hl) -- 다른 캡처명 후보 대비
					vim.api.nvim_set_hl(0, "@lsp.type.string.go", {}) -- gopls 문자열 semantic token 무력화 (treesitter 색 유지)
				end,
			})
		end,
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
						["DiffText"] = { bg = "#2e5d44", bold = true }, -- 변경된 글자 (은은한 미디엄 다크 그린, bold)

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
			apply_default("github")
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
			apply_default("kanagawa")
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
			highlight_printf("one", { fg = "#56b6c2", bold = true }) -- One Dark 시안 + bold
		end,
		config = function()
			if is_default_owner("one") then
				vim.opt.background = "dark" -- 다크 모드로 적용 (라이트 원하면 "light")
				vim.cmd("colorscheme " .. default_colorscheme) -- 기본 테마로 적용
			end
		end,
	},
}

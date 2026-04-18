-- ============================================================================
-- 파일명: editor/indent.lua
--
-- 플러그인: lukas-reineke/indent-blankline.nvim
-- 저장소: https://github.com/lukas-reineke/indent-blankline.nvim
--
-- 설명:
--   들여쓰기 레벨을 수직선(│)으로 시각화해주는 플러그인.
--   각 depth 마다 서로 다른 색을 입혀 중첩 구조를 한눈에 구분할 수 있게 한다.
--   커서가 위치한 현재 스코프(scope) 역시 동일한 depth 색상으로 강조된다.
--
--   네 종류의 팔레트를 제공하며 기분에 따라 자유롭게 전환할 수 있다.
--     1. pastel  - 은은한 파스텔톤 (배경과 튀지 않음)
--     2. rainbow - 선명한 무지개톤 (depth 구분이 가장 명확함)
--     3. mono    - 무채색 그라데이션 (차분한 그레이 톤)
--     4. focus   - 현재 스코프만 강조 (모든 depth 는 어두운 회색, 커서 스코프만 밝은 회색)
--
--   활용 예시:
--   - K8s manifest: spec.template.spec.containers 중첩 구조 파악
--   - Python: 함수/클래스/조건문 들여쓰기 레벨 구분
--   - Go: if/for/switch 중첩 블록 시각화
--
-- 사용법:
--   별도 조작 없이 파일을 열면 자동으로 표시된다.
--
-- ----------------------------------------------------------------------------
-- 팔레트 전환 방법
-- ----------------------------------------------------------------------------
--
--   [방법 1] 런타임 전환 (현재 nvim 세션에만 적용, 재시작하면 기본값으로 복귀)
--     :IblPalette pastel    - 은은한 파스텔톤 적용
--     :IblPalette rainbow   - 선명한 무지개톤 적용
--     :IblPalette mono      - 무채색 그라데이션 적용
--     :IblPalette focus     - 현재 스코프만 밝게 강조
--     :IblPalette           - 현재 적용된 팔레트 이름 출력
--     Tab 자동완성으로 팔레트 이름을 제안받을 수 있다.
--
--   [방법 2] 영구 기본값 변경 (nvim 시작 시 적용되는 팔레트 교체)
--     아래 `default` 변수의 값을 "pastel" / "rainbow" / "mono" / "focus" 중 하나로 수정한다.
--       예) local default = "focus"
--
--   [방법 3] 색상 자체 커스터마이즈
--     `palettes` 테이블에서 해당 팔레트의 hex 코드를 직접 수정하거나,
--     새 팔레트 키를 추가하면 :IblPalette 자동완성에 즉시 반영된다.
--     각 팔레트는 indent(모든 depth) / scope(커서 스코프) 두 색상 배열로 구성되며,
--     1개만 지정하면 모든 depth 에 동일 색이 적용되고 7개면 depth 별로 다르게 적용된다.
--       예) palettes.sunset = {
--             indent = { "#FFB199", "#FF8C7A", ... },
--             scope  = { "#FFB199", "#FF8C7A", ... },
--           }
--
-- 커스텀 단축키:
--   없음
-- ============================================================================

-- 기본 팔레트 (nvim 시작 시 적용되는 값)
local default = "focus"

-- depth 별 색상 팔레트 정의
--   indent: 모든 indent 가이드 색상 (depth 별 순환)
--   scope : 현재 커서가 위치한 스코프 하이라이트 색상 (depth 별 순환)
-- 색상 배열이 7개 미만이면 apply() 에서 순환 반복하여 7개로 확장된다.
local palettes = {
	-- 은은한 파스텔톤: One Dark 계열의 차분한 색상
	pastel = {
		indent = { "#E06C75", "#E5C07B", "#98C379", "#56B6C2", "#61AFEF", "#C678DD", "#D19A66" },
		scope = { "#E06C75", "#E5C07B", "#98C379", "#56B6C2", "#61AFEF", "#C678DD", "#D19A66" },
	},
	-- 선명한 무지개톤: Dracula 기반의 비비드한 색상
	rainbow = {
		indent = { "#FF5555", "#FFB86C", "#F1FA8C", "#50FA7B", "#8BE9FD", "#BD93F9", "#FF79C6" },
		scope = { "#FF5555", "#FFB86C", "#F1FA8C", "#50FA7B", "#8BE9FD", "#BD93F9", "#FF79C6" },
	},
	-- 무채색 그라데이션: 어두움 → 밝음 순 (depth 가 깊을수록 밝아짐)
	mono = {
		indent = { "#3A3A3A", "#4C4C4C", "#5E5E5E", "#767676", "#909090", "#ABABAB", "#C8C8C8" },
		scope = { "#3A3A3A", "#4C4C4C", "#5E5E5E", "#767676", "#909090", "#ABABAB", "#C8C8C8" },
	},
	-- 커서 스코프만 강조: 전체 indent 는 어두운 회색 단일, 현재 스코프만 밝은 회색
	focus = {
		indent = { "#3A3A3A" }, -- 어두운 회색 (배경과 거의 동화됨)
		scope = { "#D0D0D0" }, -- 밝은 회색 (커서가 위치한 스코프만 또렷함)
	},
}

-- depth 에 매핑할 하이라이트 그룹명 목록 (각 7개, indent-blankline 내부에서 depth 별로 순환된다)
local indent_groups = {
	"IblIndent1",
	"IblIndent2",
	"IblIndent3",
	"IblIndent4",
	"IblIndent5",
	"IblIndent6",
	"IblIndent7",
}
local scope_groups = {
	"IblScope1",
	"IblScope2",
	"IblScope3",
	"IblScope4",
	"IblScope5",
	"IblScope6",
	"IblScope7",
}

-- 색상 배열이 n 개보다 적으면 순환 반복하여 n 개로 확장한다.
-- focus 팔레트처럼 단일 색을 넣어도 모든 depth 에 동일하게 적용되도록 한다.
local function expand(colors, n)
	local out = {}
	for i = 1, n do
		out[i] = colors[((i - 1) % #colors) + 1]
	end
	return out
end

-- 현재 활성화된 팔레트 이름 (런타임 전환 시 갱신된다)
local active = default

-- 주어진 팔레트 이름에 해당하는 색을 indent / scope 하이라이트 그룹에 각각 적용한다.
-- 콜러스킴 재적용 훅과 :IblPalette 명령에서 공통으로 사용한다.
local function apply(name)
	local p = palettes[name]
	if not p then
		vim.notify("IblPalette: 알 수 없는 팔레트 '" .. tostring(name) .. "'", vim.log.levels.ERROR)
		return
	end
	active = name
	local indent_colors = expand(p.indent, #indent_groups)
	local scope_colors = expand(p.scope, #scope_groups)
	for i, group in ipairs(indent_groups) do
		vim.api.nvim_set_hl(0, group, { fg = indent_colors[i] })
	end
	for i, group in ipairs(scope_groups) do
		vim.api.nvim_set_hl(0, group, { fg = scope_colors[i] })
	end
end

return {
	"lukas-reineke/indent-blankline.nvim",
	event = { "BufReadPost", "BufNewFile" },
	main = "ibl", -- 플러그인의 메인 모듈명 (v3부터 ibl로 변경됨)
	config = function()
		-- 콜러스킴이 로드/재적용될 때마다 현재 팔레트를 다시 등록한다.
		-- 이 훅 덕분에 :colorscheme 변경 시에도 depth 색상이 유지된다.
		local hooks = require("ibl.hooks")
		hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
			apply(active)
		end)

		require("ibl").setup({
			indent = {
				char = "│", -- 들여쓰기 가이드 문자
				highlight = indent_groups, -- depth 별 indent 색상 순환 적용
			},
			scope = {
				enabled = true, -- 현재 커서가 위치한 스코프를 강조 표시
				highlight = scope_groups, -- depth 별 scope 색상 (focus 팔레트에서 indent 와 분리됨)
			},
		})

		-- :IblPalette <name> 유저 명령 등록
		--   인자 없이 호출하면 현재 팔레트 이름을 출력한다.
		--   Tab 자동완성으로 팔레트 이름을 제안한다.
		vim.api.nvim_create_user_command("IblPalette", function(opts)
			if opts.args == "" then
				vim.notify("IblPalette: 현재 팔레트 '" .. active .. "'", vim.log.levels.INFO)
				return
			end
			apply(opts.args)
		end, {
			nargs = "?",
			complete = function()
				return vim.tbl_keys(palettes)
			end,
			desc = "indent-blankline depth 색상 팔레트 전환",
		})
	end,
}

-- ============================================================================
-- 파일명: lsp/blink.lua
--
-- 플러그인: saghen/blink.cmp
-- 저장소: https://github.com/saghen/blink.cmp
--
-- 설명:
--   LSP, 스니펫, 버퍼, 경로를 통합하는 고성능 자동완성 엔진.
--   nvim-cmp 대비 Rust 기반 퍼지 매처로 속도가 빠르고 메모리 사용량이 적다.
--   LuaSnip을 스니펫 엔진으로 사용하며, friendly-snippets의 언어별 스니펫을 로드한다.
--
-- 자동완성 소스 우선순위:
--   lsp → snippets → path → buffer
--
-- 사용법:
--   Insert 모드에서 타이핑 시 자동완성 팝업이 표시된다.
--
-- 자동완성 창 단축키:
--   <C-n>       - 다음 항목 선택
--   <C-p>       - 이전 항목 선택
--   <C-y>       - 현재 항목 즉시 선택 후 확정
--   <C-e>       - 자동완성 창 닫기
--   <CR>        - 선택 확정 (명시적으로 선택한 항목만, 자동 선택 방지)
--   <Tab>       - 스니펫 다음 위치로 이동 / 다음 항목 선택
--   <S-Tab>     - 스니펫 이전 위치로 이동 / 이전 항목 선택
--
-- 커스텀 단축키:
--   없음
-- ============================================================================

return {
	{
		"saghen/blink.cmp",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				dependencies = { "rafamadriz/friendly-snippets" },
				config = function()
					-- friendly-snippets의 VSCode 형식 스니펫을 LuaSnip에 로드
					require("luasnip.loaders.from_vscode").lazy_load()
				end,
			},
		},
		version = "*", -- 안정 버전 고정
		event = { "InsertEnter", "CmdlineEnter" },
		opts = {
			-- 스니펫 엔진: LuaSnip 사용
			snippets = { preset = "luasnip" },

			-- 키맵 (nvim-cmp와 동일한 동작 유지)
			keymap = {
				preset = "none",
				["<C-n>"] = { "select_next", "fallback" },
				["<C-p>"] = { "select_prev", "fallback" },
				["<C-y>"] = { "select_and_accept" }, -- 자동 선택 후 즉시 확정
				["<C-e>"] = { "hide", "fallback" },
				-- accept: 명시적으로 선택된 항목만 확정 (자동 선택 방지)
				["<CR>"] = { "accept", "fallback" },
				-- Tab: 스니펫 이동 우선, 없으면 다음 항목 선택
				["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
				["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
			},

			-- 자동완성 소스
			sources = {
				default = { "lsp", "snippets", "path", "buffer" },
				-- 소스별 표시 이름
				providers = {
					lsp = { name = "LSP" },
					snippets = { name = "Snip" },
					path = { name = "Path" },
					buffer = { name = "Buf" },
				},
			},

			-- 자동완성 동작
			completion = {
				-- 괄호 자동 닫기 (함수 자동완성 시 () 자동 추가)
				accept = { auto_brackets = { enabled = true } },

				-- 문서 팝업 자동 표시
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
				},

				-- 자동완성 메뉴 레이아웃
				-- 좌측: 항목명 + 설명 / 우측: 타입 아이콘 + 소스명
				menu = {
					draw = {
						columns = {
							{ "label", "label_description", gap = 1 },
							{ "kind_icon", "source_name" },
						},
					},
				},
			},

			-- 외형
			appearance = {
				use_nvim_cmp_as_default = false,
				nerd_font_variant = "mono",
			},
		},
	},
}

-- ============================================================================
-- 파일명: lsp-cmp.lua
--
-- 플러그인: hrsh7th/nvim-cmp
--           hrsh7th/cmp-nvim-lsp
--           hrsh7th/cmp-buffer
--           hrsh7th/cmp-path
--           saadparwaiz1/cmp_luasnip
--           L3MON4D3/LuaSnip
--           rafamadriz/friendly-snippets
-- 저장소:
--   https://github.com/hrsh7th/nvim-cmp          (자동완성 엔진)
--   https://github.com/hrsh7th/cmp-nvim-lsp       (LSP 소스)
--   https://github.com/hrsh7th/cmp-buffer         (버퍼 소스)
--   https://github.com/hrsh7th/cmp-path           (경로 소스)
--   https://github.com/saadparwaiz1/cmp_luasnip   (스니펫 소스)
--   https://github.com/L3MON4D3/LuaSnip           (스니펫 엔진)
--   https://github.com/rafamadriz/friendly-snippets (언어별 스니펫 모음)
--
-- 설명:
--   LSP, 스니펫, 버퍼, 경로를 통합하는 자동완성 엔진.
--   자동완성 소스 우선순위: LSP > 스니펫(LuaSnip) > 버퍼 > 경로
--   LuaSnip은 스니펫 엔진이고, friendly-snippets는 Go/Python/Bash 등
--   언어별 실용 스니펫 모음으로 자동으로 로드된다.
--   팝업 우측에 소스 출처([LSP], [Snip], [Buf], [Path])가 표시된다.
--
-- 사용법:
--   Insert 모드에서 타이핑 시 자동완성 팝업이 표시된다.
--   :CmpStatus  - 현재 소스 상태 확인
--
-- 자동완성 창 단축키:
--   <C-n>       - 다음 항목 선택
--   <C-p>       - 이전 항목 선택
--   <C-y>       - 선택 확정
--   <C-e>       - 자동완성 창 닫기
--   <CR>        - 선택 확정 (명시적으로 선택한 항목만)
--   <Tab>       - 다음 항목 선택 / 스니펫 다음 위치로 이동
--   <S-Tab>     - 이전 항목 선택 / 스니펫 이전 위치로 이동
--
-- 커스텀 단축키:
--   없음
-- ============================================================================

return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp", -- LSP 자동완성 소스
		"hrsh7th/cmp-buffer", -- 현재 버퍼 단어 소스
		"hrsh7th/cmp-path", -- 파일 경로 소스
		"saadparwaiz1/cmp_luasnip", -- LuaSnip 스니펫 소스
		{
			"L3MON4D3/LuaSnip",
			dependencies = { "rafamadriz/friendly-snippets" },
			config = function()
				-- friendly-snippets의 VSCode 형식 스니펫을 LuaSnip에 로드
				require("luasnip.loaders.from_vscode").lazy_load()
			end,
		},
	},
	event = "InsertEnter", -- insert 모드 진입 시 로드 (시작 속도 최적화)
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")

		cmp.setup({
			snippet = {
				-- 스니펫 확장 시 LuaSnip을 엔진으로 사용
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-n>"] = cmp.mapping.select_next_item(),
				["<C-p>"] = cmp.mapping.select_prev_item(),
				["<C-y>"] = cmp.mapping.confirm({ select = true }), -- 현재 항목 바로 확정
				["<C-e>"] = cmp.mapping.abort(),
				-- select = false: 팝업에서 명시적으로 선택한 항목만 확정 (자동 선택 방지)
				["<CR>"] = cmp.mapping.confirm({ select = false }),
				-- <Tab>: 자동완성 팝업이 열려 있으면 다음 항목 선택,
				--        스니펫 내부에 있으면 다음 입력 위치로 이동,
				--        둘 다 아니면 기본 Tab 동작
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),
				-- <S-Tab>: Tab의 역방향 동작
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			-- 자동완성 소스 우선순위: LSP > 스니펫 > 버퍼 > 경로
			sources = cmp.config.sources({
				{ name = "nvim_lsp" }, -- LSP 서버 제안
				{ name = "luasnip" }, -- 스니펫
				{ name = "buffer" }, -- 현재 버퍼의 단어
				{ name = "path" }, -- 파일 경로
			}),
			-- 자동완성 팝업 우측에 소스 출처 표시 ([LSP], [Snip] 등)
			formatting = {
				format = function(entry, item)
					local source_labels = {
						nvim_lsp = "[LSP]",
						luasnip = "[Snip]",
						buffer = "[Buf]",
						path = "[Path]",
					}
					item.menu = source_labels[entry.source.name] or ""
					return item
				end,
			},
		})
	end,
}

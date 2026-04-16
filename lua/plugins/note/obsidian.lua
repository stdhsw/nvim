-- ============================================================================
-- 파일명: note/obsidian.lua
--
-- 플러그인: epwalsh/obsidian.nvim
-- 저장소: https://github.com/epwalsh/obsidian.nvim
--
-- 설명:
--   Obsidian vault 와 Neovim 을 통합하는 노트 관리 플러그인.
--   Markdown 기반의 PKM(Personal Knowledge Management) 작업을
--   Neovim 안에서 수행할 수 있도록 한다.
--   vault 경로: ~/Documents/obsidian
--
-- 사전 준비:
--   1. ~/Documents/obsidian 디렉토리 생성 (vault 루트)
--   2. ripgrep 필요 (검색 기능 — telescope 설치 시 이미 요구되어 충족)
--
-- 사용법:
--   - vault 내 .md 파일을 열면 자동 활성화 (ft = "markdown")
--   - [[링크]] 문법으로 노트 간 연결
--   - gf 로 wiki-link 따라가기
--   - <leader>o 로 시작하는 단축키로 주요 기능 사용
--
-- 렌더링 설정:
--   UI 렌더링(헤더 아이콘, 체크박스 등)은 render-markdown.nvim 이 전담.
--   obsidian.nvim 의 자체 UI(`ui.enable = false`)는 비활성화하여 충돌 방지.
--
-- 커스텀 단축키 (config/keymaps.lua):
--   <leader>on : 새 노트 생성 (ObsidianNew)
--   <leader>oo : 현재 노트를 Obsidian 앱에서 열기 (ObsidianOpen)
--   <leader>os : vault 전체 grep 검색 (ObsidianSearch)
--   <leader>oq : 노트 빠른 전환 (ObsidianQuickSwitch)
--   <leader>ot : 오늘 일간 노트 (ObsidianToday)
--   <leader>oy : 어제 일간 노트 (ObsidianYesterday)
--   <leader>om : 내일 일간 노트 (ObsidianTomorrow)
--   <leader>ob : 현재 노트의 백링크 (ObsidianBacklinks)
--   <leader>og : 태그 검색 (ObsidianTags)
--   <leader>op : 클립보드 이미지 붙여넣기 (ObsidianPasteImg)
--   <leader>or : 노트 이름 변경 (ObsidianRename)
--   <leader>ow : 템플릿 삽입 (ObsidianTemplate)
-- ============================================================================

return {
	"epwalsh/obsidian.nvim",
	version = "*",
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	opts = {
		-- vault 정의
		workspaces = {
			{
				name = "obsidian",
				path = "~/Documents/obsidian",
			},
		},

		-- 새 노트 저장 위치: vault 루트 아래 notes/ 디렉토리
		new_notes_location = "notes_subdir",
		notes_subdir = "notes",

		-- 일간 노트 설정 (vault/daily/ 에 저장)
		daily_notes = {
			folder = "daily",
			date_format = "%Y-%m-%d",
			default_tags = { "daily" },
		},

		-- 템플릿 설정 (vault/templates/ 에 저장)
		templates = {
			folder = "templates",
			date_format = "%Y-%m-%d",
			time_format = "%H:%M",
		},

		-- 첨부파일(이미지) 저장 경로: vault/assets/
		attachments = {
			img_folder = "assets",
		},

		-- 검색/picker 로 telescope 사용
		picker = {
			name = "telescope.nvim",
		},

		-- 자동완성은 blink.cmp 사용 중이므로 obsidian.nvim 의 nvim-cmp 통합 비활성화
		completion = {
			nvim_cmp = false,
			min_chars = 2,
		},

		-- UI 렌더링은 render-markdown.nvim 이 전담 — 충돌 방지용 비활성화
		ui = {
			enable = false,
		},

		-- 외부 URL 따라가기 (macOS open 명령)
		follow_url_func = function(url)
			vim.fn.jobstart({ "open", url })
		end,
	},
}

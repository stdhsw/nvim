-- ============================================================================
-- 파일명: file-neo-tree.lua
--
-- 플러그인: nvim-neo-tree/neo-tree.nvim
-- 저장소: https://github.com/nvim-neo-tree/neo-tree.nvim
--
-- 설명:
--   neovim용 파일 탐색기 사이드바 플러그인.
--   프로젝트 디렉토리 구조를 트리 형태로 시각화하며,
--   파일 생성/삭제/이동/복사 등의 파일 시스템 작업을 지원한다.
--   Go 패키지 구조, K8s manifest 디렉토리 탐색에 유용하다.
--
-- 사용법:
--   :Neotree toggle        - 파일 탐색기 열기/닫기
--   :Neotree reveal        - 현재 파일 위치를 탐색기에서 표시
--   :Neotree focus         - 탐색기 창으로 포커스 이동
--   :Neotree close         - 탐색기 닫기
--
-- neo-tree 창 내부 단축키:
--   <CR> / o   - 파일 열기 / 디렉토리 펼치기
--   S          - 수직 분할로 파일 열기
--   s          - 수평 분할로 파일 열기
--   a          - 파일/디렉토리 생성
--   d          - 파일/디렉토리 삭제
--   r          - 파일/디렉토리 이름 변경
--   y          - 파일 경로 복사
--   c          - 파일 복사
--   m          - 파일 이동
--   q          - 탐색기 닫기
--   R          - 디렉토리 새로고침
--   H          - 숨김 파일 표시/숨김 토글
--   /          - 파일명 검색 (필터)
--   <BS>       - 상위 디렉토리로 이동
--   E          - 모든 디렉토리 펼치기
--   C          - 모든 디렉토리 접기
--
-- 커스텀 단축키 (config/keymaps.lua 참고):
--   <leader>e   - 탐색기 열기/닫기 토글
--   <leader>E   - 탐색기 포커스
--   <leader>er  - 현재 파일 위치를 탐색기에서 표시
--   <leader>ge  - Git 상태 탐색기 토글
-- ============================================================================

return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	lazy = true,
	cmd = "Neotree",
	opts = {
		close_if_last_window = true, -- 마지막 창이면 neovim 종료
		popup_border_style = "rounded",

		default_component_configs = {
			indent = {
				indent_size = 2,
				padding = 1,
				with_markers = true,
				indent_marker = "│",
				last_indent_marker = "└",
			},
			icon = {
				folder_closed = "",
				folder_open = "",
				folder_empty = "",
			},
			git_status = {
				symbols = {
					added = "",
					modified = "",
					deleted = "✖",
					renamed = "󰁕",
					untracked = "",
					ignored = "",
					unstaged = "󰄱",
					staged = "",
					conflict = "",
				},
			},
		},

		filesystem = {
			filtered_items = {
				visible = true, -- 숨김/gitignore 파일 기본적으로 표시
				hide_dotfiles = false, -- dotfile 표시 (.env, .gitignore 등)
				hide_gitignored = false, -- .gitignore에 명시된 파일도 표시
				hide_by_name = {
					".DS_Store",
				},
			},
			follow_current_file = {
				enabled = true, -- 현재 편집 파일을 탐색기에서 자동 추적
			},
			use_libuv_file_watcher = true, -- 파일 시스템 변경 자동 감지
		},

		window = {
			position = "left",
			width = 35,
			mappings = {
				["<space>"] = "none", -- leader 키 충돌 방지
				["E"] = "expand_all_nodes", -- 모든 디렉토리 펼치기
				["C"] = "close_all_nodes", -- 모든 디렉토리 접기
			},
		},
	},
}

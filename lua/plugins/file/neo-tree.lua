-- ============================================================================
-- 파일명: file/neo-tree.lua
--
-- 플러그인: nvim-neo-tree/neo-tree.nvim
-- 저장소: https://github.com/nvim-neo-tree/neo-tree.nvim
--
-- 설명:
--   neovim용 파일 탐색기 사이드바 플러그인.
--   프로젝트 디렉토리 구조를 트리 형태로 시각화하며,
--   파일 생성/삭제/이동/복사 등의 파일 시스템 작업을 지원한다.
--   filesystem / buffers / git_status 3개 source 를 상단 winbar 탭으로 전환 가능.
--   세부 컴포넌트(아이콘, 들여쓰기, git 심볼 등)는 neo-tree 기본값을 그대로 사용한다.
--
-- 사용법:
--   :Neotree toggle              - 파일 탐색기 열기/닫기
--   :Neotree reveal              - 현재 파일 위치를 탐색기에서 표시
--   :Neotree focus               - 탐색기 창으로 포커스 이동
--   :Neotree close               - 탐색기 닫기
--   :Neotree source=buffers      - 열린 버퍼 목록 보기
--   :Neotree source=git_status   - Git 변경 파일 목록 보기
--
-- neo-tree 창 내부 단축키:
--   <CR> / o   - 파일 열기 / 디렉토리 펼치기
--   l          - 파일 열기 / 디렉토리 펼치기 (vim 스타일)
--   h          - 디렉토리 접기 (vim 스타일)
--   S          - 수직 분할로 파일 열기
--   s          - 수평 분할로 파일 열기
--   t          - 새 탭으로 파일 열기
--   P          - 파일 미리보기 (팝업)
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
--   <          - 이전 source 로 전환 (filesystem ↔ buffers ↔ git_status)
--   >          - 다음 source 로 전환
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
		"nvim-lua/plenary.nvim", -- Lua 유틸리티 라이브러리 (파일시스템 스캔 등)
		"nvim-tree/nvim-web-devicons", -- 파일 타입별 컬러 아이콘
		"MunifTanjim/nui.nvim", -- UI 컴포넌트 라이브러리 (팝업, 트리 렌더링)
	},
	-- lazy load 비활성화: nvim 시작 직후 바로 사용 가능하도록 즉시 로드
	-- (lazy = true, cmd = "Neotree" 로 설정하면 :Neotree 첫 실행 시 로드되지만
	--  첫 호출이 살짝 지연되므로 본 설정은 즉시 로드를 선호)
	-- lazy = true,
	-- cmd = "Neotree",
	opts = {
		-- ====================================================================
		-- 전역 설정
		-- ====================================================================
		close_if_last_window = true, -- neo-tree 창만 남으면 neovim 종료
		popup_border_style = "rounded", -- 팝업 창 테두리 스타일 (rounded/single/double/solid)
		enable_git_status = true, -- Git 상태 표시 활성화 (변경/추가/삭제 심볼)
		enable_diagnostics = true, -- LSP 진단 정보 표시 활성화 (에러/경고 심볼)
		enable_modified_markers = true, -- 저장 안 된 버퍼에 수정 표시기 표시
		enable_opened_markers = true, -- 열려 있는 버퍼에 표시기 표시
		enable_refresh_on_write = true, -- 파일 저장 시 트리 자동 새로고침
		sort_case_insensitive = false, -- 정렬 시 대소문자 구분 (false = 구분함)

		-- ====================================================================
		-- 컴포넌트 기본 설정: 들여쓰기, 접기/펴기, 디렉토리 아이콘
		-- ====================================================================
		default_component_configs = {
			indent = {
				with_markers = true,
				with_expanders = true, -- 접기/펴기 아이콘 활성화
				expander_collapsed = ">", -- 디렉토리 닫힘 아이콘
				expander_expanded = "-", -- 디렉토리 열림 아이콘
				expander_highlight = "NeoTreeExpander",
			},
		},

		-- ====================================================================
		-- Source Selector: 상단 winbar 탭 (filesystem / buffers / git_status 전환)
		-- ====================================================================
		source_selector = {
			winbar = true, -- winbar(창 상단)에 source 탭 표시
			statusline = false, -- 상태줄에는 표시 안 함
			show_scrolled_off_parent_node = false, -- 스크롤 시 부모 노드 winbar 에 표시 여부
			-- 표시할 source 탭 목록 (각 항목은 neo-tree 에 등록된 source 와 1:1 매칭)
			sources = {
				{ source = "filesystem", display_name = "  Files " }, -- 파일 탐색기
				{ source = "buffers", display_name = "  Buffers " }, -- 열린 버퍼 목록
				{ source = "git_status", display_name = "  Git " }, -- Git 변경 파일 목록
			},
			content_layout = "center", -- 탭 내부 텍스트 정렬 (start/center/end)
			tabs_layout = "equal", -- 탭 너비 분배 방식 (equal/start/end/center)
			truncation_character = "…", -- 탭 텍스트가 너비를 초과할 때 표시할 문자
			padding = 0, -- 각 탭 양옆 패딩
			separator = { left = "▏", right = "▕" }, -- 탭 좌/우 구분 문자
			show_separator_on_edge = false, -- 가장 좌/우 가장자리에도 구분선 표시 여부
		},

		-- ====================================================================
		-- 윈도우 (사이드바) 설정
		-- ====================================================================
		window = {
			position = "left", -- 사이드바 위치 (left/right/top/bottom/float/current)
			width = 35, -- 사이드바 너비 (문자 수)
			auto_expand_width = false, -- 긴 파일명에 맞춰 너비 자동 확장 여부
			-- 팝업 형태로 열 때의 크기/위치 (position = "float" 일 때만 적용)
			popup = {
				size = { height = "80%", width = "50%" },
				position = "50%", -- 화면 중앙
			},
			-- 매핑 공통 옵션
			mapping_options = {
				noremap = true, -- 재귀 매핑 비활성화
				nowait = true, -- 키 입력 대기시간 무시 (즉시 반응)
			},
			-- neo-tree 창 내부 키 매핑 (커스텀)
			mappings = {
				["<space>"] = "none", -- leader 키 충돌 방지 (기본 toggle_node 비활성화)
				["l"] = "open", -- l : 파일 열기 / 디렉토리 펼치기 (vim 스타일)
				["h"] = "close_node", -- h : 디렉토리 접기 (vim 스타일)
				["E"] = "expand_all_nodes", -- E : 모든 디렉토리 펼치기
				["C"] = "close_all_nodes", -- C : 모든 디렉토리 접기
				["P"] = { "toggle_preview", config = { use_float = true } }, -- P : 파일 미리보기 (팝업)
				["<"] = "prev_source", -- < : 이전 source 로 전환
				[">"] = "next_source", -- > : 다음 source 로 전환
			},
		},

		-- ====================================================================
		-- Filesystem source: 파일 탐색기 (기본 source)
		-- ====================================================================
		filesystem = {
			-- 숨김/필터링 옵션
			filtered_items = {
				visible = true, -- 필터된 항목도 회색으로 표시 (true = 보이게)
				force_visible_in_empty_folder = false, -- 빈 폴더에서 숨김 파일 강제 표시 여부
				show_hidden_count = true, -- 숨겨진 파일 개수 표시
				hide_dotfiles = false, -- dotfile 표시 (.env, .gitignore 등)
				hide_gitignored = false, -- .gitignore 파일도 표시
				hide_hidden = false, -- Windows 숨김 속성 파일 처리
				hide_by_name = { -- 파일명으로 숨김 처리
					".DS_Store", -- macOS 메타데이터
					"thumbs.db", -- Windows 썸네일 캐시
				},
				hide_by_pattern = {}, -- glob 패턴으로 숨김 (예: "*.meta")
				always_show = {}, -- 위에서 숨긴 항목 중 강제로 보일 것
				never_show = {}, -- 항상 숨길 항목 (visible=true 무시)
			},
			-- 현재 편집 파일 자동 추적 (편집 중인 파일을 탐색기에서 자동 하이라이트)
			follow_current_file = {
				enabled = true, -- 현재 편집 파일을 탐색기에서 자동 reveal
				leave_dirs_open = false, -- 추적 시 펼쳐진 다른 디렉토리 유지 여부
			},
			group_empty_dirs = false, -- 빈 중첩 디렉토리 한 줄로 그룹화 (a/b/c 형태)
			hijack_netrw_behavior = "open_default", -- netrw 대체 (open_default/open_current/disabled)
			use_libuv_file_watcher = true, -- libuv 기반 파일시스템 변경 자동 감지 (폴링보다 빠름)
		},

		-- ====================================================================
		-- Buffers source: 열린 버퍼 목록
		-- ====================================================================
		buffers = {
			follow_current_file = {
				enabled = true, -- 현재 버퍼 자동 추적
				leave_dirs_open = false,
			},
			group_empty_dirs = true, -- 빈 디렉토리 그룹화
			show_unloaded = true, -- 로드 안 된(숨겨진) 버퍼도 목록에 포함
		},

		-- ====================================================================
		-- Git Status source: Git 변경 파일 목록
		-- ====================================================================
		git_status = {
			window = {
				position = "left", -- Git 상태는 떠있는 창(float, left, right)으로 표시
			},
		},
	},
}

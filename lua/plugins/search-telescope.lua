-- ============================================================================
-- 파일명: search-telescope.lua
--
-- 플러그인: nvim-telescope/telescope.nvim
--           nvim-telescope/telescope-fzf-native.nvim
-- 저장소: https://github.com/nvim-telescope/telescope.nvim
--         https://github.com/nvim-telescope/telescope-fzf-native.nvim
--
-- 설명:
--   파일, 코드, Git 이력, LSP 심볼 등 모든 것을 퍼지 검색으로 찾는 플러그인.
--   telescope-fzf-native는 C로 컴파일된 fzf 알고리즘으로 검색 속도를 향상시킨다.
--   .git/, node_modules/ 는 검색 대상에서 자동 제외된다.
--
--   사전 요구사항:
--   brew install fd       (필수 - find_files에서 .gitignore 무시 및 숨김 파일 검색에 사용)
--   brew install ripgrep  (필수 - live_grep 텍스트 검색에 사용)
--
-- 사용법:
--   :Telescope                    - 사용 가능한 picker 목록 표시
--   :Telescope find_files         - 파일 찾기
--   :Telescope live_grep          - 텍스트 실시간 검색
--   :Telescope lsp_definitions    - LSP 정의 검색
--   :Telescope lsp_references     - LSP 참조 검색
--   :Telescope git_commits        - git 커밋 히스토리 검색
--   :Telescope colorscheme        - 테마 선택 (실시간 미리보기)
--
--   telescope 창 내부 단축키:
--   <C-n> / <C-p>   - 다음/이전 결과로 이동
--   <C-x>           - 수평 분할로 파일 열기
--   <C-v>           - 수직 분할로 파일 열기
--   <C-t>           - 새 탭으로 파일 열기
--   <C-u> / <C-d>   - 미리보기 창 스크롤
--   <C-q>           - 결과를 quickfix 목록으로 전송
--   <Tab>           - 다중 선택 토글
--   <Esc>           - telescope 닫기
--
-- 커스텀 단축키 (config/keymaps.lua 참고):
--   <leader>ff  - 파일 찾기
--   <leader>fg  - 텍스트 검색 (live grep)
--   <leader>fb  - 열린 버퍼 목록
--   <leader>fr  - 최근 파일 목록
--   <leader>fh  - 도움말 검색
--   <leader>ft  - 프로젝트 전체 TODO 검색
--   <leader>tc  - 테마 선택
--   <leader>ks  - 등록된 단축키 검색
-- ============================================================================

return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim", -- telescope 필수 의존성 (유틸 라이브러리)
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make", -- C로 컴파일하여 검색 성능 향상 (make 필요)
		},
	},
	cmd = "Telescope", -- :Telescope 명령어 입력 시 로드
	opts = {
		defaults = {
			layout_strategy = "horizontal",
			layout_config = {
				horizontal = {
					preview_width = 0.55, -- 우측 미리보기 창이 전체의 55% 차지
				},
			},
			-- 검색 결과에서 제외할 패턴
			file_ignore_patterns = { "%.git/", "node_modules/" },
		},
		pickers = {
			find_files = {
				-- fd가 .gitignore를 무시하고 숨김 파일 포함 모든 파일 검색
				find_command = { "fd", "--type", "f", "--no-ignore", "--hidden", "--exclude", ".git", "--exclude", "node_modules" },
			},
			live_grep = {
				-- ripgrep이 .gitignore를 무시하고 숨김 파일 포함 모든 파일 검색
				additional_args = { "--no-ignore", "--hidden", "--glob", "!.git", "--glob", "!node_modules" },
			},
		},
		extensions = {
			fzf = {
				fuzzy = true, -- 퍼지 검색 활성화 (오타 허용)
				override_generic_sorter = true, -- 기본 정렬기를 fzf로 교체
				override_file_sorter = true, -- 파일 정렬기를 fzf로 교체
			},
		},
	},
	config = function(_, opts)
		local telescope = require("telescope")
		telescope.setup(opts)
		telescope.load_extension("fzf") -- fzf-native 확장 활성화
	end,
}

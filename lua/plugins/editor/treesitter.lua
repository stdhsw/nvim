-- ============================================================================
-- 파일명: editor/treesitter.lua
--
-- 플러그인: nvim-treesitter/nvim-treesitter
-- 저장소: https://github.com/nvim-treesitter/nvim-treesitter
--
-- 설명:
--   AST(Abstract Syntax Tree) 기반으로 정확한 문법 하이라이팅,
--   코드 폴딩, 들여쓰기를 제공하는 플러그인.
--
--   nvim 0.12 + 새 nvim-treesitter API:
--   setup()은 install_dir만 지원. highlight/indent/ensure_installed는 직접 처리.
--   FileType autocmd로 vim.treesitter.start() 명시 호출하여 활성화.
--
--   기본 파서 (항상 설치):
--   lua, vim, vimdoc, query, markdown, markdown_inline
--
--   언어별 파서는 lua/extras/lang/ 의 각 파일에서 관리한다.
--   extras의 init 함수가 vim.g.extra_treesitter_parsers에 파서명을 추가하고,
--   이 파일의 config 함수가 실행될 때 합산하여 설치한다.
--
--   사전 요구사항:
--   brew install tree-sitter-cli  (파서 빌드 시 필요)
--
-- 사용법:
--   :TSInstall <언어>              - 특정 언어 파서 수동 설치
--   :TSUpdate                      - 설치된 파서 전체 업데이트
--   :TSUninstall <언어>            - 특정 언어 파서 삭제
--   :checkhealth nvim-treesitter   - 파서 설치 상태 확인
--   :InspectTree                   - 현재 버퍼의 AST 구조 확인
--   :Inspect                       - 커서 위치의 highlight 그룹 확인
--
-- 커스텀 단축키:
--   없음
-- ============================================================================

return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	lazy = false,
	config = function()
		require("nvim-treesitter").setup()

		-- 기본 파서 (언어 무관, 항상 설치)
		local base_parsers = {
			"lua",
			"vim",
			"vimdoc",
			"query",
			"markdown",
			"markdown_inline",
		}

		-- extras에서 주입된 언어별 파서 수집
		-- extras의 init 함수가 vim.g.extra_treesitter_parsers에 파서를 추가함
		local extra_parsers = vim.g.extra_treesitter_parsers or {}

		-- 전체 파서 목록 합산 후 설치
		local all_parsers = {}
		vim.list_extend(all_parsers, base_parsers)
		vim.list_extend(all_parsers, extra_parsers)
		require("nvim-treesitter.install").install(all_parsers)

		-- treesitter 하이라이팅 활성화
		-- nvim-treesitter main 브랜치(0.12+)는 자동 attach 가 없으므로
		-- FileType 이벤트마다 vim.treesitter.start() 를 직접 호출해야 한다.
		-- pcall: 파서가 설치되지 않은 ft 에서 실패해도 무시
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
			callback = function(args)
				pcall(vim.treesitter.start, args.buf)
			end,
		})
	end,
}

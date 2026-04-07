-- ============================================================================
-- 파일명: editor-treesitter.lua
--
-- 플러그인: nvim-treesitter/nvim-treesitter
-- 저장소: https://github.com/nvim-treesitter/nvim-treesitter
--
-- 설명:
--   AST(Abstract Syntax Tree) 기반으로 정확한 문법 하이라이팅,
--   코드 폴딩, 들여쓰기를 제공하는 플러그인.
--   기존 정규식 기반 방식보다 언어 구조를 정확하게 파악하여
--   중첩된 코드, 멀티라인 표현식도 정확하게 하이라이팅한다.
--
--   자동 설치 파서:
--   go, python, lua, sql, query, yaml, json,
--   bash, dockerfile, make, vim, vimdoc, markdown, markdown_inline
--
--   nvim 0.12 + 새 nvim-treesitter API 변경사항:
--   setup()은 install_dir만 지원. highlight/indent/ensure_installed는 직접 처리.
--   FileType autocmd로 vim.treesitter.start() 명시 호출하여 편집 버퍼에도 활성화.
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
-- 코드 폴딩 단축키 (neovim 기본):
--   zc   - 현재 블록 접기
--   zo   - 현재 블록 펼치기
--   za   - 현재 블록 접기/펼치기 토글
--   zM   - 모든 블록 접기
--   zR   - 모든 블록 펼치기
--
-- 커스텀 단축키:
--   없음
-- ============================================================================

return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate", -- 플러그인 설치/업데이트 시 파서 자동 빌드
	lazy = false, -- 시작 시 즉시 로드 (지연 로드 시 첫 파일에서 하이라이팅 미적용)
	config = function()
		-- nvim 0.12의 새 nvim-treesitter API: setup()은 install_dir만 지원
		-- ensure_installed, highlight, indent 등은 직접 처리해야 함
		require("nvim-treesitter").setup()

		-- 파서 자동 설치 (새 API에서는 install() 직접 호출)
		require("nvim-treesitter.install").install({
			"go",
			"python",
			"lua",
			"sql",
			"query",
			"yaml",
			"json",
			"bash",
			"dockerfile",
			"make",
			"vim",
			"vimdoc",
			"markdown",
			"markdown_inline",
		})

		-- treesitter 하이라이팅 활성화 (FileType 이벤트마다 명시적으로 시작)
		-- Telescope 미리보기와 편집 버퍼가 동일하게 treesitter를 사용하게 됨
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				-- 파서가 없는 파일타입은 조용히 무시 (pcall로 에러 방지)
				pcall(vim.treesitter.start, args.buf)
			end,
		})
	end,
}

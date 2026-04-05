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
		require("nvim-treesitter").setup({
			-- 시작 시 자동으로 설치할 파서 목록
			ensure_installed = {
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
			},
			-- ensure_installed에 없는 언어 파일을 열면 파서 자동 설치
			auto_install = true,
			-- treesitter 기반 문법 하이라이팅 (기존 정규식 방식보다 정확)
			highlight = { enable = true },
			-- treesitter 기반 자동 들여쓰기 (= 키로 코드 정렬 시 사용)
			indent = { enable = true },
		})
	end,
}

-- ============================================================================
-- 파일명: git/git-conflict.lua
--
-- 플러그인: akinsho/git-conflict.nvim
-- 저장소: https://github.com/akinsho/git-conflict.nvim
--
-- 설명:
--   git merge/rebase 중 발생하는 충돌 마커(<<<<<<<, =======, >>>>>>>)와
--   OURS/THEIRS 영역을 각각 다른 배경색으로 강조한다.
--   명령으로 양쪽 중 하나, 양쪽 모두, 양쪽 모두 제거를 선택해
--   충돌을 빠르게 해결할 수 있다.
--
-- 사전준비:
--   - git 저장소 안에서 동작 (충돌이 있는 파일을 열면 자동 감지)
--
-- 사용법:
--   ]x / [x                    - 다음/이전 충돌로 이동 (플러그인 기본 키맵)
--   :GitConflictChooseOurs     - 현재 브랜치(ours) 변경 선택
--   :GitConflictChooseTheirs   - 들어오는 브랜치(theirs) 변경 선택
--   :GitConflictChooseBoth     - 양쪽 모두 선택
--   :GitConflictChooseNone     - 양쪽 모두 제거
--   :GitConflictListQf         - 모든 충돌을 quickfix 목록으로
--
-- 커스텀 단축키: 없음 (플러그인 기본 ]x / [x 사용, 해결은 명령어로)
-- ============================================================================

return {
	{
		"akinsho/git-conflict.nvim",
		version = "*",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			default_mappings = true,
			default_commands = true,
			disable_diagnostics = false,
			list_opener = "copen",
			highlights = {
				incoming = "DiffAdd",
				current = "DiffText",
			},
		},
	},
}

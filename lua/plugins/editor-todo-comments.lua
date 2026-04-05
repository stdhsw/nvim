-- ============================================================================
-- 파일명: editor-todo-comments.lua
--
-- 플러그인: folke/todo-comments.nvim
-- 저장소: https://github.com/folke/todo-comments.nvim
--
-- 설명:
--   코드 내 특수 키워드를 색상으로 하이라이팅하고,
--   telescope로 프로젝트 전체에서 검색할 수 있는 플러그인.
--   주석 내 키워드 뒤에 콜론(:)을 붙이면 자동으로 감지된다.
--   예) // TODO: 나중에 리팩토링, # FIXME: 버그 수정 필요
--
-- 지원 키워드:
--   TODO   - 노란색  (나중에 할 일)
--   FIXME  - 빨간색  (버그 수정 필요, FIX도 동일)
--   NOTE   - 파란색  (참고 사항, INFO도 동일)
--   HACK   - 주황색  (임시 방편 코드)
--   WARN   - 주황색  (주의 필요, WARNING도 동일)
--   PERF   - 보라색  (성능 개선 필요)
--   TEST   - 초록색  (테스트 관련)
--
-- 사용법:
--   :TodoTelescope              - 프로젝트 전체 TODO 목록 telescope로 검색
--   :TodoTelescope keywords=TODO,FIXME - 특정 키워드만 필터링
--   :TodoQuickFix               - TODO 목록을 quickfix 목록으로 표시
--   :TodoLocList                - TODO 목록을 location list로 표시
--
-- 커스텀 단축키 (config/keymaps.lua 참고):
--   ]t          - 다음 TODO로 이동
--   [t          - 이전 TODO로 이동
--   <leader>ft  - 프로젝트 전체 TODO 검색 (telescope)
-- ============================================================================

return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = { "BufReadPost", "BufNewFile" },
	opts = {}, -- 기본 설정으로 충분
}

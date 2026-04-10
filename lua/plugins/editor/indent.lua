-- ============================================================================
-- 파일명: editor/indent.lua
--
-- 플러그인: lukas-reineke/indent-blankline.nvim
-- 저장소: https://github.com/lukas-reineke/indent-blankline.nvim
--
-- 설명:
--   들여쓰기 레벨을 수직선(│)으로 시각화해주는 플러그인.
--   중첩된 YAML, K8s manifest, Python, Go 코드 등의 구조 파악에 유용하다.
--   커서가 위치한 현재 스코프(scope)를 다른 색상으로 강조 표시한다.
--   treesitter와 연동하여 언어의 블록 구조를 정확하게 인식한다.
--
--   활용 예시:
--   - K8s manifest: spec.template.spec.containers 중첩 구조 파악
--   - Python: 함수/클래스/조건문 들여쓰기 레벨 구분
--   - Go: if/for/switch 중첩 블록 시각화
--
-- 사용법:
--   별도 조작 없이 파일을 열면 자동으로 표시된다.
--
-- 커스텀 단축키:
--   없음
-- ============================================================================

return {
	"lukas-reineke/indent-blankline.nvim",
	event = { "BufReadPost", "BufNewFile" },
	main = "ibl", -- 플러그인의 메인 모듈명 (v3부터 ibl로 변경됨)
	opts = {
		indent = {
			char = "│", -- 들여쓰기 가이드 문자
		},
		scope = {
			enabled = true, -- 현재 커서가 위치한 스코프를 강조 표시
		},
	},
}

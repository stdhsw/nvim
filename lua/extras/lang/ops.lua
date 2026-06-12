-- ============================================================================
-- 파일명: extras/lang/ops.lua
--
-- 설명:
--   인프라/운영 관련 언어 지원 extra.
--   YAML, JSON, Bash, Dockerfile, SQL, Makefile을 한 파일에서 관리한다.
--
-- 포함 구성:
--   LSP       - yamlls (YAML + K8s 스키마), jsonls, bashls, dockerls
--   포매터    - prettier (yaml/json), shfmt (bash), sqlfluff (sql)
--   린터      - shellcheck (bash), hadolint (dockerfile)
--   파서      - yaml, json, bash, dockerfile, sql, make
--
-- 사전 요구사항:
--   brew install shfmt
--   pip install sqlfluff
--   prettier / shellcheck / hadolint 는 mason-tool-installer 가 자동 설치
-- ============================================================================

local util = require("extras.util")

return {
	-- Mason: LSP 서버 자동 설치 (yamlls=YAML/K8s, jsonls, bashls, dockerls)
	util.mason_lsp({ "yamlls", "jsonls", "bashls", "dockerls" }),

	-- LSP: 서버 활성화 + yamlls(YAML/Kubernetes 스키마 검증) 설정
	util.lsp({ "yamlls", "jsonls", "bashls", "dockerls" }, {
		yamlls = {
			settings = {
				yaml = {
					validate = true,
					schemaStore = {
						enable = true, -- 파일명/내용 기반 스키마 자동 감지
						url = "https://www.schemastore.org/api/json/catalog.json",
					},
					schemas = {
						-- K8s 스키마는 명시적 경로 패턴에만 적용
						kubernetes = {
							"k8s/**/*.yaml",
							"kubernetes/**/*.yaml",
							"manifests/**/*.yaml",
						},
					},
				},
			},
		},
	}),

	-- Treesitter: 파서 설치
	util.treesitter({ "yaml", "json", "bash", "dockerfile", "sql", "make" }),

	-- Conform: 포매터 등록 (yaml/json=prettier, sh=shfmt, sql=sqlfluff)
	util.formatters({
		yaml = { "prettier" },
		json = { "prettier" },
		sh = { "shfmt" },
		sql = { "sqlfluff" },
	}),

	-- nvim-lint: 린터 등록 (sh=shellcheck, dockerfile=hadolint)
	util.linters({
		sh = { "shellcheck" },
		dockerfile = { "hadolint" },
	}),

	-- mason-tool-installer: 포매터/린터 자동 설치 (mason-lspconfig 는 LSP 서버만 다루므로)
	--   prettier(YAML/JSON), shellcheck(Bash), hadolint(Dockerfile)
	util.mason_tools({ "prettier", "shellcheck", "hadolint" }),
}

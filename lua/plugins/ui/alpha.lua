-- ============================================================================
-- 파일명: ui/alpha.lua
--
-- 플러그인: goolord/alpha-nvim
-- 저장소: https://github.com/goolord/alpha-nvim
--
-- 설명:
--   nvim 시작 화면(대시보드) 플러그인.
--   맥북 환경에 맞춰 Apple 6색 무지개 로고, 시스템 정보, 빠른 메뉴를 표시한다.
--   마지막 버퍼를 닫을 때도 이 대시보드가 다시 표시된다 (bufferline/keymap 연동).
--
-- 구성:
--   1. 헤더   - Apple 무지개 로고 (녹색→노랑→주황→빨강→보라→파랑)
--   2. 시스템 - OS / Host / Kernel / Shell / CPU / Memory / Uptime
--   3. 푸터   - 플러그인 로드 수, startup 시간
--
-- 사용법:
--   - nvim 을 인자 없이 실행하면 자동 표시
--   - :Alpha        - 대시보드 수동 호출
-- ============================================================================

return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local alpha = require("alpha")

		-- Apple 공식 6색 팔레트
		local colors = {
			AppleGreen = "#61BB46",
			AppleYellow = "#FDB827",
			AppleOrange = "#F5821F",
			AppleRed = "#E03A3E",
			ApplePurple = "#963D97",
			AppleBlue = "#009DDC",
		}
		for name, hex in pairs(colors) do
			vim.api.nvim_set_hl(0, name, { fg = hex })
		end

		-- 로고 라인을 스트라이프별로 분리 (neofetch 스타일 Apple 로고)
		local stripes = {
			{ hl = "AppleGreen", lines = {
				"                  'c.",
				"               ,xNMM.",
				"             .OMMMMo",
				"             OMMM0,",
			} },
			{ hl = "AppleYellow", lines = {
				"   .;loddo:' loolloddol;.",
				" cKMMMMMMMMMMNWMMMMMMMMMM0:",
			} },
			{ hl = "AppleOrange", lines = {
				".KMMMMMMMMMMMMMMMMMMMMMMMWd.",
				"XMMMMMMMMMMMMMMMMMMMMMMMX.",
				"MMMMMMMMMMMMMMMMMMMMMMMM:",
			} },
			{ hl = "AppleRed", lines = {
				"MMMMMMMMMMMMMMMMMMMMMMMM:",
				".MMMMMMMMMMMMMMMMMMMMMMMMX.",
				" kMMMMMMMMMMMMMMMMMMMMMMMMWd.",
			} },
			{ hl = "ApplePurple", lines = {
				" .XMMMMMMMMMMMMMMMMMMMMMMMMMMk",
				"  .XMMMMMMMMMMMMMMMMMMMMMMMMK.",
				"    kMMMMMMMMMMMMMMMMMMMMMMd",
			} },
			{ hl = "AppleBlue", lines = {
				"     ;KMMMMMMMWXXWMMMMMMMk.",
				"       .cooc,.    .,coo:.",
			} },
		}

		local header_group = { type = "group", val = {} }
		for _, stripe in ipairs(stripes) do
			table.insert(header_group.val, {
				type = "text",
				val = stripe.lines,
				opts = { hl = stripe.hl, position = "center" },
			})
		end

		-- 시스템 정보 수집 (macOS)
		local function sh(cmd)
			return vim.trim(vim.fn.system(cmd) or "")
		end

		local function uptime_str()
			local bt = sh("sysctl -n kern.boottime")
			local sec = bt:match("sec = (%d+)")
			if not sec then
				return "unknown"
			end
			local elapsed = os.time() - tonumber(sec)
			local d = math.floor(elapsed / 86400)
			local h = math.floor((elapsed % 86400) / 3600)
			local m = math.floor((elapsed % 3600) / 60)
			return string.format("%dd %dh %dm", d, h, m)
		end

		local function sysinfo()
			local os_name = sh("sw_vers -productName") .. " " .. sh("sw_vers -productVersion")
			local mem_bytes = tonumber(sh("sysctl -n hw.memsize")) or 0
			local mem_gb = string.format("%.1fG", mem_bytes / 1024 / 1024 / 1024)
			return {
				"  OS      : " .. os_name,
				"  Host    : " .. sh("scutil --get ComputerName"),
				"  Kernel  : " .. sh("uname -r"),
				"  Shell   : " .. vim.fn.fnamemodify(os.getenv("SHELL") or "", ":t"),
				"  CPU     : " .. sh("sysctl -n machdep.cpu.brand_string"),
				"  Memory  : " .. mem_gb,
				"  Uptime  : " .. uptime_str(),
			}
		end

		local sysinfo_section = {
			type = "text",
			val = sysinfo(),
			opts = { hl = "Comment", position = "center" },
		}

		-- 푸터 (lazy 통계)
		local function footer()
			local ok, lazy = pcall(require, "lazy")
			if not ok then
				return ""
			end
			local stats = lazy.stats()
			local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
			return "⚡ " .. stats.loaded .. "/" .. stats.count .. " plugins loaded in " .. ms .. "ms"
		end

		local footer_section = {
			type = "text",
			val = footer,
			opts = { hl = "Comment", position = "center" },
		}

		-- 대시보드 전체를 세로 중앙에 배치하기 위한 상단 padding 계산
		-- 컨텐츠 총 높이 = 헤더(17) + 패딩(2) + 시스템(7) + 패딩(2) + 푸터(1) = 29
		local content_height = 29
		local top_padding = function()
			local win_height = vim.api.nvim_win_get_height(0)
			return math.max(0, math.floor((win_height - content_height) / 2))
		end

		alpha.setup({
			layout = {
				{ type = "padding", val = top_padding },
				header_group,
				{ type = "padding", val = 2 },
				sysinfo_section,
				{ type = "padding", val = 2 },
				footer_section,
			},
			opts = { margin = 5 },
		})

		-- 창 크기 변경 시 대시보드 재그리기 (세로 중앙 위치 재계산)
		vim.api.nvim_create_autocmd("VimResized", {
			pattern = "*",
			callback = function()
				if vim.bo.filetype == "alpha" then
					require("alpha").redraw()
				end
			end,
		})
	end,
}

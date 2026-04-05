-- ============================================================================
-- 파일명: editor-ufo.lua
--
-- 플러그인: kevinhwang91/nvim-ufo
-- 저장소: https://github.com/kevinhwang91/nvim-ufo
--
-- 설명:
--   LSP + treesitter 기반의 고성능 코드 폴딩 플러그인.
--   기본 vim 폴딩보다 정확하고, 접힌 줄 수와 미리보기를 제공한다.
--   LSP provider를 우선 시도하고 없으면 treesitter로 fallback한다.
--
-- 사용법:
--   za         - 현재 커서 위치의 fold 토글 (열기/닫기)
--   zo         - fold 열기
--   zc         - fold 닫기
--   zR         - 파일 내 모든 fold 열기
--   zM         - 파일 내 모든 fold 닫기
--   zr         - fold 레벨 한 단계 열기
--   zm         - fold 레벨 한 단계 닫기
--   <leader>zp - 접힌 블록 내용 미리보기 (peek)
--
-- 커스텀 단축키:
--   <leader>zp - fold peek (접힌 내용 팝업으로 미리보기)
-- ============================================================================

return {
	"kevinhwang91/nvim-ufo",
	dependencies = { "kevinhwang91/promise-async" },
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		require("ufo").setup({
			-- LSP → treesitter 순서로 provider 시도
			provider_selector = function(_, filetype, _)
				local lsp_ready = {
					go = true,
					python = true,
					yaml = true,
					json = true,
					bash = true,
					sh = true,
					dockerfile = true,
					lua = true,
				}
				if lsp_ready[filetype] then
					return { "lsp", "treesitter" }
				end
				return { "treesitter", "indent" }
			end,

			-- 접힌 줄에 표시할 미리보기 텍스트 (접힌 줄 수 + 첫 줄 내용)
			fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
				local newVirtText = {}
				local suffix = ("  %d줄 접힘"):format(endLnum - lnum)
				local sufWidth = vim.fn.strdisplaywidth(suffix)
				local targetWidth = width - sufWidth
				local curWidth = 0

				for _, chunk in ipairs(virtText) do
					local chunkText = chunk[1]
					local chunkWidth = vim.fn.strdisplaywidth(chunkText)
					if targetWidth > curWidth + chunkWidth then
						table.insert(newVirtText, chunk)
					else
						chunkText = truncate(chunkText, targetWidth - curWidth)
						table.insert(newVirtText, { chunkText, chunk[2] })
						chunkWidth = vim.fn.strdisplaywidth(chunkText)
						if curWidth + chunkWidth < targetWidth then
							suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
						end
						break
					end
					curWidth = curWidth + chunkWidth
				end

				table.insert(newVirtText, { suffix, "MoreMsg" })
				return newVirtText
			end,
		})
	end,
}

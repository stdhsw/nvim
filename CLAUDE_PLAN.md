# 구현 계획

## Phase 1: 기본 설정 ✅ 완료

| 파일 | 상태 |
|---|---|
| `init.lua` | ✅ 완료 |
| `lua/config/init.lua` | ✅ 완료 |
| `lua/config/options.lua` | ✅ 완료 |
| `lua/config/keymaps.lua` | ✅ 완료 |
| `lua/config/autocmds.lua` | ✅ 완료 |

## Phase 2: 플러그인 매니저 ✅ 완료

| 파일 | 상태 |
|---|---|
| `lua/config/lazy.lua` | ✅ 완료 |

## Phase 3: 플러그인 설정

| 순서 | 파일 | 플러그인 | 상태 |
|---|---|---|---|
| 1 | `lua/plugins/file-neo-tree.lua` | neo-tree, nvim-web-devicons, nui.nvim | ✅ 완료 |
| 2 | `lua/plugins/input-im-select.lua` | im-select.nvim | ✅ 완료 |
| 3 | `lua/plugins/ui-lualine.lua` | lualine | ✅ 완료 |
| 4 | `lua/plugins/ui-bufferline.lua` | bufferline | ✅ 완료 |
| 5 | `lua/plugins/ui-which-key.lua` | which-key | ✅ 완료 |
| 6 | `lua/plugins/editor-treesitter.lua` | treesitter | ✅ 완료 |
| 7 | `lua/plugins/search-telescope.lua` | telescope, telescope-fzf-native | ✅ 완료 |
| 8 | `lua/plugins/lsp-mason.lua` | mason, mason-lspconfig | ✅ 완료 |
| 9 | `lua/plugins/lsp-lspconfig.lua` | nvim-lspconfig | ✅ 완료 |
| 10 | `lua/plugins/lsp-cmp.lua` | nvim-cmp, LuaSnip, friendly-snippets | ✅ 완료 |
| 11 | `lua/plugins/lsp-conform.lua` | conform.nvim | ✅ 완료 |
| 12 | `lua/plugins/lsp-lint.lua` | nvim-lint | ✅ 완료 |
| 13 | `lua/plugins/editor-autopairs.lua` | nvim-autopairs | ✅ 완료 |
| 14 | `lua/plugins/editor-comment.lua` | Comment.nvim | ✅ 완료 |
| 15 | `lua/plugins/editor-indent.lua` | indent-blankline | ✅ 완료 |
| 16 | `lua/plugins/editor-todo-comments.lua` | todo-comments | ✅ 완료 |
| 17 | `lua/plugins/git-neogit.lua` | gitsigns, neogit, diffview | ✅ 완료 |
| 18 | `lua/plugins/lang-go.lua` | go.nvim, guihua.lua | ➖ 생략 |
| 19 | `lua/plugins/lang-yaml.lua` | yaml-companion | ➖ 생략 |
| 20 | `lua/plugins/ui-toggleterm.lua` | toggleterm | ✅ 완료 |
| 21 | `lua/plugins/ui-colorscheme.lua` | onedark (warmer), kanagawa (wave) | ✅ 완료 |
| 22 | `lua/plugins/editor-markdown-preview.lua` | markdown-preview.nvim | ➖ 생략 |
| 22-1 | `lua/plugins/editor-markdown-table.lua` | vim-table-mode | ✅ 완료 |
| 23 | `lua/plugins/debug-dap.lua` | nvim-dap, nvim-dap-ui, nvim-dap-go | ✅ 완료 |

## Phase 4: 블록 & 멀티커서

| 순서 | 파일 | 플러그인 | 상태 |
|---|---|---|---|
| 24 | `lua/plugins/editor-ufo.lua` | nvim-ufo, promise-async | ✅ 완료 |
| 25 | `lua/plugins/editor-multicursor.lua` | mg979/vim-visual-multi | ➖ 생략 |

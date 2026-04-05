# Neovim 설정 최적화 가이드

최적화가 필요한 항목과 그 이유를 정리한 문서입니다.

---

## 높은 우선순위

---

### 1. `config/autocmds.lua` — `CursorHold` 이벤트에서 `checktime` 제거

**현재 코드**
```lua
autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  command = "checktime",
})
```

**왜 문제인가**
`checktime`은 외부에서 파일이 변경되었는지 디스크를 확인하는 명령어입니다.
`CursorHold`는 커서가 `updatetime`(현재 250ms)만큼 움직이지 않으면 발생하는 이벤트입니다.
즉, 타이핑을 멈출 때마다 250ms 후 디스크 I/O가 발생합니다.

하루 종일 코딩하면 수천 번의 불필요한 디스크 접근이 발생하며, 배터리 소모와 I/O 대기가 누적됩니다.

**개선 방향**
`FocusGained` + `BufEnter`만으로도 외부 변경을 감지하기에 충분합니다.
실제로 파일이 외부에서 바뀌는 시점은 에디터 포커스가 돌아오는 순간이기 때문입니다.

---

### 2. `config/autocmds.lua` — 파일타입 들여쓰기 autocmd 통합

**현재 코드**
```lua
autocmd("FileType", { group = augroup("filetype_indent"), pattern = { "go", "makefile" }, ... })
autocmd("FileType", { group = augroup("filetype_indent_2"), pattern = { "yaml", "json", ... }, ... })
autocmd("FileType", { group = augroup("filetype_indent_4"), pattern = { "python" }, ... })
```

**왜 문제인가**
neovim은 파일을 열 때 `FileType` 이벤트를 발생시키며, 등록된 모든 autocmd를 순서대로 실행합니다.
현재 3개의 독립적인 autocmd가 등록되어 있어, 파일을 열 때마다 3번 패턴 매칭을 수행합니다.

파일 탐색이 잦거나 버퍼를 자주 열고 닫는 경우 불필요한 반복이 발생합니다.
또한 새로운 언어를 추가할 때마다 기존 그룹을 찾아서 패턴을 수정해야 하므로 관리도 불편합니다.

**개선 방향**
하나의 autocmd에서 filetype을 확인하고 분기 처리하면 패턴 매칭이 1회로 줄고, 언어 추가 시 테이블 한 곳만 수정하면 됩니다.

---

## 중간 우선순위

---

### 4. `config/keymaps.lua` — 단축키 실행 시 `require()` 캐싱

**현재 코드**
```lua
map("n", "]t", function()
  require("todo-comments").jump_next()
end, opts(...))

map("n", "]h", function()
  require("gitsigns").next_hunk()
end, opts(...))
```

**왜 문제인가**
lua의 `require()`는 최초 호출 시 모듈을 로드하고 `package.loaded` 테이블에 캐싱합니다.
두 번째 호출부터는 캐시에서 가져오므로 모듈 로드 비용은 없습니다.

그러나 `package.loaded`에서 테이블을 조회하는 해시 룩업 비용은 매 호출마다 발생합니다.
단축키를 빠르게 반복 입력하는 경우(예: `]h`로 hunk 탐색) 이 비용이 누적됩니다.

또한, 단축키 정의 시점에는 플러그인이 아직 로드되지 않은 상태일 수 있기 때문에 함수 안에 `require`를 감싸는 것은 맞는 패턴이지만, 변수에 한 번 캐싱하면 이후 호출 비용을 줄일 수 있습니다.

**개선 방향**
```lua
-- 첫 호출 시 캐싱하는 패턴
local _gitsigns
local function gitsigns()
  _gitsigns = _gitsigns or require("gitsigns")
  return _gitsigns
end

map("n", "]h", function() gitsigns().next_hunk() end, opts(...))
```

---

### 5. `plugins/lsp-lint.lua` — `event`와 `autocmd` 중복 이벤트 제거

**현재 코드**
```lua
{
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufWritePost" },
  config = function()
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
      callback = function() lint.try_lint() end,
    })
  end,
}
```

**왜 문제인가**
`event`는 lazy.nvim이 플러그인을 로드하는 시점을 결정합니다.
`BufReadPost`에서 플러그인이 로드되고, `config`가 실행되면서 다시 `BufReadPost` autocmd를 등록합니다.

문제는 플러그인이 로드된 직후 이미 `BufReadPost`가 발생한 상태이므로, 방금 열린 파일에 대해서는 autocmd가 즉시 실행되지 않습니다. 결국 첫 번째 파일은 린트가 실행되지 않을 수 있습니다.

또한 이벤트 이름이 두 곳에 분산되어 있어, 이벤트를 변경할 때 양쪽을 모두 수정해야 합니다.

**개선 방향**
`event = "VeryLazy"`로 변경하고 autocmd 안에서 이벤트를 명시적으로 관리합니다.
또는 `event`를 제거하고 `BufReadPost` autocmd 내에서 플러그인 로드와 린트 실행을 함께 처리합니다.

---

## 낮은 우선순위

---

### 7. `plugins/input-im-select.lua` — `lazy = false` 제거

**현재 코드**
```lua
{
  "keaising/im-select.nvim",
  lazy = false,
  config = function() ... end,
}
```

**왜 문제인가**
`lazy = false`는 neovim이 시작되는 즉시 플러그인을 로드합니다.
im-select는 입력 모드(Insert mode)에서만 의미가 있는 플러그인입니다.
Normal 모드에서 파일을 탐색하거나 git 작업을 하는 동안에는 전혀 사용되지 않습니다.

neovim을 열고 파일을 보기만 하거나 터미널에서 명령어를 실행할 때도 im-select가 로드되어 있는 상태입니다. 부팅 시간에 영향을 줍니다.

**개선 방향**
```lua
lazy = true,
event = "InsertEnter",
```
처음 Insert 모드에 진입할 때 로드해도 동작에 문제가 없습니다.

---

### 8. `plugins/debug-dap.lua` — `VeryLazy`를 키 기반 lazy loading으로 변경

**현재 코드**
```lua
{
  "mfussenegger/nvim-dap",
  event = "VeryLazy",
}
```

**왜 문제인가**
`VeryLazy`는 neovim UI가 완전히 렌더링된 직후 로드됩니다.
DAP는 디버깅을 시작할 때(`F5`)만 필요한 플러그인으로, 코딩 중에는 전혀 사용되지 않을 수 있습니다.

Go 코드 작성 중 DAP를 한 번도 사용하지 않는 세션에서도 DAP, DAP-UI, DAP-Go가 모두 메모리에 로드됩니다.

**개선 방향**
```lua
keys = { "<F5>", "<F7>", "<F8>", "<F9>", "<F10>", "<F11>", "<S-F5>", "<S-F11>", "<leader>dt" },
```
디버깅 관련 키를 처음 누를 때 로드하면, 디버깅을 사용하지 않는 세션에서는 메모리를 전혀 사용하지 않습니다.

---

## 작업 상태

| 번호 | 파일 | 항목 | 우선순위 | 완료 |
|---|---|---|---|---|
| 1 | `config/autocmds.lua` | CursorHold checktime 제거 | 높음 | ☑ |
| 2 | `config/autocmds.lua` | 들여쓰기 autocmd 통합 | 높음 | ☑ |
| 3 | `config/keymaps.lua` | require 캐싱 | 중간 | ☑ |
| 4 | `plugins/lsp-lint.lua` | event/autocmd 중복 제거 | 중간 | ☐ |
| 5 | `plugins/input-im-select.lua` | lazy = false 제거 | 낮음 | ☐ |
| 6 | `plugins/debug-dap.lua` | VeryLazy → keys lazy loading | 낮음 | ☐ |

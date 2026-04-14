# 한글 입력 시 자동완성 처리 방식

한글로 주석·문자열·문서를 작성할 때 `blink.cmp` 자동완성 팝업이
거슬릴 경우 선택할 수 있는 세 가지 방식 정리.

대상 파일: `lua/plugins/lsp/blink.lua`

---

## A. 파일타입/영역 혼합 (VSCode 경험에 가장 근접)

주석·문자열에서는 자동 팝업을 끄고, 일반 코드에서만 팝업을 띄운다.
추가로 한글 문자 뒤에서는 자동 비활성화한다.

### 특징
- **장점**: 코드에서는 평소대로 자동완성, 한글 작성 환경에서만 조용함.
  VSCode의 `editor.quickSuggestions` 설정과 가장 비슷한 경험.
- **단점**: 구현이 가장 복잡. treesitter로 현재 커서가
  주석/문자열 노드 안인지 판별해야 함.
- **적합한 경우**: 코드와 한글 문서 작성을 모두 많이 하고,
  각 상황에 맞는 최적 동작을 원할 때.

### 구현 개요
- `enabled = function()` 훅에서 treesitter 노드 타입 확인
- 한글 문자 판정 로직 포함

---

## B. 한글 감지 자동 비활성화 (단순)

커서 앞 문자가 한글이면 자동 팝업이 뜨지 않게 한다.

### 특징
- **장점**: 설정 한 번이면 끝. 전환 조작 없음.
  평소 코딩 흐름에 거의 영향 없음.
- **단점**: "한글 뒤 영문 입력" 경계에서 살짝 애매함
  (한글 직후 영문 2~3글자 동안 팝업이 안 뜰 수 있음).
  IME 상태를 직접 감지하는 게 아니라 버퍼 문자로 판정.
- **적합한 경우**: 주로 코드를 치고 한글은 주석·커밋 메시지 정도.

### 구현 개요
```lua
-- lua/plugins/lsp/blink.lua 의 opts 에 추가
enabled = function()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local before = line:sub(1, col)
  -- 마지막 문자가 한글 범위면 false
  local last = before:match("[^%s]$")
  if last and last:match("[가-힣ㄱ-ㅎㅏ-ㅣ]") then
    return false
  end
  return true
end,
```

---

## C. 수동 트리거 모드 (가장 단순)

자동 팝업을 전부 끄고, `<C-Space>` 등 원하는 키로 호출할 때만 팝업 표시.

### 특징
- **장점**: 구현이 가장 간단. 플래그 몇 개만 바꿈.
  한글/영문 구분 없이 완전히 일관된 동작. 예측 가능성 최고.
- **단점**: 기존 "타이핑하면 뜨는 팝업" 습관이 바뀜.
  긴 식별자·메서드 체이닝 시 수동 호출이 귀찮을 수 있음.
- **적합한 경우**: 눈에 띄는 팝업 자체가 거슬리고, 문서 작성 비중이 높음.

### 구현 개요
```lua
-- lua/plugins/lsp/blink.lua 의 opts.completion 에 추가
completion = {
  trigger = {
    show_on_keyword = false,
    show_on_trigger_character = false,
  },
  -- 기존 accept, documentation, menu 는 그대로
}
```

수동 호출 키는 blink.cmp 기본 `<C-Space>` 또는 keymap에서 추가 지정 가능.

---

## Neovim의 근본적 제약

VSCode는 Electron 기반이라 DOM의 IME composition 이벤트를 직접 받아
한글 조합 중 자동완성을 비개입시킬 수 있음. 터미널 Neovim은 OS 입력기가
자모를 확정해 버퍼에 넣은 후에야 문자를 받으므로, 이 방식을 그대로
구현할 수 없음. B·A 방식은 "이미 찍힌 문자"로 한글 여부를 판정하는
간접 방식임.

---

## 참고
- 현재 설정: `lua/plugins/lsp/blink.lua`
- 관련 플러그인: `keaising/im-select.nvim` (Normal 모드 진입 시 영문 IME 전환)

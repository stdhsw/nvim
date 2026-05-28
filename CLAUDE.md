# 응답 언어
- 모든 대화(응답, 질문)은 한국어로 진행한다.
- 커밋, commit은 ~/.claude/skills/git-commit/SKILL.md 를 참고한다.

# 환경 정보
- MacOS Tahoe
- neovim version 0.12
- Iterm2 터미널 환경

# 진입점 및 로드 순서
- 최상위: `init.lua` → `lua/config/init.lua`
- config 로드 순서: `options.lua` → `keymaps.lua` → `autocmds.lua` → `lazy.lua`
- leader 키: `<Space>`
- 플러그인은 `lua/plugins/<카테고리>/*.lua`, 언어별 설정은 `lua/extras/lang/*.lua`에 위치
- 새 플러그인 카테고리 추가 시 `lua/config/lazy.lua`에 `{ import = "plugins.<카테고리>" }` 라인 추가 필요

# 자주 쓰는 점검 명령 (nvim 내부)
- `:Lazy sync` — 플러그인 설치/업데이트
- `:Lazy reload <plugin>` — 특정 플러그인 재로드
- `:Mason` — LSP/포매터/린터 설치 상태 확인
- `:checkhealth` — 전반적인 환경 점검

# 파일 작성 규칙
- 모든 파일을 작성하거나 수정할 때 스크립트나 Python을 이용하여 수정하지 않는다.
- 파일을 수정할 때 사용자가 변경된 내용을 확인할 수 있도록 리눅스 명령어(sed, awk, echo 리다이렉션 등)를 통해 파일을 수정하지 않는다.
- lua 스크립트 파일은 언제나 검토를 받는다.
- neovim에 관련된 기본 옵션 설정은 lua/config/options.lua 파일에 작성한다.

## plugins 파일 작성 규칙
- 플러그인에 관련된 작업은 ./claude/plugins.md 파일의 규칙을 참고한다.
- 플러그인 구조를 설계할 경우 ./claude/struct.md 파일을 참고하고 업데이트한다.

## keymaps 파일 작성 규칙
- 모든 단축키에 대한 설정은 lua/config/keymaps.lua 파일에 작성한다.
- 플러그인 관련 단축키는 반드시 키맵 파일 하단에 기록한다.
- 키맵을 설정할 때 플러그인 별로 주석을 통해 구분한다.
- 플러그인 단축키 구분 주석은 라인 밑에 작성한다.
  ```
  -- ############################################################################
  -- [[ Plugins ]]
  -- ############################################################################
  ```

## README.md 파일 작성 규칙
- 현재 neovim을 사용하기 위한 사전 작업을 작성한다.
- 플러그인이 추가되거나 수정되었을때 플러그인에 대한 소개를 업데이트한다.



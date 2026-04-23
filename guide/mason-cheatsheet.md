# Mason 치트시트

Mason 은 LSP 서버, DAP 어댑터, 린터, 포매터 같은 외부 도구를
Neovim 안에서 통합 관리하는 패키지 매니저이다.

---

## 진입 명령

| 명령              | 설명                                          |
|-------------------|-----------------------------------------------|
| `:Mason`          | Mason UI 열기 (전체 패키지 탐색 / 설치 / 제거) |
| `:MasonUpdate`    | Mason 레지스트리 갱신                          |
| `:MasonLog`       | 설치 로그 확인 (설치 실패 시 확인)             |

---

## Mason UI 단축키

`:Mason` 으로 진입한 창 안에서 사용한다.

| 키       | 동작                                       |
|----------|--------------------------------------------|
| `i`      | 커서 위치 패키지 **설치 (Install)**         |
| `u`      | 커서 위치 패키지 **업데이트 (Update)**      |
| `U`      | 모든 패키지 일괄 업데이트                   |
| `X`      | 커서 위치 패키지 **제거 (Uninstall)**       |
| `<CR>`   | 패키지 상세 정보 토글 (homepage / 버전 등)  |
| `g?`     | 도움말 표시                                 |
| `/`      | 패키지 이름 검색                            |
| `1`      | 모든 패키지 탭                              |
| `2`      | LSP (Language Server) 탭                    |
| `3`      | DAP (Debug Adapter) 탭                      |
| `4`      | Linter 탭                                   |
| `5`      | Formatter 탭                                |
| `q`      | Mason UI 닫기                               |

---

## Ex 명령어로 직접 설치 / 제거

| 명령                          | 설명                                 |
|-------------------------------|--------------------------------------|
| `:MasonInstall <패키지명>`    | 특정 패키지 설치                      |
| `:MasonUninstall <패키지명>`  | 특정 패키지 제거                      |
| `:MasonUninstallAll`          | 모든 Mason 설치 패키지 제거           |

예시:
```
:MasonInstall pyright
:MasonInstall debugpy black isort
```

---

## 자동 설치 (mason-tool-installer)

이 설정은 `mason-tool-installer.nvim` 으로 아래 도구를 nvim 시작 시 자동 설치한다.
설정 위치: `lua/extras/lang/*.lua` 의 각 언어 파일

### 자동 설치 도구 목록

| 분류        | 패키지                                     | 추가 위치                  |
|-------------|--------------------------------------------|----------------------------|
| LSP         | `lua_ls`, `gopls`, `pyright`               | extras/lang/{lua,go,python}.lua |
| Formatter   | `stylua`, `prettier`, `black`, `isort`     | extras/lang/{lua,ops,python}.lua |
| Linter      | `shellcheck`, `hadolint`                   | extras/lang/ops.lua        |
| DAP         | `debugpy`                                  | extras/lang/python.lua     |
| Go 도구     | `gomodifytags`                             | extras/lang/go.lua         |

### 자동 설치 관련 명령

| 명령                  | 설명                                          |
|-----------------------|-----------------------------------------------|
| `:MasonToolsInstall`  | `ensure_installed` 목록 즉시 설치 (수동 트리거) |
| `:MasonToolsUpdate`   | `ensure_installed` 목록 일괄 업데이트          |
| `:MasonToolsClean`    | `ensure_installed` 에 없는 도구 제거           |

> 새 언어 extra 를 추가하면 nvim 재시작만 해도 필요한 도구가 설치된다.
> 즉시 설치하려면 `:MasonToolsInstall` 을 실행한다.

---

## 설치 경로

Mason 으로 설치된 모든 패키지는 다음 위치에 저장된다.

```
~/.local/share/nvim/mason/
├── bin/        ← 실행 파일 (PATH 에 자동 추가됨)
├── packages/   ← 패키지별 설치 디렉토리
└── share/      ← 공유 리소스
```

특정 패키지의 실제 경로 예시:
```
~/.local/share/nvim/mason/packages/debugpy/venv/bin/python
~/.local/share/nvim/mason/packages/pyright/
```

---

## 트러블슈팅

| 증상                              | 확인 방법                                              |
|-----------------------------------|--------------------------------------------------------|
| 설치가 실패함                     | `:MasonLog` 로 로그 확인                                |
| 설치된 LSP 가 동작하지 않음       | `:LspInfo` 로 서버 attach 상태 확인                    |
| 자동 설치가 안 됨                 | `:MasonToolsInstall` 수동 실행                         |
| 패키지가 보이지 않음              | `:MasonUpdate` 로 레지스트리 갱신                      |
| 외부 의존성 부족 (예: node, npm)  | Mason 패키지 상세 (`<CR>`) 의 requirements 확인         |

---

## 관련 단축키

| 단축키       | 설명                                          |
|--------------|-----------------------------------------------|
| `<leader>kp` | 플러그인 사용법 치트시트 (LSP/DAP 키맵 포함)  |
| `<leader>km` | Mason 치트시트 (이 문서)                       |

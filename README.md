# Common Harness

## 概要

`Common_harness` は、Claude Code / Cursor / AI Agent で複数の開発プロジェクトを扱うための共通 Harness テンプレート集です。

目的は、各プロジェクトに対して以下を共通化することです。

- AI Agent に守らせる基本ルール
- Claude Code 用の設定
- Cursor 用の設定
- プロジェクト固有情報の整理
- 危険操作や秘密情報へのアクセス制限
- 各プロジェクトへの Harness 配置手順

テンプレートファイルの具体的な中身は、`templates/` 配下で管理します。

---

## ディレクトリ構成

```txt
Common_harness/
├─ README.md
├─ .gitignore
├─ templates/
│  ├─ AGENTS.md
│  ├─ CLAUDE.md
│  ├─ PROJECT_CONTEXT.md
│  ├─ .claude/
│  │  └─ settings.json
│  ├─ .cursorignore
│  └─ .cursor/
│     └─ rules/
│        └─ project-rule.mdc
└─ scripts/
   └─ install-harness.ps1
```

---

## 各ファイルの役割

| ファイル | 役割 |
|---|---|
| `templates/AGENTS.md` | AI Agent 共通の作業ルール |
| `templates/CLAUDE.md` | Claude Code 専用ルール |
| `templates/PROJECT_CONTEXT.md` | 各プロジェクト固有の説明テンプレート |
| `templates/.claude/settings.json` | Claude Code の権限設定 |
| `templates/.cursorignore` | Cursor に読み込ませないファイルの指定 |
| `templates/.cursor/rules/project-rule.mdc` | Cursor 用のプロジェクトルール |
| `scripts/install-harness.ps1` | Harness を各プロジェクトへ配置するスクリプト |

---

## 基本方針

`Common_harness` は、直接開発作業を行うプロジェクトではなく、共通テンプレート置き場として扱います。

実際の作業対象は、各プロジェクトのルートフォルダです。

例：

```txt
<YOUR_WORKSPACE>\Aws_handson_portfolio\01_Project_a1\snake_game_demo_dynamoDB
```

各プロジェクトには、`Common_harness/templates` から必要な Harness ファイルをコピーして使います。

---

## 配置後のプロジェクト構成例

```txt
snake_game_demo_dynamoDB/
├─ AGENTS.md
├─ CLAUDE.md
├─ PROJECT_CONTEXT.md
├─ .claude/
│  └─ settings.json
├─ .cursorignore
└─ .cursor/
   └─ rules/
      └─ project-rule.mdc
```

---

## 初回セットアップ

`Common_harness` に移動します。

```powershell
cd <YOUR_WORKSPACE>\Aws_handson_portfolio\Common_harness
```

必要なフォルダを作成します。

```powershell
New-Item -ItemType Directory -Force -Path templates
New-Item -ItemType Directory -Force -Path templates\.claude
New-Item -ItemType Directory -Force -Path templates\.cursor\rules
New-Item -ItemType Directory -Force -Path scripts
```

必要なファイルを作成します。

```powershell
New-Item -ItemType File -Force -Path templates\AGENTS.md
New-Item -ItemType File -Force -Path templates\CLAUDE.md
New-Item -ItemType File -Force -Path templates\PROJECT_CONTEXT.md
New-Item -ItemType File -Force -Path templates\.claude\settings.json
New-Item -ItemType File -Force -Path templates\.cursorignore
New-Item -ItemType File -Force -Path templates\.cursor\rules\project-rule.mdc
New-Item -ItemType File -Force -Path scripts\install-harness.ps1
New-Item -ItemType File -Force -Path .gitignore
```

---

## Harness の配置方法

通常の Harness を対象プロジェクトへ配置します。

```powershell
powershell -ExecutionPolicy Bypass -File <YOUR_WORKSPACE>\Aws_handson_portfolio\Common_harness\scripts\install-harness.ps1 -TargetProjectPath <YOUR_WORKSPACE>\Aws_handson_portfolio\01_Project_a1\snake_game_demo_dynamoDB
```

Cursor rules も配置する場合：

```powershell
powershell -ExecutionPolicy Bypass -File <YOUR_WORKSPACE>\Aws_handson_portfolio\Common_harness\scripts\install-harness.ps1 -TargetProjectPath <YOUR_WORKSPACE>\Aws_handson_portfolio\01_Project_a1\snake_game_demo_dynamoDB -InstallCursorRules
```

共通 skills も配置する場合：

```powershell
powershell -ExecutionPolicy Bypass -File <YOUR_WORKSPACE>\Aws_handson_portfolio\Common_harness\scripts\install-harness.ps1 -TargetProjectPath <YOUR_WORKSPACE>\Aws_handson_portfolio\01_Project_a1\snake_game_demo_dynamoDB -InstallSkills
```

`PROJECT_CONTEXT.md` を強制的に上書きする場合：

```powershell
powershell -ExecutionPolicy Bypass -File <YOUR_WORKSPACE>\Aws_handson_portfolio\Common_harness\scripts\install-harness.ps1 -TargetProjectPath <YOUR_WORKSPACE>\Aws_handson_portfolio\01_Project_a1\snake_game_demo_dynamoDB -OverwriteProjectContext
```

---

## `.claude/skills` が既にある場合

既存プロジェクトに `.claude/skills` がある場合、`.claude` フォルダ全体を上書きコピーしない方針です。

推奨方針：

- `.claude/settings.json` のみコピーする
- 既存の `.claude/skills` は基本的に触らない
- 共通 skills を入れる場合だけ `-InstallSkills` を使う
- 同名 skill が存在する場合は上書きせずスキップする

---

## PROJECT_CONTEXT.md の運用

`PROJECT_CONTEXT.md` は、各プロジェクトごとに編集するファイルです。

記載する内容の例：

- プロジェクト名
- プロジェクト目的
- 技術スタック
- 起動コマンド
- ビルドコマンド
- テストコマンド
- AWS 構成
- 注意事項
- 今後追加したい機能

共通ルールは `AGENTS.md` / `CLAUDE.md` にまとめ、プロジェクト固有情報は `PROJECT_CONTEXT.md` に分離します。

---

## GitHub にアップロードしないもの

以下は GitHub に含めないでください。

```txt
.env
.env.*
*.pem
*.key
secrets/
credentials/
AWS access key
AWS secret access key
AWS session token
API key
token
password
```

`.cursorignore` は Cursor 用の除外設定です。  
Git の追跡対象から除外するには、別途 `.gitignore` を使用します。

---

## 秘密情報チェック

GitHub に push する前に、秘密情報が含まれていないか確認します。

```powershell
$secretPattern = 'AKIA[0-9A-Z]{16}|aws_secret_access_key\s*=|aws_access_key_id\s*=|BEGIN (RSA |OPENSSH |EC )?PRIVATE KEY|ghp_[A-Za-z0-9_]{36}|xox[baprs]-[A-Za-z0-9-]+'

Get-ChildItem -Recurse -File -Force |
Where-Object { $_.FullName -notmatch '\\\.git\\' } |
Select-String -Pattern $secretPattern
```

`.env` や秘密鍵系ファイルの確認：

```powershell
Get-ChildItem -Recurse -Force |
Where-Object {
    $_.Name -like ".env*" -or
    $_.Name -like "*.pem" -or
    $_.Name -like "*.key" -or
    $_.FullName -match "\\(secrets|credentials)\\"
}
```

何も表示されなければ、基本的には問題ありません。

---

## GitHub へのアップロード手順

Git 管理を開始します。

```powershell
git init -b main
```

初期コミットを作成します。

```powershell
git add .
git commit -m "Add common AI harness templates"
```

GitHub CLI でリポジトリを作成します。

```powershell
gh auth login
gh repo create common-harness --private --source=. --remote=origin
```

公開リポジトリにする場合：

```powershell
gh repo create common-harness --public --source=. --remote=origin
```

push します。

```powershell
git push -u origin main
```

---

## PR を作成する場合

作業ブランチを作成します。

```powershell
git switch -c feature/add-common-harness
```

変更をコミットします。

```powershell
git add .
git commit -m "Add common AI harness templates"
```

ブランチを push します。

```powershell
git push -u origin feature/add-common-harness
```

PR を作成します。

```powershell
gh pr create `
  --base main `
  --head feature/add-common-harness `
  --title "Add common AI harness templates" `
  --body "Claude Code / Cursor / AI Agent 向けの共通 Harness テンプレート、設定ファイル、インストールスクリプト、README を追加します。"
```

---

## AI Agent に最初に依頼する内容

Harness 配置後、Claude Code / Cursor には最初に次のように依頼します。

```txt
まず AGENTS.md、CLAUDE.md、PROJECT_CONTEXT.md を読んで、このプロジェクトのルールを理解してください。

そのうえで、現在のプロジェクト構成を確認し、
このプロジェクトがどの技術スタックで作られているか、
どのコマンドで起動・ビルド・テストできそうかを整理してください。

まだコード修正はしないでください。
```

---

## 運用ルールまとめ

- `Common_harness` は共通テンプレート置き場として使う
- 各プロジェクトには必要な Harness ファイルをコピーして使う
- `PROJECT_CONTEXT.md` は各プロジェクトごとに編集する
- `.claude/skills` は基本的に上書きしない
- Cursor rules は必要な場合だけ配置する
- GitHub に secrets / credentials / `.env` は含めない
- push 前に秘密情報チェックを行う

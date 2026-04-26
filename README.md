# 🛠️ Common Harness

**[日本語](#-日本語)** · **[English](#-english)** · **[中文](#-中文)**

---

<a id="-日本語"></a>

# 🛠️ Common Harness（日本語）

> AI Agent（Claude Code / Cursor）を複数の開発プロジェクトで安全・効率的に使うための、共通テンプレート集です。

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Platform: Windows](https://img.shields.io/badge/Platform-Windows%20%28PowerShell%29-blue)
![Status: Stable](https://img.shields.io/badge/Status-Stable-green)

> **言語 / Language / 语言：**
> **[日本語](#-日本語)** · [English](#-english) · [中文](#-中文)

---

## 📌 概要

`Common Harness` は、Claude Code / Cursor / AI Agent で複数の開発プロジェクトを扱うための共通テンプレート集です。

**こんな課題を解決します：**

- プロジェクトごとに AI Agent のルールを毎回書き直している
- AI Agent が勝手にファイルを削除・変更して困った経験がある
- `.env` や AWS キーを誤って Git に push してしまいそうで不安
- 本番 / ステージング / 開発 の環境を AI Agent に誤操作されたくない

**このリポジトリが提供するもの：**

| 提供物 | 内容 |
|---|---|
| AI Agent ルールテンプレート | 禁止操作・確認義務・作業手順を統一 |
| Claude Code 設定テンプレート | 権限・スコープを最小化した安全な設定 |
| Cursor ルールテンプレート | プロジェクトルールをすぐ適用できる雛形 |
| インストールスクリプト | 各プロジェクトへ Harness を自動配置 |
| 秘密情報チェック | push 前のリークスキャンコマンド |

---

## 🗂️ ディレクトリ構成

```txt
Common_harness/
├─ README.md
├─ CHANGELOG.md
├─ LICENSE
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

## 🚀 クイックスタート

### 前提条件

| 要件 | バージョン |
|---|---|
| OS | Windows 10 / 11 |
| PowerShell | 5.1 以上（推奨：7.x） |
| Claude Code | 最新版 |
| Cursor | 最新版（任意） |
| Git | 任意（GitHub 連携する場合） |
| GitHub CLI (`gh`) | 任意（リポジトリ作成する場合） |

> ⚠️ 現在 **Windows / PowerShell 専用**です。Mac / Linux 向け bash スクリプトは未対応です（コントリビュート歓迎）。

### STEP 1：このリポジトリをクローン

```powershell
git clone https://github.com/<YOUR_USERNAME>/common-harness.git
cd common-harness
```

クローン後は `templates/` 配下にすべてのテンプレートファイルが揃っています。**ファイルを手動で作成する必要はありません。**

### STEP 2：各プロジェクトへ Harness を配置

```powershell
# 基本配置（AGENTS.md / CLAUDE.md / .claude/settings.json / .cursorignore をコピー）
powershell -ExecutionPolicy Bypass -File .\scripts\install-harness.ps1 `
  -TargetProjectPath <YOUR_WORKSPACE>\your-project

# Cursor rules も配置する場合
powershell -ExecutionPolicy Bypass -File .\scripts\install-harness.ps1 `
  -TargetProjectPath <YOUR_WORKSPACE>\your-project `
  -InstallCursorRules

# 共通 skills も配置する場合
powershell -ExecutionPolicy Bypass -File .\scripts\install-harness.ps1 `
  -TargetProjectPath <YOUR_WORKSPACE>\your-project `
  -InstallSkills

# PROJECT_CONTEXT.md を強制上書きする場合
powershell -ExecutionPolicy Bypass -File .\scripts\install-harness.ps1 `
  -TargetProjectPath <YOUR_WORKSPACE>\your-project `
  -OverwriteProjectContext
```

### STEP 3：PROJECT_CONTEXT.md を編集する

配置後、対象プロジェクト内の `PROJECT_CONTEXT.md` を開き、プロジェクト名・技術スタック・コマンド・AWS 構成などを記入してください。

---

## 📄 各テンプレートの内容ガイド

### AGENTS.md（AI Agent 共通ルール）

```markdown
## 回答ルール
- 回答・説明は日本語で行うこと
- 依頼内容に必要な最小限の修正だけを行うこと

## セキュリティルール
- .env / *.pem / *.key / AWS 認証情報は読まない・変更しない

## 禁止操作（事前確認なしに実行しないこと）
- npm install / pip install 等の依存追加
- DB の削除・DROP / git push / rm -rf
- 本番環境（prd）へのデプロイ

## 推奨作業フロー
1. PROJECT_CONTEXT.md を確認する
2. 変更方針をユーザーに説明する
3. 承認後に最小限の修正を行う
4. 確認コマンドを実行して結果を報告する
```

### CLAUDE.md（Claude Code 専用ルール）

```markdown
## 最初に確認するファイル
1. AGENTS.md → 2. PROJECT_CONTEXT.md → 3. エントリーポイント → 4. 関連ソース

## Claude Code 作業ルール
- 変更前に作業計画を提示すること
- 新規依存パッケージは必ず事前確認すること

## AWS 関連の注意
- DynamoDB / Lambda / IAM / デプロイ設定は事前確認なしに変更しない

## 作業完了時の報告形式
- 変更したファイル / 変更内容 / 変更理由 / 確認コマンドと結果 / 懸念点
```

### PROJECT_CONTEXT.md（プロジェクト固有情報）

```markdown
## プロジェクト名 / 目的 / 技術スタック
## 環境情報
  | 環境 | 説明             | AI Agent の直接操作 |
  | dev  | ローカル開発環境 | 許可                |
  | stg  | ステージング環境 | 要確認              |
  | prd  | 本番環境         | 禁止                |
## コマンド / AWS 構成 / 注意事項
```

### .claude/settings.json（Claude Code 権限設定）

```json
{
  "permissions": {
    "allow": [
      "Bash(npm run lint)", "Bash(npm run lint:fix)", "Bash(npm test)",
      "Bash(npm run build)", "Bash(npm run dev)",
      "Bash(git diff)", "Bash(git diff --staged)", "Bash(git status)",
      "Bash(git log --oneline *)", "Bash(cat *)", "Bash(ls *)", "Bash(echo *)"
    ],
    "deny": [
      "Read(.env)", "Read(.env.*)", "Read(secrets/**)", "Read(credentials/**)",
      "Read(*.pem)", "Read(*.key)",
      "Bash(rm -rf *)", "Bash(git push *)", "Bash(git reset --hard *)",
      "Bash(git clean -fd *)", "Bash(aws dynamodb delete-table *)",
      "Bash(aws dynamodb update-table *)", "Bash(aws iam *)",
      "Bash(aws s3 rb *)", "Bash(terraform destroy *)", "Bash(kubectl delete *)"
    ]
  }
}
```

---

## ⚙️ install-harness.ps1 動作仕様

| 処理対象 | デフォルト動作 | オプション |
|---|---|---|
| `AGENTS.md` | 常に上書きコピー | — |
| `CLAUDE.md` | 常に上書きコピー | — |
| `.claude/settings.json` | 常に上書きコピー | — |
| `.cursorignore` | 常に上書きコピー | — |
| `PROJECT_CONTEXT.md` | **初回のみ（既存はスキップ）** | `-OverwriteProjectContext` で強制上書き |
| `.cursor/rules/project-rule.mdc` | スキップ | `-InstallCursorRules` で配置 |
| `.claude/skills/` | スキップ | `-InstallSkills` で追加（同名スキップ） |

> ⚠️ `.claude/` フォルダ全体は上書きしません。`settings.json` のみをコピーし、既存の `.claude/skills/` を保護します。

**冪等性：** 何度実行しても安全です（PROJECT_CONTEXT.md を除く）。  
**エラー時：** 失敗したファイルをスキップして処理を継続します。

---

## 🔄 テンプレート更新時の対応

| ファイル | 反映方法 |
|---|---|
| `AGENTS.md` / `CLAUDE.md` / `settings.json` / `.cursorignore` | `install-harness.ps1` を再実行（自動上書き） |
| `PROJECT_CONTEXT.md` | 各プロジェクトを手動編集 |
| `.cursor/rules/project-rule.mdc` | `-InstallCursorRules` を付けて再実行 |

---

## 🏭 本番プロジェクトでの追加推奨事項

**環境別の権限分離：**

```json
"deny": [
  "Bash(aws * --profile prd*)",
  "Bash(kubectl * --context prd*)",
  "Bash(terraform apply * -var-file=prd*)"
]
```

**pre-commit hook による自動スキャン：**

```powershell
$secretPattern = 'AKIA[0-9A-Z]{16}|aws_secret_access_key\s*=|aws_access_key_id\s*=|BEGIN (RSA |OPENSSH |EC )?PRIVATE KEY|ghp_[A-Za-z0-9_]{36}|xox[baprs]-[A-Za-z0-9-]+'
$found = Get-ChildItem -Recurse -File -Force |
  Where-Object { $_.FullName -notmatch '\\\.git\\' } |
  Select-String -Pattern $secretPattern
if ($found) {
  Write-Host "❌ 秘密情報が検出されました。コミットを中断します。" -ForegroundColor Red
  $found | ForEach-Object { Write-Host $_.Filename }
  exit 1
}
```

**ブランチ保護ルール（GitHub）：** `main` への直接 push 禁止 / PR レビュー必須 / ステータスチェック必須

---

## 🔐 GitHub にアップロードしてはいけないもの

`.env` / `.env.*` / `*.pem` / `*.key` / `secrets/` / `credentials/`  
AWS キー / GitHub Token(`ghp_`) / Slack Token(`xox`) / DB パスワード / API Key

---

## 🔍 push 前の秘密情報チェック

```powershell
$secretPattern = 'AKIA[0-9A-Z]{16}|aws_secret_access_key\s*=|aws_access_key_id\s*=|BEGIN (RSA |OPENSSH |EC )?PRIVATE KEY|ghp_[A-Za-z0-9_]{36}|xox[baprs]-[A-Za-z0-9-]+'
Get-ChildItem -Recurse -File -Force |
  Where-Object { $_.FullName -notmatch '\\\.git\\' } |
  Select-String -Pattern $secretPattern
```

---

## 📦 GitHub へのアップロード手順

```powershell
git init -b main
git add .
git commit -m "feat: add common AI harness templates"
gh auth login
gh repo create common-harness --public --source=. --remote=origin
git push -u origin main
```

---

## 🤖 AI Agent への初回指示

```txt
まず AGENTS.md、CLAUDE.md、PROJECT_CONTEXT.md を順番に読んで、
このプロジェクトのルールと構成を理解してください。
技術スタック・コマンド・作業禁止対象を整理して報告してください。
まだコードの修正・ファイルの作成・コマンドの実行はしないでください。
```

---

## 🤝 コントリビュート

Issue や PR は歓迎です！ → [Issues](https://github.com/<YOUR_USERNAME>/common-harness/issues)  
Mac / Linux 向け bash スクリプト追加 / テンプレート改善 / 多言語対応

## 📝 ライセンス

[MIT License](LICENSE) · 自由に使用・改変・再配布できます。商用利用も可能です。

## 🗒️ CHANGELOG

[CHANGELOG.md](CHANGELOG.md) を参照してください。

---

---

<a id="-english"></a>

# 🛠️ Common Harness (English)

> A shared template collection for safely and efficiently managing multiple development projects with AI Agents (Claude Code / Cursor).

> **Language / 言語 / 语言：**
> [日本語](#-日本語) · **[English](#-english)** · [中文](#-中文)

---

## 📌 Overview

`Common Harness` is a shared template collection for working with Claude Code / Cursor / AI Agents across multiple development projects.

**Problems it solves:**

- Rewriting AI Agent rules from scratch for every project
- AI Agents unexpectedly deleting or modifying files
- Accidentally pushing `.env` files or AWS keys to GitHub
- AI Agents mistakenly operating on production / staging environments

**What this repository provides:**

| Item | Description |
|---|---|
| AI Agent rule templates | Standardize prohibited operations, confirmation requirements, and workflows |
| Claude Code config template | Minimal-permission settings to reduce risk |
| Cursor rule template | Ready-to-use project rules for Cursor |
| Install script | Automatically deploy Harness files to each project |
| Secret leak checker | Commands to scan for secrets before pushing |

---

## 🗂️ Directory Structure

```txt
Common_harness/
├─ README.md
├─ CHANGELOG.md
├─ LICENSE
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

## 🚀 Quick Start

### Prerequisites

| Requirement | Version |
|---|---|
| OS | Windows 10 / 11 |
| PowerShell | 5.1 or later (7.x recommended) |
| Claude Code | Latest |
| Cursor | Latest (optional) |
| Git | Optional (for GitHub integration) |
| GitHub CLI (`gh`) | Optional (for repo creation) |

> ⚠️ Currently **Windows / PowerShell only**. Bash scripts for Mac / Linux are not yet available (contributions welcome).

### STEP 1: Clone this repository

```powershell
git clone https://github.com/<YOUR_USERNAME>/common-harness.git
cd common-harness
```

All template files are already present under `templates/` after cloning. **No need to create files manually.**

### STEP 2: Deploy Harness to your project

```powershell
# Basic deploy
powershell -ExecutionPolicy Bypass -File .\scripts\install-harness.ps1 `
  -TargetProjectPath <YOUR_WORKSPACE>\your-project

# Also install Cursor rules
powershell -ExecutionPolicy Bypass -File .\scripts\install-harness.ps1 `
  -TargetProjectPath <YOUR_WORKSPACE>\your-project -InstallCursorRules

# Also install shared skills
powershell -ExecutionPolicy Bypass -File .\scripts\install-harness.ps1 `
  -TargetProjectPath <YOUR_WORKSPACE>\your-project -InstallSkills

# Force overwrite PROJECT_CONTEXT.md
powershell -ExecutionPolicy Bypass -File .\scripts\install-harness.ps1 `
  -TargetProjectPath <YOUR_WORKSPACE>\your-project -OverwriteProjectContext
```

### STEP 3: Edit PROJECT_CONTEXT.md

Open `PROJECT_CONTEXT.md` in the target project and fill in the project name, tech stack, commands, AWS configuration, etc.

---

## 📄 Template Contents Guide

### AGENTS.md

```markdown
## Response Rules
- Always respond and explain in Japanese
- Make only the minimum changes required

## Security Rules
- Never read, output, or modify .env / *.pem / *.key / AWS credentials

## Prohibited Operations (require user confirmation)
- Adding dependencies / DB deletion / git push / rm -rf
- Deploying to production (prd)

## Recommended Workflow
1. Read PROJECT_CONTEXT.md
2. Explain the plan to the user
3. Implement minimum changes after approval
4. Run verification commands and report results
```

### CLAUDE.md

```markdown
## Files to Check First
1. AGENTS.md → 2. PROJECT_CONTEXT.md → 3. Entry point → 4. Related source

## Work Rules
- Present a work plan before making changes
- Always confirm before adding new dependencies

## AWS Precautions
- Do not modify DynamoDB / Lambda / IAM / deploy configs without confirmation
```

### .claude/settings.json

```json
{
  "permissions": {
    "allow": [
      "Bash(npm run lint)", "Bash(npm run lint:fix)", "Bash(npm test)",
      "Bash(npm run build)", "Bash(npm run dev)",
      "Bash(git diff)", "Bash(git diff --staged)", "Bash(git status)",
      "Bash(git log --oneline *)", "Bash(cat *)", "Bash(ls *)", "Bash(echo *)"
    ],
    "deny": [
      "Read(.env)", "Read(.env.*)", "Read(secrets/**)", "Read(credentials/**)",
      "Read(*.pem)", "Read(*.key)",
      "Bash(rm -rf *)", "Bash(git push *)", "Bash(git reset --hard *)",
      "Bash(git clean -fd *)", "Bash(aws dynamodb delete-table *)",
      "Bash(aws dynamodb update-table *)", "Bash(aws iam *)",
      "Bash(aws s3 rb *)", "Bash(terraform destroy *)", "Bash(kubectl delete *)"
    ]
  }
}
```

---

## ⚙️ install-harness.ps1 Behavior

| Target | Default | Option |
|---|---|---|
| `AGENTS.md` | Always overwrite | — |
| `CLAUDE.md` | Always overwrite | — |
| `.claude/settings.json` | Always overwrite | — |
| `.cursorignore` | Always overwrite | — |
| `PROJECT_CONTEXT.md` | **First-time only (skip if exists)** | `-OverwriteProjectContext` |
| `.cursor/rules/project-rule.mdc` | Skip | `-InstallCursorRules` |
| `.claude/skills/` | Skip | `-InstallSkills` (skip on conflict) |

**Idempotent:** Safe to run multiple times (except PROJECT_CONTEXT.md).

---

## 🏭 Production Project Recommendations

**Permission isolation:**
```json
"deny": [
  "Bash(aws * --profile prd*)",
  "Bash(kubectl * --context prd*)",
  "Bash(terraform apply * -var-file=prd*)"
]
```

**Branch protection (GitHub):** Prohibit direct push to `main` / Require PR review / Require status checks.

---

## 🔐 Never Push to GitHub

`.env` / `.env.*` / `*.pem` / `*.key` / `secrets/` / `credentials/`  
AWS keys / GitHub Token (`ghp_`) / Slack Token (`xox`) / DB passwords / API Keys

---

## 🔍 Pre-Push Secret Check

```powershell
$secretPattern = 'AKIA[0-9A-Z]{16}|aws_secret_access_key\s*=|aws_access_key_id\s*=|BEGIN (RSA |OPENSSH |EC )?PRIVATE KEY|ghp_[A-Za-z0-9_]{36}|xox[baprs]-[A-Za-z0-9-]+'
Get-ChildItem -Recurse -File -Force |
  Where-Object { $_.FullName -notmatch '\\\.git\\' } |
  Select-String -Pattern $secretPattern
```

---

## 🤖 Initial Prompt for AI Agents

```txt
Please read AGENTS.md, CLAUDE.md, and PROJECT_CONTEXT.md in order.
Summarize and report: tech stack, start/build/test commands,
and environments/files that must not be touched.
Do not modify files, create files, or run any commands yet.
```

---

## 🤝 Contributing

Issues and PRs welcome! → [Issues](https://github.com/<YOUR_USERNAME>/common-harness/issues)  
Bash scripts for Mac/Linux / Template improvements / Additional translations

## 📝 License

[MIT License](LICENSE) · Free to use, modify, and redistribute. Commercial use permitted.

## 🗒️ CHANGELOG

See [CHANGELOG.md](CHANGELOG.md).

---

---

<a id="-中文"></a>

# 🛠️ Common Harness（中文）

> 面向多个开发项目的 AI Agent（Claude Code / Cursor）安全高效管理的通用模板集合。

> **语言 / Language / 言語：**
> [日本語](#-日本語) · [English](#-english) · **[中文](#-中文)**

---

## 📌 概述

`Common Harness` 是一套通用模板集合，用于在多个开发项目中统一管理 Claude Code / Cursor / AI Agent 的行为规则。

**解决的问题：**

- 每个项目都要重新编写 AI Agent 规则
- AI Agent 擅自删除或修改文件
- 担心不小心将 `.env` 或 AWS 密钥 push 到 GitHub
- 不希望 AI Agent 误操作生产 / 预发布 / 开发环境

**本仓库提供：**

| 内容 | 说明 |
|---|---|
| AI Agent 规则模板 | 统一禁止操作、确认义务及工作流程 |
| Claude Code 配置模板 | 最小权限设置，降低操作风险 |
| Cursor 规则模板 | 可直接使用的项目规则雏形 |
| 安装脚本 | 自动将 Harness 文件部署到各项目 |
| 密钥泄露检查 | push 前的机密信息扫描命令 |

---

## 🗂️ 目录结构

```txt
Common_harness/
├─ README.md
├─ CHANGELOG.md
├─ LICENSE
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

## 🚀 快速开始

### 前提条件

| 要求 | 版本 |
|---|---|
| 操作系统 | Windows 10 / 11 |
| PowerShell | 5.1 以上（推荐 7.x） |
| Claude Code | 最新版 |
| Cursor | 最新版（可选） |
| Git | 可选（用于 GitHub 集成） |
| GitHub CLI (`gh`) | 可选（用于创建仓库） |

> ⚠️ 目前仅支持 **Windows / PowerShell**。Mac / Linux 的 bash 脚本尚未提供（欢迎贡献）。

### STEP 1：克隆本仓库

```powershell
git clone https://github.com/<YOUR_USERNAME>/common-harness.git
cd common-harness
```

克隆完成后，`templates/` 目录下已包含所有模板文件。**无需手动创建文件。**

### STEP 2：将 Harness 部署到项目

```powershell
# 基础部署
powershell -ExecutionPolicy Bypass -File .\scripts\install-harness.ps1 `
  -TargetProjectPath <YOUR_WORKSPACE>\your-project

# 同时部署 Cursor 规则
powershell -ExecutionPolicy Bypass -File .\scripts\install-harness.ps1 `
  -TargetProjectPath <YOUR_WORKSPACE>\your-project -InstallCursorRules

# 同时部署共享 skills
powershell -ExecutionPolicy Bypass -File .\scripts\install-harness.ps1 `
  -TargetProjectPath <YOUR_WORKSPACE>\your-project -InstallSkills

# 强制覆盖 PROJECT_CONTEXT.md
powershell -ExecutionPolicy Bypass -File .\scripts\install-harness.ps1 `
  -TargetProjectPath <YOUR_WORKSPACE>\your-project -OverwriteProjectContext
```

### STEP 3：编辑 PROJECT_CONTEXT.md

部署完成后，打开目标项目中的 `PROJECT_CONTEXT.md`，填写项目名称、技术栈、命令、AWS 架构等信息。

---

## 📄 各模板内容说明

### AGENTS.md

```markdown
## 回答规则
- 回答与说明使用日语
- 仅做请求范围内的最小限度修改

## 安全规则
- 禁止读取、输出、修改 .env / *.pem / *.key / AWS 凭证

## 禁止操作（需用户确认后方可执行）
- 添加依赖 / 数据库删除 / git push / rm -rf
- 向生产环境（prd）部署

## 推荐工作流程
1. 读取 PROJECT_CONTEXT.md
2. 向用户说明变更方案
3. 获得批准后执行最小限度修改
4. 运行确认命令并汇报结果
```

### CLAUDE.md

```markdown
## 作业开始前需确认的文件
1. AGENTS.md → 2. PROJECT_CONTEXT.md → 3. 入口文件 → 4. 相关源码

## 工作规则
- 修改前先提交工作计划
- 添加新依赖包必须事先确认

## AWS 相关注意事项
- 未经确认不得修改 DynamoDB / Lambda / IAM / 部署配置
```

### .claude/settings.json

```json
{
  "permissions": {
    "allow": [
      "Bash(npm run lint)", "Bash(npm run lint:fix)", "Bash(npm test)",
      "Bash(npm run build)", "Bash(npm run dev)",
      "Bash(git diff)", "Bash(git diff --staged)", "Bash(git status)",
      "Bash(git log --oneline *)", "Bash(cat *)", "Bash(ls *)", "Bash(echo *)"
    ],
    "deny": [
      "Read(.env)", "Read(.env.*)", "Read(secrets/**)", "Read(credentials/**)",
      "Read(*.pem)", "Read(*.key)",
      "Bash(rm -rf *)", "Bash(git push *)", "Bash(git reset --hard *)",
      "Bash(git clean -fd *)", "Bash(aws dynamodb delete-table *)",
      "Bash(aws dynamodb update-table *)", "Bash(aws iam *)",
      "Bash(aws s3 rb *)", "Bash(terraform destroy *)", "Bash(kubectl delete *)"
    ]
  }
}
```

---

## ⚙️ install-harness.ps1 行为说明

| 处理对象 | 默认行为 | 可选参数 |
|---|---|---|
| `AGENTS.md` | 始终覆盖复制 | — |
| `CLAUDE.md` | 始终覆盖复制 | — |
| `.claude/settings.json` | 始终覆盖复制 | — |
| `.cursorignore` | 始终覆盖复制 | — |
| `PROJECT_CONTEXT.md` | **仅首次复制（已存在则跳过）** | `-OverwriteProjectContext` |
| `.cursor/rules/project-rule.mdc` | 跳过 | `-InstallCursorRules` |
| `.claude/skills/` | 跳过 | `-InstallSkills`（同名跳过） |

**幂等性：** 可多次重复执行，均安全（PROJECT_CONTEXT.md 除外）。

---

## 🏭 生产项目的额外推荐配置

**权限隔离：**
```json
"deny": [
  "Bash(aws * --profile prd*)",
  "Bash(kubectl * --context prd*)",
  "Bash(terraform apply * -var-file=prd*)"
]
```

**分支保护规则（GitHub）：** 禁止直接向 `main` push / 要求 PR 审查 / 要求状态检查通过

---

## 🔐 禁止上传到 GitHub 的内容

`.env` / `.env.*` / `*.pem` / `*.key` / `secrets/` / `credentials/`  
AWS 密钥 / GitHub Token（`ghp_`）/ Slack Token（`xox`）/ 数据库密码 / API Key

---

## 🔍 push 前的机密信息检查

```powershell
$secretPattern = 'AKIA[0-9A-Z]{16}|aws_secret_access_key\s*=|aws_access_key_id\s*=|BEGIN (RSA |OPENSSH |EC )?PRIVATE KEY|ghp_[A-Za-z0-9_]{36}|xox[baprs]-[A-Za-z0-9-]+'
Get-ChildItem -Recurse -File -Force |
  Where-Object { $_.FullName -notmatch '\\\.git\\' } |
  Select-String -Pattern $secretPattern
```

---

## 🤖 AI Agent 初始提示词

```txt
请按顺序阅读 AGENTS.md、CLAUDE.md、PROJECT_CONTEXT.md。
整理并汇报：技术栈、启动/构建/测试命令、不可操作的环境和文件。
暂时不要修改代码、创建文件或执行任何命令。
```

---

## 🤝 贡献指南

欢迎提交 Issue 和 PR！→ [Issues](https://github.com/<YOUR_USERNAME>/common-harness/issues)  
Mac / Linux bash 脚本 / 模板改进 / 更多语言翻译

## 📝 许可证

[MIT License](LICENSE) · 可自由使用、修改和再发布。商业用途亦可。

## 🗒️ 更新日志

版本变更历史请参阅 [CHANGELOG.md](CHANGELOG.md)。

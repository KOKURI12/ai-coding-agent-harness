# 🛠️ Common Harness

**[日本語](#-日本語)** · **[English](#-english)** · **[中文](#-中文)**

---

<a id="-日本語"></a>

# 🛠️ Common Harness（日本語）

> AI Agent（Claude Code / Cursor）を複数プロジェクトで安全に使うための共通テンプレート集です。

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Platform: Windows](https://img.shields.io/badge/Platform-Windows%20%28PowerShell%29-blue)
![Status: Stable](https://img.shields.io/badge/Status-Stable-green)

> **言語 / Language / 语言：**
> **[日本語](#-日本語)** · [English](#-english) · [中文](#-中文)

---

## 📌 概要

AI Agent を使っていると、こんな問題が起きませんか？

- プロジェクトのたびに AI Agent へのルールを書き直している
- AI Agent が勝手にファイルを削除・変更してしまった
- `.env` や AWS キーを GitHub に push してしまいそうで不安
- 本番環境を AI Agent に誤操作されたくない

**Common Harness はこれらをまとめて解決するテンプレート集です。**

| 提供物 | 内容 |
|---|---|
| AI Agent ルールテンプレート | 禁止操作・確認ルール・作業手順を統一 |
| Claude Code 設定テンプレート | 安全な権限設定をすぐに使える |
| Cursor ルールテンプレート | Cursor 用のプロジェクトルール雛形 |
| インストールスクリプト | 各プロジェクトへワンコマンドで配置 |
| 秘密情報チェック | push 前のリークスキャン |

---

## 🗂️ ディレクトリ構成

```txt
Common_harness/
├─ README.md
├─ CHANGELOG.md
├─ LICENSE
├─ .gitignore
├─ templates/
│  ├─ AGENTS.md              # AI Agent 共通ルール
│  ├─ CLAUDE.md              # Claude Code 専用ルール
│  ├─ PROJECT_CONTEXT.md     # プロジェクト固有情報
│  ├─ .claude/
│  │  └─ settings.json       # Claude Code 権限設定
│  ├─ .cursorignore
│  └─ .cursor/
│     └─ rules/
│        └─ project-rule.mdc
└─ scripts/
   └─ install-harness.ps1
```

---

## 🚀 クイックスタート

### 必要なもの

| 要件 | 備考 |
|---|---|
| Windows 10 / 11 | Mac / Linux は未対応（コントリビュート歓迎） |
| PowerShell 5.1 以上 | 推奨：7.x |
| Claude Code | 最新版 |
| Cursor | 任意 |
| Git / GitHub CLI | GitHub 連携する場合 |

---

### STEP 1：クローン

```powershell
git clone https://github.com/<YOUR_USERNAME>/common-harness.git
cd common-harness
```

> `templates/` に全ファイルが揃っています。手動でファイルを作成する必要はありません。

---

### STEP 2：プロジェクトへ配置

```powershell
# 基本配置（これだけで OK）
powershell -ExecutionPolicy Bypass -File .\scripts\install-harness.ps1 `
  -TargetProjectPath C:\your-workspace\your-project

# Cursor rules も一緒に配置したい場合
powershell -ExecutionPolicy Bypass -File .\scripts\install-harness.ps1 `
  -TargetProjectPath C:\your-workspace\your-project -InstallCursorRules

# 共通 skills も配置したい場合
powershell -ExecutionPolicy Bypass -File .\scripts\install-harness.ps1 `
  -TargetProjectPath C:\your-workspace\your-project -InstallSkills
```

> `PROJECT_CONTEXT.md` は既存ファイルがあればスキップします。強制上書きは `-OverwriteProjectContext` を付けてください。

---

### STEP 3：PROJECT_CONTEXT.md を編集

配置後、プロジェクト内の `PROJECT_CONTEXT.md` を開いてプロジェクト情報を記入してください。

---

### STEP 4：AI Agent に読み込ませる

Claude Code / Cursor を起動したら、最初にこの指示を送ってください：

```txt
まず AGENTS.md、CLAUDE.md、PROJECT_CONTEXT.md を順番に読んで、
このプロジェクトのルールと構成を理解してください。
技術スタック・コマンド・作業禁止対象を整理して報告してください。
まだコードの修正・ファイルの作成・コマンドの実行はしないでください。
```

---

## 📄 テンプレート内容ガイド

### AGENTS.md（AI Agent 共通ルール）

AI Agent が守るべき基本ルールを定義します。

- 回答は日本語で、最小限の修正のみ行う
- `.env` / `*.pem` / `*.key` / AWS 認証情報は読まない・変更しない
- `npm install` / `git push` / `rm -rf` / 本番デプロイは事前確認が必要
- 作業前に計画を説明し、承認後に実施する

---

### CLAUDE.md（Claude Code 専用ルール）

Claude Code 固有の動作を制御します。

- 作業開始時は `AGENTS.md` → `PROJECT_CONTEXT.md` → ソースの順に確認する
- 変更前に作業計画を提示する
- DynamoDB / Lambda / IAM などの AWS リソースは事前確認なしに変更しない
- 作業完了後は変更内容・実行コマンド・懸念点をまとめて報告する

---

### PROJECT_CONTEXT.md（プロジェクト固有情報）

このファイルだけプロジェクトごとに編集します。記載内容：

- プロジェクト名・目的
- 技術スタック（言語・DB・インフラ）
- 環境情報（dev / stg / prd）と AI Agent の操作可否
- 起動・ビルド・テストコマンド
- AWS 構成・注意事項

---

### .claude/settings.json（Claude Code 権限設定）

```json
{
  "permissions": {
    "allow": [
      "Bash(npm run lint)",
      "Bash(npm run lint:fix)",
      "Bash(npm test)",
      "Bash(npm run build)",
      "Bash(npm run dev)",
      "Bash(git diff)",
      "Bash(git diff --staged)",
      "Bash(git status)",
      "Bash(git log --oneline *)",
      "Bash(ls *)",
      "Bash(pwd)",
      "Bash(find *)",
      "Bash(grep *)",
      "Bash(head *)",
      "Bash(tail *)"
    ],
    "ask": [
      "Bash(npm install *)",
      "Bash(git add *)",
      "Bash(git commit *)",
      "Bash(rm -f *)",
      "Bash(chmod *)",
      "Bash(curl *)",
      "Bash(wget *)",
      "Bash(aws *)",
      "Bash(terraform *)",
      "Bash(kubectl *)"
    ],
    "deny": [
      "Read(.env)",
      "Read(.env.*)",
      "Read(secrets/**)",
      "Read(credentials/**)",
      "Read(*.pem)",
      "Read(*.key)",
      "Bash(cat .env*)",
      "Bash(cat *.pem)",
      "Bash(cat *.key)",
      "Bash(head .env*)",
      "Bash(tail .env*)",
      "Bash(grep * .env*)",
      "Bash(grep -r * .)",
      "Bash(rm -rf *)",
      "Bash(git push *)",
      "Bash(git reset --hard *)",
      "Bash(git clean -fd *)",
      "Bash(aws dynamodb delete-table *)",
      "Bash(aws dynamodb update-table *)",
      "Bash(aws iam *)",
      "Bash(aws s3 rb *)",
      "Bash(aws s3 rm *)",
      "Bash(terraform destroy *)",
      "Bash(kubectl delete *)",
      "Bash(kubectl exec *)",
      "Bash(ssh *)",
      "Bash(scp *)",
      "Bash(chmod 777 *)",
      "Bash(sudo *)",
      "Bash(find * -delete *)",
      "Bash(find * -exec *)"
    ]
  }
}
```

> **権限の考え方：** `allow`（確認なし）→ `ask`（実行前に確認）→ `deny`（ブロック）の順で評価されます。プロジェクトの技術スタックに合わせて `allow` を調整してください。

---

## ⚙️ install-harness.ps1 の動作

| 対象ファイル | 動作 | オプション |
|---|---|---|
| `AGENTS.md` | 常に上書き | — |
| `CLAUDE.md` | 常に上書き | — |
| `.claude/settings.json` | 常に上書き | — |
| `.cursorignore` | 常に上書き | — |
| `PROJECT_CONTEXT.md` | 初回のみ（既存はスキップ） | `-OverwriteProjectContext` で強制上書き |
| `.cursor/rules/project-rule.mdc` | スキップ | `-InstallCursorRules` で配置 |
| `.claude/skills/` | スキップ | `-InstallSkills` で追加（同名スキップ） |

> 何度実行しても安全です（`PROJECT_CONTEXT.md` を除く）。

---

## 🔐 GitHub に絶対に含めてはいけないもの

```
.env  /  .env.*  /  *.pem  /  *.key  /  secrets/  /  credentials/
AWS キー  /  GitHub Token (ghp_)  /  Slack Token (xox)  /  DB パスワード
```

push 前に必ずチェックしてください：

```powershell
$secretPattern = 'AKIA[0-9A-Z]{16}|aws_secret_access_key\s*=|aws_access_key_id\s*=|BEGIN (RSA |OPENSSH |EC )?PRIVATE KEY|ghp_[A-Za-z0-9_]{36}|xox[baprs]-[A-Za-z0-9-]+'
Get-ChildItem -Recurse -File -Force |
  Where-Object { $_.FullName -notmatch '\\\.git\\' } |
  Select-String -Pattern $secretPattern
```

何も表示されなければ OK です。

---

## 🏭 本番プロジェクトで使う場合

`settings.json` の `deny` に本番環境への操作を追加してください：

```json
"Bash(aws * --profile prd*)",
"Bash(kubectl * --context prd*)",
"Bash(terraform apply * -var-file=prd*)"
```

GitHub のブランチ保護も設定しましょう：`main` への直接 push 禁止 / PR レビュー必須

---

## 🤝 コントリビュート

Issue・PR 歓迎です → [Issues](https://github.com/<YOUR_USERNAME>/common-harness/issues)

Mac / Linux 向け bash スクリプト / テンプレート改善 / 翻訳追加

## 📝 ライセンス

[MIT License](LICENSE) · 自由に使用・改変・再配布できます。商用利用も可能です。

## 🗒️ CHANGELOG

[CHANGELOG.md](CHANGELOG.md) を参照してください。

---

---

<a id="-english"></a>

# 🛠️ Common Harness (English)

> A shared template collection for safely using AI Agents (Claude Code / Cursor) across multiple projects.

> **Language / 言語 / 语言：**
> [日本語](#-日本語) · **[English](#-english)** · [中文](#-中文)

---

## 📌 Overview

Sound familiar?

- Rewriting AI Agent rules for every new project
- AI Agents unexpectedly deleting or modifying files
- Worried about pushing `.env` or AWS keys to GitHub
- Don't want AI Agents touching your production environment

**Common Harness solves all of this with a ready-to-use template set.**

| Item | Description |
|---|---|
| AI Agent rule templates | Standardize rules, restrictions, and workflows |
| Claude Code config | Safe permission settings out of the box |
| Cursor rule template | Ready-to-use project rules for Cursor |
| Install script | One command to deploy to any project |
| Secret leak checker | Scan for secrets before pushing |

---

## 🗂️ Directory Structure

```txt
Common_harness/
├─ README.md
├─ CHANGELOG.md
├─ LICENSE
├─ .gitignore
├─ templates/
│  ├─ AGENTS.md              # Common AI Agent rules
│  ├─ CLAUDE.md              # Claude Code-specific rules
│  ├─ PROJECT_CONTEXT.md     # Per-project context
│  ├─ .claude/
│  │  └─ settings.json       # Claude Code permissions
│  ├─ .cursorignore
│  └─ .cursor/
│     └─ rules/
│        └─ project-rule.mdc
└─ scripts/
   └─ install-harness.ps1
```

---

## 🚀 Quick Start

### Requirements

| Requirement | Notes |
|---|---|
| Windows 10 / 11 | Mac / Linux not yet supported (contributions welcome) |
| PowerShell 5.1+ | 7.x recommended |
| Claude Code | Latest |
| Cursor | Optional |
| Git / GitHub CLI | For GitHub integration |

---

### STEP 1: Clone

```powershell
git clone https://github.com/<YOUR_USERNAME>/common-harness.git
cd common-harness
```

> All template files are ready under `templates/`. No manual file creation needed.

---

### STEP 2: Deploy to your project

```powershell
# Basic deploy (recommended starting point)
powershell -ExecutionPolicy Bypass -File .\scripts\install-harness.ps1 `
  -TargetProjectPath C:\your-workspace\your-project

# Also deploy Cursor rules
powershell -ExecutionPolicy Bypass -File .\scripts\install-harness.ps1 `
  -TargetProjectPath C:\your-workspace\your-project -InstallCursorRules

# Also deploy shared skills
powershell -ExecutionPolicy Bypass -File .\scripts\install-harness.ps1 `
  -TargetProjectPath C:\your-workspace\your-project -InstallSkills
```

> `PROJECT_CONTEXT.md` is skipped if it already exists. Use `-OverwriteProjectContext` to force overwrite.

---

### STEP 3: Edit PROJECT_CONTEXT.md

Open `PROJECT_CONTEXT.md` in your project and fill in your project details.

---

### STEP 4: Load into your AI Agent

When starting Claude Code / Cursor, send this first:

```txt
Please read AGENTS.md, CLAUDE.md, and PROJECT_CONTEXT.md in order.
Summarize and report: tech stack, start/build/test commands,
and environments/files that must not be touched.
Do not modify files, create files, or run any commands yet.
```

---

## 📄 Template Guide

### AGENTS.md (Common AI Agent Rules)

Defines the rules all AI Agents must follow:

- Respond in Japanese; make only minimum necessary changes
- Never read or modify `.env` / `*.pem` / `*.key` / AWS credentials
- Always confirm before: `npm install` / `git push` / `rm -rf` / production deploy
- Explain the plan before acting, implement only after approval

---

### CLAUDE.md (Claude Code-Specific Rules)

Controls Claude Code behavior:

- On start: read `AGENTS.md` → `PROJECT_CONTEXT.md` → source files
- Always present a work plan before making changes
- Never modify DynamoDB / Lambda / IAM / deploy configs without confirmation
- Report changed files, reasons, commands run, and any concerns after completing work

---

### PROJECT_CONTEXT.md (Per-Project Context)

The only file you edit per project. Include:

- Project name and purpose
- Tech stack (language, DB, infrastructure)
- Environments (dev / stg / prd) and AI Agent access rules
- Start / build / test commands
- AWS architecture and notes

---

### .claude/settings.json (Claude Code Permissions)

```json
{
  "permissions": {
    "allow": [
      "Bash(npm run lint)",
      "Bash(npm run lint:fix)",
      "Bash(npm test)",
      "Bash(npm run build)",
      "Bash(npm run dev)",
      "Bash(git diff)",
      "Bash(git diff --staged)",
      "Bash(git status)",
      "Bash(git log --oneline *)",
      "Bash(ls *)",
      "Bash(pwd)",
      "Bash(find *)",
      "Bash(grep *)",
      "Bash(head *)",
      "Bash(tail *)"
    ],
    "ask": [
      "Bash(npm install *)",
      "Bash(git add *)",
      "Bash(git commit *)",
      "Bash(rm -f *)",
      "Bash(chmod *)",
      "Bash(curl *)",
      "Bash(wget *)",
      "Bash(aws *)",
      "Bash(terraform *)",
      "Bash(kubectl *)"
    ],
    "deny": [
      "Read(.env)",
      "Read(.env.*)",
      "Read(secrets/**)",
      "Read(credentials/**)",
      "Read(*.pem)",
      "Read(*.key)",
      "Bash(cat .env*)",
      "Bash(cat *.pem)",
      "Bash(cat *.key)",
      "Bash(head .env*)",
      "Bash(tail .env*)",
      "Bash(grep * .env*)",
      "Bash(grep -r * .)",
      "Bash(rm -rf *)",
      "Bash(git push *)",
      "Bash(git reset --hard *)",
      "Bash(git clean -fd *)",
      "Bash(aws dynamodb delete-table *)",
      "Bash(aws dynamodb update-table *)",
      "Bash(aws iam *)",
      "Bash(aws s3 rb *)",
      "Bash(aws s3 rm *)",
      "Bash(terraform destroy *)",
      "Bash(kubectl delete *)",
      "Bash(kubectl exec *)",
      "Bash(ssh *)",
      "Bash(scp *)",
      "Bash(chmod 777 *)",
      "Bash(sudo *)",
      "Bash(find * -delete *)",
      "Bash(find * -exec *)"
    ]
  }
}
```

> **How permissions work:** evaluated in order — `deny` → `ask` → `allow`. First match wins. Adjust `allow` to fit your project's tech stack.

---

## ⚙️ install-harness.ps1 Behavior

| File | Behavior | Option |
|---|---|---|
| `AGENTS.md` | Always overwrite | — |
| `CLAUDE.md` | Always overwrite | — |
| `.claude/settings.json` | Always overwrite | — |
| `.cursorignore` | Always overwrite | — |
| `PROJECT_CONTEXT.md` | First-time only (skip if exists) | `-OverwriteProjectContext` |
| `.cursor/rules/project-rule.mdc` | Skip | `-InstallCursorRules` |
| `.claude/skills/` | Skip | `-InstallSkills` (skip on conflict) |

> Safe to run multiple times (except `PROJECT_CONTEXT.md`).

---

## 🔐 Never Push These to GitHub

```
.env  /  .env.*  /  *.pem  /  *.key  /  secrets/  /  credentials/
AWS keys  /  GitHub Token (ghp_)  /  Slack Token (xox)  /  DB passwords
```

Always check before pushing:

```powershell
$secretPattern = 'AKIA[0-9A-Z]{16}|aws_secret_access_key\s*=|aws_access_key_id\s*=|BEGIN (RSA |OPENSSH |EC )?PRIVATE KEY|ghp_[A-Za-z0-9_]{36}|xox[baprs]-[A-Za-z0-9-]+'
Get-ChildItem -Recurse -File -Force |
  Where-Object { $_.FullName -notmatch '\\\.git\\' } |
  Select-String -Pattern $secretPattern
```

No output = you're clear.

---

## 🏭 For Production Projects

Add these to `deny` in `settings.json`:

```json
"Bash(aws * --profile prd*)",
"Bash(kubectl * --context prd*)",
"Bash(terraform apply * -var-file=prd*)"
```

Also set GitHub branch protection: block direct push to `main` / require PR review.

---

## 🤝 Contributing

Issues and PRs welcome → [Issues](https://github.com/<YOUR_USERNAME>/common-harness/issues)

Bash scripts for Mac/Linux / Template improvements / Additional translations

## 📝 License

[MIT License](LICENSE) · Free to use, modify, and redistribute. Commercial use permitted.

## 🗒️ CHANGELOG

See [CHANGELOG.md](CHANGELOG.md).

---

---

<a id="-中文"></a>

# 🛠️ Common Harness（中文）

> 面向多个开发项目的 AI Agent（Claude Code / Cursor）安全管理通用模板集合。

> **语言 / Language / 言語：**
> [日本語](#-日本語) · [English](#-english) · **[中文](#-中文)**

---

## 📌 概述

你是否遇到过这些问题？

- 每个项目都要重新编写 AI Agent 规则
- AI Agent 擅自删除或修改了文件
- 担心不小心将 `.env` 或 AWS 密钥 push 到 GitHub
- 不希望 AI Agent 误操作生产环境

**Common Harness 用一套模板集合解决以上所有问题。**

| 内容 | 说明 |
|---|---|
| AI Agent 规则模板 | 统一禁止操作、确认规则及工作流程 |
| Claude Code 配置模板 | 开箱即用的安全权限设置 |
| Cursor 规则模板 | Cursor 项目规则雏形 |
| 安装脚本 | 一条命令部署到任意项目 |
| 密钥泄露检查 | push 前扫描机密信息 |

---

## 🗂️ 目录结构

```txt
Common_harness/
├─ README.md
├─ CHANGELOG.md
├─ LICENSE
├─ .gitignore
├─ templates/
│  ├─ AGENTS.md              # AI Agent 通用规则
│  ├─ CLAUDE.md              # Claude Code 专用规则
│  ├─ PROJECT_CONTEXT.md     # 项目专属信息
│  ├─ .claude/
│  │  └─ settings.json       # Claude Code 权限配置
│  ├─ .cursorignore
│  └─ .cursor/
│     └─ rules/
│        └─ project-rule.mdc
└─ scripts/
   └─ install-harness.ps1
```

---

## 🚀 快速开始

### 环境要求

| 要求 | 备注 |
|---|---|
| Windows 10 / 11 | 暂不支持 Mac / Linux（欢迎贡献） |
| PowerShell 5.1 以上 | 推荐 7.x |
| Claude Code | 最新版 |
| Cursor | 可选 |
| Git / GitHub CLI | 用于 GitHub 集成 |

---

### STEP 1：克隆

```powershell
git clone https://github.com/<YOUR_USERNAME>/common-harness.git
cd common-harness
```

> `templates/` 下已包含所有模板文件，无需手动创建。

---

### STEP 2：部署到项目

```powershell
# 基础部署（推荐从这里开始）
powershell -ExecutionPolicy Bypass -File .\scripts\install-harness.ps1 `
  -TargetProjectPath C:\your-workspace\your-project

# 同时部署 Cursor 规则
powershell -ExecutionPolicy Bypass -File .\scripts\install-harness.ps1 `
  -TargetProjectPath C:\your-workspace\your-project -InstallCursorRules

# 同时部署共享 skills
powershell -ExecutionPolicy Bypass -File .\scripts\install-harness.ps1 `
  -TargetProjectPath C:\your-workspace\your-project -InstallSkills
```

> `PROJECT_CONTEXT.md` 已存在时会自动跳过。强制覆盖请加 `-OverwriteProjectContext`。

---

### STEP 3：编辑 PROJECT_CONTEXT.md

打开项目中的 `PROJECT_CONTEXT.md`，填写项目信息。

---

### STEP 4：让 AI Agent 读取规则

启动 Claude Code / Cursor 后，先发送以下指令：

```txt
请按顺序阅读 AGENTS.md、CLAUDE.md、PROJECT_CONTEXT.md，
理解本项目的规则和结构。
整理并汇报：技术栈、启动/构建/测试命令、不可操作的环境和文件。
暂时不要修改代码、创建文件或执行任何命令。
```

---

## 📄 模板内容说明

### AGENTS.md（AI Agent 通用规则）

定义所有 AI Agent 必须遵守的规则：

- 使用日语回答，仅做最小限度修改
- 禁止读取或修改 `.env` / `*.pem` / `*.key` / AWS 凭证
- 以下操作需用户确认：`npm install` / `git push` / `rm -rf` / 生产环境部署
- 执行前说明计划，获得批准后再实施

---

### CLAUDE.md（Claude Code 专用规则）

控制 Claude Code 的专属行为：

- 启动时按顺序读取：`AGENTS.md` → `PROJECT_CONTEXT.md` → 源码
- 修改前先提交工作计划
- 未经确认不得修改 DynamoDB / Lambda / IAM / 部署配置
- 作业完成后汇报：变更文件、原因、执行命令及结果、遗留问题

---

### PROJECT_CONTEXT.md（项目专属信息）

每个项目唯一需要编辑的文件，包含：

- 项目名称与目的
- 技术栈（语言、数据库、基础设施）
- 环境信息（dev / stg / prd）及 AI Agent 操作权限
- 启动 / 构建 / 测试命令
- AWS 架构与注意事项

---

### .claude/settings.json（权限配置）

```json
{
  "permissions": {
    "allow": [
      "Bash(npm run lint)",
      "Bash(npm run lint:fix)",
      "Bash(npm test)",
      "Bash(npm run build)",
      "Bash(npm run dev)",
      "Bash(git diff)",
      "Bash(git diff --staged)",
      "Bash(git status)",
      "Bash(git log --oneline *)",
      "Bash(ls *)",
      "Bash(pwd)",
      "Bash(find *)",
      "Bash(grep *)",
      "Bash(head *)",
      "Bash(tail *)"
    ],
    "ask": [
      "Bash(npm install *)",
      "Bash(git add *)",
      "Bash(git commit *)",
      "Bash(rm -f *)",
      "Bash(chmod *)",
      "Bash(curl *)",
      "Bash(wget *)",
      "Bash(aws *)",
      "Bash(terraform *)",
      "Bash(kubectl *)"
    ],
    "deny": [
      "Read(.env)",
      "Read(.env.*)",
      "Read(secrets/**)",
      "Read(credentials/**)",
      "Read(*.pem)",
      "Read(*.key)",
      "Bash(cat .env*)",
      "Bash(cat *.pem)",
      "Bash(cat *.key)",
      "Bash(head .env*)",
      "Bash(tail .env*)",
      "Bash(grep * .env*)",
      "Bash(grep -r * .)",
      "Bash(rm -rf *)",
      "Bash(git push *)",
      "Bash(git reset --hard *)",
      "Bash(git clean -fd *)",
      "Bash(aws dynamodb delete-table *)",
      "Bash(aws dynamodb update-table *)",
      "Bash(aws iam *)",
      "Bash(aws s3 rb *)",
      "Bash(aws s3 rm *)",
      "Bash(terraform destroy *)",
      "Bash(kubectl delete *)",
      "Bash(kubectl exec *)",
      "Bash(ssh *)",
      "Bash(scp *)",
      "Bash(chmod 777 *)",
      "Bash(sudo *)",
      "Bash(find * -delete *)",
      "Bash(find * -exec *)"
    ]
  }
}
```

> **权限评估顺序：** `deny` → `ask` → `allow`，第一个匹配规则生效。请根据项目技术栈调整 `allow` 列表。

---

## ⚙️ install-harness.ps1 行为说明

| 文件 | 默认行为 | 可选参数 |
|---|---|---|
| `AGENTS.md` | 始终覆盖 | — |
| `CLAUDE.md` | 始终覆盖 | — |
| `.claude/settings.json` | 始终覆盖 | — |
| `.cursorignore` | 始终覆盖 | — |
| `PROJECT_CONTEXT.md` | 仅首次（已存在则跳过） | `-OverwriteProjectContext` |
| `.cursor/rules/project-rule.mdc` | 跳过 | `-InstallCursorRules` |
| `.claude/skills/` | 跳过 | `-InstallSkills`（同名跳过） |

> 可多次重复执行，均安全（`PROJECT_CONTEXT.md` 除外）。

---

## 🔐 禁止上传到 GitHub 的内容

```
.env  /  .env.*  /  *.pem  /  *.key  /  secrets/  /  credentials/
AWS 密钥  /  GitHub Token (ghp_)  /  Slack Token (xox)  /  数据库密码
```

push 前必须检查：

```powershell
$secretPattern = 'AKIA[0-9A-Z]{16}|aws_secret_access_key\s*=|aws_access_key_id\s*=|BEGIN (RSA |OPENSSH |EC )?PRIVATE KEY|ghp_[A-Za-z0-9_]{36}|xox[baprs]-[A-Za-z0-9-]+'
Get-ChildItem -Recurse -File -Force |
  Where-Object { $_.FullName -notmatch '\\\.git\\' } |
  Select-String -Pattern $secretPattern
```

无输出即可安全 push。

---

## 🏭 生产项目的额外配置

在 `settings.json` 的 `deny` 中追加：

```json
"Bash(aws * --profile prd*)",
"Bash(kubectl * --context prd*)",
"Bash(terraform apply * -var-file=prd*)"
```

同时建议开启 GitHub 分支保护：禁止直接 push 到 `main` / 要求 PR 审查。

---

## 🤝 贡献指南

欢迎提交 Issue 和 PR → [Issues](https://github.com/<YOUR_USERNAME>/common-harness/issues)

Mac / Linux bash 脚本 / 模板改进 / 更多语言翻译

## 📝 许可证

[MIT License](LICENSE) · 可自由使用、修改和再发布。商业用途亦可。

## 🗒️ 更新日志

版本变更历史请参阅 [CHANGELOG.md](CHANGELOG.md)。

param(
    [Parameter(Mandatory=$true)]
    [string]$TargetProjectPath,

    [switch]$InstallCursorRules,
    [switch]$InstallSkills,
    [switch]$OverwriteProjectContext
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$CommonHarnessDir = Split-Path -Parent $ScriptDir
$TemplateDir = Join-Path $CommonHarnessDir "templates"

# --- 対象パス存在チェック ---
if (!(Test-Path $TargetProjectPath)) {
    Write-Host "ERROR: Target project path does not exist: $TargetProjectPath" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=== Common Harness Installer ===" -ForegroundColor Cyan
Write-Host "Target: $TargetProjectPath"
Write-Host ""

# --- ヘルパー関数 ---
function Copy-HarnessFile {
    param(
        [string]$Src,
        [string]$Dst,
        [bool]$Force = $true
    )
    try {
        $DstDir = Split-Path -Parent $Dst
        if (!(Test-Path $DstDir)) {
            New-Item -ItemType Directory -Force -Path $DstDir | Out-Null
        }
        Copy-Item -Path $Src -Destination $Dst -Force:$Force
        Write-Host "  [OK] $(Split-Path -Leaf $Dst)" -ForegroundColor Green
    } catch {
        Write-Host "  [SKIP] $(Split-Path -Leaf $Dst) - $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

# --- 基本 Harness ファイル（常に上書き） ---
Write-Host "[1/4] 基本 Harness ファイルをコピーします..." -ForegroundColor Cyan

Copy-HarnessFile `
    -Src (Join-Path $TemplateDir "AGENTS.md") `
    -Dst (Join-Path $TargetProjectPath "AGENTS.md")

Copy-HarnessFile `
    -Src (Join-Path $TemplateDir "CLAUDE.md") `
    -Dst (Join-Path $TargetProjectPath "CLAUDE.md")

Copy-HarnessFile `
    -Src (Join-Path $TemplateDir ".cursorignore") `
    -Dst (Join-Path $TargetProjectPath ".cursorignore")

# settings.json のみコピー（.claude/ 全体は上書きしない）
$SettingsSrc = Join-Path $TemplateDir ".claude\settings.json"
$SettingsDst = Join-Path $TargetProjectPath ".claude\settings.json"
Copy-HarnessFile -Src $SettingsSrc -Dst $SettingsDst

# --- PROJECT_CONTEXT.md（初回のみ / -OverwriteProjectContext で強制上書き） ---
Write-Host ""
Write-Host "[2/4] PROJECT_CONTEXT.md の処理..." -ForegroundColor Cyan

$ProjectContextDst = Join-Path $TargetProjectPath "PROJECT_CONTEXT.md"

if ($OverwriteProjectContext) {
    Copy-HarnessFile `
        -Src (Join-Path $TemplateDir "PROJECT_CONTEXT.md") `
        -Dst $ProjectContextDst
    Write-Host "  [INFO] -OverwriteProjectContext: 強制上書きしました。" -ForegroundColor Yellow
} elseif (Test-Path $ProjectContextDst) {
    Write-Host "  [SKIP] PROJECT_CONTEXT.md は既に存在します（上書きしません）。" -ForegroundColor Yellow
    Write-Host "         強制上書きする場合は -OverwriteProjectContext を指定してください。"
} else {
    Copy-HarnessFile `
        -Src (Join-Path $TemplateDir "PROJECT_CONTEXT.md") `
        -Dst $ProjectContextDst
}

# --- Cursor rules（-InstallCursorRules オプション時のみ） ---
Write-Host ""
Write-Host "[3/4] Cursor rules の処理..." -ForegroundColor Cyan

if ($InstallCursorRules) {
    $CursorSrc = Join-Path $TemplateDir ".cursor\rules\project-rule.mdc"
    $CursorDst = Join-Path $TargetProjectPath ".cursor\rules\project-rule.mdc"
    Copy-HarnessFile -Src $CursorSrc -Dst $CursorDst
} else {
    Write-Host "  [SKIP] -InstallCursorRules が指定されていないためスキップします。" -ForegroundColor Yellow
}

# --- 共通 skills（-InstallSkills オプション時のみ、同名はスキップ） ---
Write-Host ""
Write-Host "[4/4] 共通 skills の処理..." -ForegroundColor Cyan

if ($InstallSkills) {
    $SkillsSrc = Join-Path $TemplateDir ".claude\skills"
    $SkillsDst = Join-Path $TargetProjectPath ".claude\skills"

    if (!(Test-Path $SkillsSrc)) {
        Write-Host "  [SKIP] テンプレートに .claude/skills が存在しません。" -ForegroundColor Yellow
    } else {
        if (!(Test-Path $SkillsDst)) {
            New-Item -ItemType Directory -Force -Path $SkillsDst | Out-Null
        }
        $SkillFiles = Get-ChildItem -Path $SkillsSrc -File
        foreach ($Skill in $SkillFiles) {
            $DstFile = Join-Path $SkillsDst $Skill.Name
            if (Test-Path $DstFile) {
                Write-Host "  [SKIP] $($Skill.Name) は既に存在します（上書きしません）。" -ForegroundColor Yellow
            } else {
                Copy-Item -Path $Skill.FullName -Destination $DstFile -Force
                Write-Host "  [OK] $($Skill.Name)" -ForegroundColor Green
            }
        }
    }
} else {
    Write-Host "  [SKIP] -InstallSkills が指定されていないためスキップします。" -ForegroundColor Yellow
}

# --- 完了メッセージ ---
Write-Host ""
Write-Host "=== インストール完了 ===" -ForegroundColor Green
Write-Host ""
Write-Host "次のステップ:" -ForegroundColor Yellow
Write-Host "  1. PROJECT_CONTEXT.md をこのプロジェクト用に編集してください。"
Write-Host "  2. Claude Code / Cursor を起動して AGENTS.md / CLAUDE.md / PROJECT_CONTEXT.md を読み込ませてください。"
Write-Host ""

param(
    [Parameter(Mandatory=$true)]
    [string]$TargetProjectPath
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$CommonHarnessDir = Split-Path -Parent $ScriptDir
$TemplateDir = Join-Path $CommonHarnessDir "templates"

if (!(Test-Path $TargetProjectPath)) {
    Write-Host "Target project path does not exist: $TargetProjectPath" -ForegroundColor Red
    exit 1
}

Write-Host "Installing common harness to:" -ForegroundColor Cyan
Write-Host $TargetProjectPath

Copy-Item -Path (Join-Path $TemplateDir "AGENTS.md") -Destination (Join-Path $TargetProjectPath "AGENTS.md") -Force
Copy-Item -Path (Join-Path $TemplateDir "CLAUDE.md") -Destination (Join-Path $TargetProjectPath "CLAUDE.md") -Force
Copy-Item -Path (Join-Path $TemplateDir "PROJECT_CONTEXT.md") -Destination (Join-Path $TargetProjectPath "PROJECT_CONTEXT.md") -Force
Copy-Item -Path (Join-Path $TemplateDir ".cursorignore") -Destination (Join-Path $TargetProjectPath ".cursorignore") -Force

Copy-Item -Path (Join-Path $TemplateDir ".claude") -Destination $TargetProjectPath -Recurse -Force
Copy-Item -Path (Join-Path $TemplateDir ".cursor") -Destination $TargetProjectPath -Recurse -Force

Write-Host "Harness files installed successfully." -ForegroundColor Green
Write-Host ""
Write-Host "Next step:" -ForegroundColor Yellow
Write-Host "Edit PROJECT_CONTEXT.md for this specific project."
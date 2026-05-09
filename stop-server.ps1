# =====================================================
#   DarkFlix - Stop Server Script
# =====================================================

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$composeFile = Join-Path $scriptDir "docker-compose.yml"

Write-Host ""
Write-Host "  Stopping DarkFlix Streaming Server..." -ForegroundColor Yellow

docker-compose -f $composeFile down

Write-Host ""
Write-Host "  ✓ Server stopped." -ForegroundColor Green
Write-Host ""
Read-Host "  Press Enter to exit"

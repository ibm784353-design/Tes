# =====================================================
#   DarkFlix - Start Script
#   يشغل السيرفر + يفتح المتصفح أوتوماتيك
# =====================================================

$ErrorActionPreference = "Stop"
$Host.UI.RawUI.WindowTitle = "DarkFlix Server"

Write-Host ""
Write-Host "  ██████╗  █████╗ ██████╗ ██╗  ██╗███████╗██╗     ██╗██╗  ██╗" -ForegroundColor DarkYellow
Write-Host "  ██╔══██╗██╔══██╗██╔══██╗██║ ██╔╝██╔════╝██║     ██║╚██╗██╔╝" -ForegroundColor DarkYellow
Write-Host "  ██║  ██║███████║██████╔╝█████╔╝ █████╗  ██║     ██║ ╚███╔╝ " -ForegroundColor Yellow
Write-Host "  ██║  ██║██╔══██║██╔══██╗██╔═██╗ ██╔══╝  ██║     ██║ ██╔██╗ " -ForegroundColor Yellow
Write-Host "  ██████╔╝██║  ██║██║  ██║██║  ██╗██║     ███████╗██║██╔╝ ██╗" -ForegroundColor DarkRed
Write-Host "  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚══════╝╚═╝╚═╝  ╚═╝" -ForegroundColor DarkRed
Write-Host ""
Write-Host "  Freedom to Stream - DarkFlix Edition" -ForegroundColor Gray
Write-Host ""

# ── 1. التحقق من Docker ──────────────────────────────
Write-Host "[1/4] Checking Docker..." -ForegroundColor Cyan
try {
    $dockerVersion = docker --version 2>&1
    Write-Host "  ✓ $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host ""
    Write-Host "  ✗ Docker not found!" -ForegroundColor Red
    Write-Host "  Please install Docker Desktop from: https://www.docker.com/products/docker-desktop/" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "  Press Enter to exit"
    exit 1
}

# التحقق أن Docker شغّال
try {
    docker info 2>&1 | Out-Null
    Write-Host "  ✓ Docker Desktop is running" -ForegroundColor Green
} catch {
    Write-Host ""
    Write-Host "  ✗ Docker Desktop is not running!" -ForegroundColor Red
    Write-Host "  Please start Docker Desktop and try again." -ForegroundColor Yellow
    Write-Host ""
    Read-Host "  Press Enter to exit"
    exit 1
}

# ── 2. تشغيل الـ Server ──────────────────────────────
Write-Host ""
Write-Host "[2/4] Starting DarkFlix Streaming Server..." -ForegroundColor Cyan

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$composeFile = Join-Path $scriptDir "docker-compose.yml"

# إيقاف أي container قديم
Write-Host "  Stopping old server (if any)..." -ForegroundColor Gray
docker-compose -f $composeFile down 2>&1 | Out-Null

# تشغيل السيرفر الجديد
Write-Host "  Pulling latest server image..." -ForegroundColor Gray
docker-compose -f $composeFile pull 2>&1 | Out-Null

Write-Host "  Starting server..." -ForegroundColor Gray
docker-compose -f $composeFile up -d 2>&1 | Out-Null

# ── 3. انتظار حتى يصبح السيرفر جاهز ─────────────────
Write-Host ""
Write-Host "[3/4] Waiting for server to be ready..." -ForegroundColor Cyan

$maxWait = 30
$waited = 0
$ready = $false

while ($waited -lt $maxWait) {
    try {
        $response = Invoke-WebRequest -Uri "http://127.0.0.1:11470/" -TimeoutSec 2 -UseBasicParsing 2>&1
        if ($response.StatusCode -eq 200) {
            $ready = $true
            break
        }
    } catch {
        # لسه ما اتشغلش
    }
    
    $dots = "." * (($waited % 3) + 1)
    Write-Host "`r  Waiting$dots   " -NoNewline -ForegroundColor Gray
    Start-Sleep -Seconds 1
    $waited++
}

Write-Host ""

if ($ready) {
    Write-Host "  ✓ Streaming Server is ONLINE at http://127.0.0.1:11470/" -ForegroundColor Green
} else {
    Write-Host "  ⚠ Server may still be starting (took > ${maxWait}s)" -ForegroundColor Yellow
    Write-Host "  Continuing anyway..." -ForegroundColor Gray
}

# ── 4. فتح DarkFlix في المتصفح ───────────────────────
Write-Host ""
Write-Host "[4/4] Opening DarkFlix..." -ForegroundColor Cyan

# تحديد الـ URL
$darkflixPort = 8080
$darkflixUrl = "https://localhost:$darkflixPort"

# فتح المتصفح
Start-Process $darkflixUrl

Write-Host "  ✓ DarkFlix opened at $darkflixUrl" -ForegroundColor Green
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkYellow
Write-Host ""
Write-Host "  DarkFlix:          $darkflixUrl" -ForegroundColor White
Write-Host "  Streaming Server:  http://127.0.0.1:11470/" -ForegroundColor White
Write-Host ""
Write-Host "  ℹ  If you see 'server unavailable' in DarkFlix:" -ForegroundColor Cyan
Write-Host "     Go to Settings → Streaming → the URL should" -ForegroundColor Gray
Write-Host "     show as 'Online'. If not, click Reload." -ForegroundColor Gray
Write-Host ""
Write-Host "  To STOP the server, run: stop-server.ps1" -ForegroundColor Gray
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkYellow
Write-Host ""
Read-Host "  Press Enter to exit this window (server keeps running)"

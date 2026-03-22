$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$backendDir = Join-Path $root "backend"
$frontendDir = Join-Path $root "frontend"

$backendPython = Join-Path $backendDir "venv\Scripts\python.exe"

if (-not (Test-Path $backendPython)) {
    Write-Error "Backend virtual environment not found at $backendPython. Create it first."
}

if (-not (Test-Path (Join-Path $frontendDir "package.json"))) {
    Write-Error "Frontend package.json not found at $frontendDir."
}

Write-Host "Starting backend on http://localhost:8000 ..."
$backend = Start-Process powershell.exe `
    -ArgumentList "-NoExit", "-Command", "Set-Location '$backendDir'; `$env:PYTHONIOENCODING='utf-8'; & '$backendPython' -m app.main" `
    -PassThru

Start-Sleep -Seconds 2

Write-Host "Starting frontend on http://localhost:5173 ..."
$frontend = Start-Process powershell.exe `
    -ArgumentList "-NoExit", "-Command", "Set-Location '$frontendDir'; npm run dev" `
    -PassThru

Write-Host ""
Write-Host "Backend PID : $($backend.Id)"
Write-Host "Frontend PID: $($frontend.Id)"
Write-Host "Frontend URL: http://localhost:5173"
Write-Host "Backend URL : http://localhost:8000"

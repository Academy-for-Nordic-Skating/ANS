# Run from repo root:
#   .\testbrowser.ps1
#   .\testbrowser.ps1 -Browser edge
#   .\testbrowser.ps1 -SkipClean          (faster; use if build\flutter_assets is not locked)
#
# Runs static analysis, then starts the Flutter web app in a browser for manual checks.
# The terminal stays attached until you stop the app: press "q" in this window or Ctrl+C.
#
# By default we run "flutter clean" first. On Windows, Chrome or an old debug session often
# locks flutter_app\build\flutter_assets; clean avoids "failed to delete" errors.

param(
  [ValidateSet('chrome', 'edge')]
  [string] $Browser = 'chrome',
  [switch] $SkipClean
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Root = $PSScriptRoot
$env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' +
  [System.Environment]::GetEnvironmentVariable('Path', 'User')

$FlutterApp = Join-Path $Root 'flutter_app'
if (-not (Test-Path $FlutterApp)) {
  Write-Error "flutter_app folder not found under $Root"
}

Push-Location $FlutterApp
try {
  if (-not $SkipClean) {
    Write-Host '>> flutter clean  (clears build folder; avoids Windows file locks)' -ForegroundColor Cyan
    flutter clean
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
  }

  Write-Host '>> flutter pub get' -ForegroundColor Cyan
  flutter pub get
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

  Write-Host '>> flutter analyze' -ForegroundColor Cyan
  flutter analyze
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

  Write-Host ''
  Write-Host ">> flutter run -d $Browser  (dev / hot reload - browser opens)" -ForegroundColor Cyan
  Write-Host '   When finished checking: press q in this terminal, or close with Ctrl+C.' -ForegroundColor DarkGray
  Write-Host '   If run still fails on build\flutter_assets: close all Chrome windows, then try again.' -ForegroundColor DarkGray
  Write-Host ''

  flutter run -d $Browser
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}
finally {
  Pop-Location
}

Write-Host 'testbrowser: finished' -ForegroundColor Green

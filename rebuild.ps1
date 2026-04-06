# Run from repo root: .\rebuild.ps1
# Production Flutter web build (output: flutter_app\build\web).

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
  Write-Host '>> flutter pub get' -ForegroundColor Cyan
  flutter pub get

  Write-Host '>> flutter build web --release' -ForegroundColor Cyan
  flutter build web --release
}
finally {
  Pop-Location
}

Write-Host 'rebuild: OK (flutter_app\build\web)' -ForegroundColor Green

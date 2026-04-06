# Run from repo root: .\deploy.ps1
# Deploys Firebase Hosting (runs Node predeploy sync from flutter build).

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Root = $PSScriptRoot
$env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' +
  [System.Environment]::GetEnvironmentVariable('Path', 'User')

$FirebaseDir = Join-Path $Root 'firebase'
if (-not (Test-Path $FirebaseDir)) {
  Write-Error "firebase folder not found under $Root"
}

$WebBuild = Join-Path $Root 'flutter_app\build\web'
if (-not (Test-Path $WebBuild)) {
  Write-Error "Missing web build. Run .\rebuild.ps1 first. Expected: $WebBuild"
}

Push-Location $FirebaseDir
try {
  Write-Host '>> firebase deploy --only hosting' -ForegroundColor Cyan
  firebase deploy --only hosting
}
finally {
  Pop-Location
}

Write-Host 'deploy: OK' -ForegroundColor Green

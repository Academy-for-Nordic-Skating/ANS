# Run from repo root:
#   .\commit.ps1 -Message "Your message"
#   .\commit.ps1   (prompts for message)

param(
  [Parameter(Mandatory = $false)]
  [string] $Message
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Root = $PSScriptRoot
$env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' +
  [System.Environment]::GetEnvironmentVariable('Path', 'User')

Push-Location $Root
try {
  if ([string]::IsNullOrWhiteSpace($Message)) {
    $Message = Read-Host 'Commit message'
  }
  if ([string]::IsNullOrWhiteSpace($Message)) {
    Write-Error 'Commit message is required.'
  }

  Write-Host '>> git add -A' -ForegroundColor Cyan
  git add -A

  $status = git status --porcelain
  if ([string]::IsNullOrWhiteSpace($status)) {
    Write-Host 'Nothing to commit (working tree clean).' -ForegroundColor Yellow
    exit 0
  }

  Write-Host '>> git commit' -ForegroundColor Cyan
  git commit -m $Message
}
finally {
  Pop-Location
}

Write-Host 'commit: OK (push separately if needed: git push)' -ForegroundColor Green

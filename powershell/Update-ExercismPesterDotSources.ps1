# Update-ExercismPesterDotSources.ps1
<#  Fix to run unit tests one at a time using VS Code's Testing UI.
 #
 #  Exercism's tests all expect Invoke-Pester from the exercise subfolder:
 #
 #      BeforeAll {
 #          . "./HelloWorld.ps1"
 #      }
 #
 #  This script changes BeforeAlls, so that tests may be run from any PWD:
 #
 #      BeforeAll {
 #          . (Join-Path -Path $PSScriptRoot -ChildPath 'HelloWorld.ps1')
 #      }
 #
 #  Only tested in pwsh (PowerShell 7.5.4) with Pester module version 5.7.1.
 #    I have NOT tested built-in Windows powershell (5.1) and Pester (3.4.0).
 #  Also seems to require the following config in .vscode/settings.json:
 #    "powershell.enableProfileLoading": false
 #  (without that setting, VS Code's Testing with PowerShell Extension
 #    sometimes tries to test using pwsh with the older Pester 3.4.0,
 #    which doesn't work properly)
 # 16-Feb-2026, gibbonsc and M365 Copilot Chat
 #>
$root = "$HOME\Exercism\powershell"  # change if necessary
Get-ChildItem -Path $root -Recurse -Filter '*Tests.ps1' | ForEach-Object {
  $path = $_.FullName; $lines = Get-Content -LiteralPath $path; $changed = $false
  for ($i=0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match '^\s*BeforeAll\b') {
      $depth = 0; $in = $false
      for ($j=$i; $j -lt $lines.Count; $j++) {
        $depth += ($lines[$j] -split '\{').Count - 1
        if ($depth -gt 0) { $in = $true }
        if ($in -and $lines[$j] -notmatch 'Join-Path.*\$PSScriptRoot' -and
            $lines[$j] -match '^\s*\.\s*["'']?\.[\\/](.+?\.ps1)["'']?\s*$') {
          $rel = $matches[1]
          $lines[$j] = ". (Join-Path -Path `$PSScriptRoot -ChildPath '$rel')"
          $changed = $true
        }
        $depth -= ($lines[$j] -split '\}').Count - 1
        if ($in -and $depth -le 0) { break }
      }
      break
    }
  }
  if ($changed) { Set-Content -LiteralPath $path -Value $lines -Encoding UTF8; Write-Host "Fixed: $path" }
  else { Write-Host "OK: $path" }
}

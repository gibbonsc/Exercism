# Fix-ExercismDotSourcing.ps1
$root = "$HOME\Exercism\powershell"  # change if needed
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
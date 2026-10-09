$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$failures = @()
foreach ($file in Get-ChildItem -LiteralPath (Join-Path $root 'src') -Filter '*.ps1') {
    $tokens = $null; $errors = $null
    [Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$tokens, [ref]$errors) | Out-Null
    $failures += @($errors)
}
if ($failures.Count) { $failures | Format-List; throw 'PowerShell syntax checks failed.' }
& (Join-Path $root 'tests\Core.Tests.ps1')
& (Join-Path $root 'tests\Icons.Tests.ps1')
Write-Output 'PowerShell source syntax: passed.'

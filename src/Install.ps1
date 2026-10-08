$ErrorActionPreference = 'Stop'
$destination = Join-Path $env:LOCALAPPDATA 'OpenAI\CodexInstanceManager\app'
[IO.Directory]::CreateDirectory($destination) | Out-Null
foreach ($name in @('Core.ps1','Manager.ps1','UI.ps1','Open-Manager.cmd','README.txt')) {
    $source = Join-Path $PSScriptRoot $name
    $target = Join-Path $destination $name
    if ([IO.Path]::GetFullPath($source) -ne [IO.Path]::GetFullPath($target)) { Copy-Item -LiteralPath $source -Destination $target -Force }
}
$assetSource = Join-Path $PSScriptRoot 'assets'
if (-not (Test-Path -LiteralPath $assetSource -PathType Container)) { $assetSource = Join-Path (Split-Path -Parent $PSScriptRoot) 'assets' }
$assetTarget = Join-Path $destination 'assets'
if ((Test-Path -LiteralPath $assetSource -PathType Container) -and [IO.Path]::GetFullPath($assetSource) -ne [IO.Path]::GetFullPath($assetTarget)) {
    New-Item -ItemType Directory -Path $assetTarget -Force | Out-Null
    Copy-Item -LiteralPath (Join-Path $assetSource 'logo-black.png'),(Join-Path $assetSource 'logo.ico'),(Join-Path $assetSource 'logo-cim.png'),(Join-Path $assetSource 'logo-cim.ico') -Destination $assetTarget -Force
}
& (Join-Path $destination 'Manager.ps1') -Install

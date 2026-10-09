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
    foreach ($name in @('logo-black.png','instance-transparent.ico','logo-cim.png','manager-transparent.ico')) {
        $source = Join-Path $assetSource $name; $target = Join-Path $assetTarget $name
        if ((Test-Path -LiteralPath $target) -and (Get-FileHash -LiteralPath $source).Hash -eq (Get-FileHash -LiteralPath $target).Hash) { continue }
        Copy-Item -LiteralPath $source -Destination $target -Force
    }
}
# Remove only the obsolete importer installed by an earlier manager version.
$obsolete = Join-Path $destination 'Library.ps1'
if (Test-Path -LiteralPath $obsolete -PathType Leaf) { Remove-Item -LiteralPath $obsolete }
& (Join-Path $destination 'Manager.ps1') -Install

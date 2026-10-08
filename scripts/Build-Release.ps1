$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$version = [IO.File]::ReadAllText((Join-Path $root 'VERSION')).Trim()
$dist = Join-Path $root 'dist'
$stage = Join-Path $dist ('stage-' + [guid]::NewGuid().ToString('N'))
$package = Join-Path $stage 'Codex-Instance-Manager'
New-Item -ItemType Directory -Path (Join-Path $package 'assets') -Force | Out-Null
foreach ($file in Get-ChildItem -LiteralPath (Join-Path $root 'src') -File) { Copy-Item -LiteralPath $file.FullName -Destination $package }
Copy-Item -LiteralPath (Join-Path $root 'assets\logo-black.png'),(Join-Path $root 'assets\logo.ico'),(Join-Path $root 'assets\logo-cim.png'),(Join-Path $root 'assets\logo-cim.ico') -Destination (Join-Path $package 'assets')
Copy-Item -LiteralPath (Join-Path $root 'LICENSE'),(Join-Path $root 'README.md'),(Join-Path $root 'CHANGELOG.md') -Destination $package
$zip = Join-Path $dist 'Codex-Instance-Manager.zip'
Compress-Archive -LiteralPath $package -DestinationPath $zip -Force
$checksum = (Get-FileHash -LiteralPath $zip -Algorithm SHA256).Hash.ToLowerInvariant()
[IO.File]::WriteAllText((Join-Path $dist 'SHA256SUMS.txt'), ($checksum + '  Codex-Instance-Manager.zip' + "`n"), (New-Object Text.UTF8Encoding($false)))
Write-Output "Built release $version. ZIP: $zip"

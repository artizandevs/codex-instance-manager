$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
$root = Split-Path -Parent $PSScriptRoot
foreach ($asset in @(
    @{Source='logo-black.png'; Target='instance-transparent.ico'},
    @{Source='logo-cim.png'; Target='manager-transparent.ico'}
)) {
    $source = [Drawing.Image]::FromFile((Join-Path $root ('assets\' + $asset.Source)))
    $images = @()
    try {
        foreach ($size in @(16,24,32,48,64,128,256)) {
            $bitmap = New-Object Drawing.Bitmap($size,$size,[Drawing.Imaging.PixelFormat]::Format32bppArgb)
            $drawing = [Drawing.Graphics]::FromImage($bitmap)
            $memory = New-Object IO.MemoryStream
            try {
                $drawing.Clear([Drawing.Color]::Transparent)
                $drawing.CompositingMode = [Drawing.Drawing2D.CompositingMode]::SourceCopy
                $drawing.CompositingQuality = [Drawing.Drawing2D.CompositingQuality]::HighQuality
                $drawing.InterpolationMode = [Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
                $drawing.PixelOffsetMode = [Drawing.Drawing2D.PixelOffsetMode]::HighQuality
                $attributes = New-Object Drawing.Imaging.ImageAttributes
                try {
                    $attributes.SetWrapMode([Drawing.Drawing2D.WrapMode]::TileFlipXY)
                    $drawing.DrawImage($source,(New-Object Drawing.Rectangle(0,0,$size,$size)),0,0,$source.Width,$source.Height,[Drawing.GraphicsUnit]::Pixel,$attributes)
                } finally { $attributes.Dispose() }
                $bitmap.Save($memory,[Drawing.Imaging.ImageFormat]::Png)
                $images += @{Size=$size; Bytes=$memory.ToArray()}
            } finally { $memory.Dispose(); $drawing.Dispose(); $bitmap.Dispose() }
        }
    } finally { $source.Dispose() }
    $writer = New-Object IO.BinaryWriter([IO.File]::Create((Join-Path $root ('assets\' + $asset.Target))))
    try {
        $writer.Write([uint16]0); $writer.Write([uint16]1); $writer.Write([uint16]$images.Count)
        $offset = 6 + 16 * $images.Count
        foreach ($entry in $images) {
            $edge = if ($entry.Size -eq 256) { 0 } else { $entry.Size }
            $writer.Write([byte]$edge); $writer.Write([byte]$edge)
            $writer.Write([byte]0); $writer.Write([byte]0)
            $writer.Write([uint16]1); $writer.Write([uint16]32)
            $writer.Write([uint32]$entry.Bytes.Length); $writer.Write([uint32]$offset)
            $offset += $entry.Bytes.Length
        }
        foreach ($entry in $images) { $writer.Write([byte[]]$entry.Bytes) }
    } finally { $writer.Dispose() }
    Write-Output ('Built transparent icon: ' + $asset.Target + ' (16-256 px).')
}

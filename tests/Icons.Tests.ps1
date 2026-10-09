$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName PresentationCore, WindowsBase
$root = Split-Path -Parent $PSScriptRoot
foreach ($name in @('instance-transparent.ico','manager-transparent.ico')) {
    $reader = New-Object IO.BinaryReader([IO.File]::OpenRead((Join-Path $root ('assets\' + $name))))
    try {
        if ($reader.ReadUInt16() -ne 0 -or $reader.ReadUInt16() -ne 1 -or $reader.ReadUInt16() -ne 7) { throw "Invalid icon header: $name" }
        foreach ($size in @(16,24,32,48,64,128,256)) {
            $width = [int]$reader.ReadByte(); if (-not $width) { $width = 256 }
            $height = [int]$reader.ReadByte(); if (-not $height) { $height = 256 }
            [void]$reader.ReadUInt16(); [void]$reader.ReadUInt16()
            $bits = $reader.ReadUInt16(); $length = $reader.ReadUInt32(); $offset = $reader.ReadUInt32()
            if ($width -ne $size -or $height -ne $size -or $bits -ne 32) { throw "Missing icon size: $name/$size" }
            $next = $reader.BaseStream.Position
            $reader.BaseStream.Position = $offset
            $memory = New-Object IO.MemoryStream(,$reader.ReadBytes($length))
            try {
                $decoder = New-Object Windows.Media.Imaging.PngBitmapDecoder($memory,[Windows.Media.Imaging.BitmapCreateOptions]::PreservePixelFormat,[Windows.Media.Imaging.BitmapCacheOption]::OnLoad)
                $frame = New-Object Windows.Media.Imaging.FormatConvertedBitmap($decoder.Frames[0],[Windows.Media.PixelFormats]::Bgra32,$null,0)
                $pixels = New-Object byte[] ($size * $size * 4)
                $frame.CopyPixels($pixels,$size*4,0)
                foreach ($index in @(0,($size-1),(($size-1)*$size),($size*$size-1))) {
                    if ($pixels[$index*4+3] -ne 0) { throw "Opaque icon corner: $name/$size" }
                }
                $antialias = $false
                for ($i=3; $i -lt $pixels.Length; $i+=4) { if ($pixels[$i] -gt 0 -and $pixels[$i] -lt 255) { $antialias=$true; break } }
                if (-not $antialias) { throw "Jagged icon edges: $name/$size" }
            } finally { $memory.Dispose() }
            $reader.BaseStream.Position = $next
        }
    } finally { $reader.Dispose() }
}
Write-Output 'PASS: seven sizes per icon, transparent corners and antialiased edges.'

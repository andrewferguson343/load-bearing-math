# Regenerates the site's raster icons from assets/og/icon.html (the I-beam mark).
# Run from the repo root on Windows:  powershell -ExecutionPolicy Bypass -File assets/og/build-icons.ps1
#
#   priv/static/images/apple-touch-icon.png   180x180 (iOS home screen, some crawlers)
#   priv/static/favicon.ico                   16/32/48 px PNGs packed into one .ico
#
# Browsers that support SVG favicons use priv/static/images/favicon.svg instead.

Add-Type -AssemblyName System.Drawing

$edge = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
$root = (Get-Location).Path
$src = "file:///" + ((Join-Path $root "assets\og\icon.html") -replace '\\', '/')
$work = Join-Path $env:TEMP "lbm-icons"
New-Item -ItemType Directory -Force $work | Out-Null
$master = Join-Path $work "icon-512.png"
Remove-Item $master -ErrorAction SilentlyContinue

# Render once, large, with a transparent background. Edge writes harmless log lines to
# stderr, so run it through cmd and ignore that output.
cmd /c "`"$edge`" --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=1 --default-background-color=00000000 --window-size=512,512 --user-data-dir=`"$work\profile`" --screenshot=`"$master`" `"$src`" 2>nul"
if (-not (Test-Path $master)) { throw "Edge did not produce $master" }

function Resize-Png([string]$from, [int]$size) {
  $img = [System.Drawing.Image]::FromFile($from)
  $bmp = New-Object System.Drawing.Bitmap($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
  $g.Clear([System.Drawing.Color]::Transparent)
  $g.DrawImage($img, 0, 0, $size, $size)
  $ms = New-Object System.IO.MemoryStream
  $bmp.Save($ms, [System.Drawing.Imaging.ImageFormat]::Png)
  $g.Dispose(); $bmp.Dispose(); $img.Dispose()
  return , $ms.ToArray()
}

[System.IO.File]::WriteAllBytes((Join-Path $root "priv\static\images\apple-touch-icon.png"), (Resize-Png $master 180))

# ICO container: 6-byte header, one 16-byte directory entry per image, then the PNG bytes.
$sizes = 16, 32, 48
$pngs = foreach ($s in $sizes) { , (Resize-Png $master $s) }

$ms = New-Object System.IO.MemoryStream
$bw = New-Object System.IO.BinaryWriter($ms)
$bw.Write([UInt16]0); $bw.Write([UInt16]1); $bw.Write([UInt16]$sizes.Count)
$offset = 6 + 16 * $sizes.Count
for ($i = 0; $i -lt $sizes.Count; $i++) {
  $bw.Write([byte]$sizes[$i]); $bw.Write([byte]$sizes[$i])   # width, height
  $bw.Write([byte]0); $bw.Write([byte]0)                       # palette, reserved
  $bw.Write([UInt16]1); $bw.Write([UInt16]32)                  # planes, bits per pixel
  $bw.Write([UInt32]$pngs[$i].Length); $bw.Write([UInt32]$offset)
  $offset += $pngs[$i].Length
}
foreach ($png in $pngs) { $bw.Write($png) }
$bw.Flush()
[System.IO.File]::WriteAllBytes((Join-Path $root "priv\static\favicon.ico"), $ms.ToArray())

Write-Host "Wrote priv/static/images/apple-touch-icon.png and priv/static/favicon.ico"

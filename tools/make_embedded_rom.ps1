param(
    [Parameter(Mandatory=$true)][string]$InPath,
    [Parameter(Mandatory=$true)][string]$OutPath
)

if (-not (Test-Path $InPath)) {
    Write-Error "Input file '$InPath' not found"
    exit 1
}

$bytes = [System.IO.File]::ReadAllBytes($InPath)
$sb = New-Object System.Text.StringBuilder

#$header = "/* Generated from $InPath */"
$sb.AppendLine("/* Generated from $InPath */") | Out-Null
$sb.AppendLine('#define EMBEDDED_ROM_PRESENT 1') | Out-Null
$sb.AppendLine('#include <stdint.h>') | Out-Null
$sb.AppendLine('#include <stddef.h>') | Out-Null
$sb.AppendLine() | Out-Null
$sb.AppendLine('const unsigned char embedded_rom[] = {') | Out-Null

$lineBytes = 0
for ($i=0; $i -lt $bytes.Length; $i++) {
    if ($lineBytes -eq 0) { $sb.Append('    ') | Out-Null }
    $sb.AppendFormat("0x{0:X2}", $bytes[$i]) | Out-Null
    if ($i -lt $bytes.Length - 1) { $sb.Append(', ') | Out-Null }
    $lineBytes++
    if ($lineBytes -ge 16) { $sb.AppendLine() | Out-Null; $lineBytes = 0 }
}
if ($lineBytes -ne 0) { $sb.AppendLine() | Out-Null }

$sb.AppendLine('};') | Out-Null
$sb.AppendLine('const size_t embedded_rom_size = ' + $bytes.Length + ';') | Out-Null

# Ensure directory exists
$dir = Split-Path -Parent $OutPath
if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }

[System.IO.File]::WriteAllText($OutPath, $sb.ToString(), [System.Text.Encoding]::UTF8)
Write-Output "Generated $OutPath from $InPath"

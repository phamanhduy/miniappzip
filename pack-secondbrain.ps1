$src = 'E:\DUYCHUQUAN\WORKSPACE\OS\VIBECODE\miniappzip\javis-os'
$destZip = 'E:\DUYCHUQUAN\WORKSPACE\OS\VIBECODE\miniappzip\secondbrain.zip'
$backupZip = 'E:\DUYCHUQUAN\WORKSPACE\OS\VIBECODE\miniappzip\secondbrain.zip.bak'

if (Test-Path $destZip) {
    Copy-Item $destZip $backupZip -Force
    Remove-Item $destZip -Force
}

Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$zipStream = [System.IO.File]::Open($destZip, [System.IO.FileMode]::Create)
$archive = New-Object System.IO.Compression.ZipArchive($zipStream, [System.IO.Compression.ZipArchiveMode]::Create)

$files = Get-ChildItem -Path $src -Recurse -Force | Where-Object { 
    -not $_.PSIsContainer -and $_.FullName -notmatch '\\\.git(\\|$)'
}

$count = 0
foreach ($file in $files) {
    $relativePath = $file.FullName.Substring($src.Length).TrimStart('\', '/')
    $entryName = 'secondbrain/' + ($relativePath -replace '\\', '/')
    [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($archive, $file.FullName, $entryName, [System.IO.Compression.CompressionLevel]::Optimal) | Out-Null
    $count++
}

$archive.Dispose()
$zipStream.Dispose()

Write-Host "Đã đóng gói thành công $count files vào $destZip"
$size = (Get-Item $destZip).Length / 1MB
Write-Host "Kích thước file zip: $([Math]::Round($size, 2)) MB"


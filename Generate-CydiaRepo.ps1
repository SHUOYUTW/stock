param(
    [string]$PackageId = "com.yourname.iapstorage",
    [string]$Version = "0.0.1-3+debug",
    [string]$Architecture = "iphoneos-arm64",
    [string]$Maintainer = "YuShuo",
    [string]$Description = "IAP Storage Project for CyberSecurity.",
    [string]$Name = "IAPStorage"
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$debName = "${PackageId}_${Version}_${Architecture}.deb"
$debRelativePath = "debs/$debName"
$debPath = Join-Path $repoRoot $debRelativePath
$packagesPath = Join-Path $repoRoot "Packages"
$releasePath = Join-Path $repoRoot "Release"
$packagesBz2Path = Join-Path $repoRoot "Packages.bz2"

$release = @"
Origin: YuShuo Repo
Label: YuShuo Repo
Suite: stable
Version: 1.0
Codename: ios
Architectures: iphoneos-arm64
Components: main
Description: CyberSecurity Research Repo
"@
Set-Content -LiteralPath $releasePath -Value $release -Encoding ASCII

if (-not (Test-Path -LiteralPath $debPath)) {
    $packages = @"
Package: $PackageId
Version: $Version
Architecture: $Architecture
Maintainer: $Maintainer
Filename: $debRelativePath
Size: TODO_PLACE_DEB_IN_DEBS_FOLDER_AND_RUN_SCRIPT
MD5sum: TODO_PLACE_DEB_IN_DEBS_FOLDER_AND_RUN_SCRIPT
Description: $Description
Name: $Name
"@
    Set-Content -LiteralPath $packagesPath -Value $packages -Encoding ASCII
    Write-Warning "Missing .deb: $debPath"
    Write-Warning "Place the compiled .deb there, then run this script again."
} else {
    $size = (Get-Item -LiteralPath $debPath).Length
    $md5 = (Get-FileHash -LiteralPath $debPath -Algorithm MD5).Hash.ToLowerInvariant()
    $packages = @"
Package: $PackageId
Version: $Version
Architecture: $Architecture
Maintainer: $Maintainer
Filename: $debRelativePath
Size: $size
MD5sum: $md5
Description: $Description
Name: $Name
"@
    Set-Content -LiteralPath $packagesPath -Value $packages -Encoding ASCII
    Write-Host "Generated Packages for $debRelativePath"
    Write-Host "Size: $size bytes"
    Write-Host "MD5sum: $md5"
}

$python = Get-Command python -ErrorAction SilentlyContinue
if (-not $python) {
    $python = Get-Command py -ErrorAction SilentlyContinue
}

if (-not $python) {
    Write-Warning "Python was not found, so Packages.bz2 was not generated. Install Python or run: bzip2 -k -f Packages"
    exit 0
}

$compressCode = "import bz2; from pathlib import Path; src = Path(r'$packagesPath'); dst = Path(r'$packagesBz2Path'); dst.write_bytes(bz2.compress(src.read_bytes(), compresslevel=9)); print(f'Generated {dst}')"
& $python.Source -c $compressCode


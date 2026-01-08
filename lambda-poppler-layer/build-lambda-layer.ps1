# ============================
# Strict error handling
# ============================
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Fail {
    param ([string]$Message)
    Write-Host ""
    Write-Host "ERROR: $Message" -ForegroundColor Red
    exit 1
}

try {
    $ImageName = "poppler-layer"
    $Container = "poppler-temp"
    $OptDir    = "opt"
    $ZipFile   = "poppler-layer.zip"

    Write-Host "Building Docker image..."
    docker build -t $ImageName . | Out-Host
    if ($LASTEXITCODE -ne 0) { Fail "Docker build failed" }

    Write-Host "Creating temporary container..."
    docker create --name $Container $ImageName | Out-Null
    if ($LASTEXITCODE -ne 0) { Fail "Docker container creation failed" }

    Write-Host "Cleaning previous opt directory..."
    if (Test-Path $OptDir) {
        Remove-Item -Recurse -Force $OptDir
    }

    Write-Host "Copying /opt from container..."
    docker cp "${Container}:/opt" "./$OptDir"
    if ($LASTEXITCODE -ne 0) { Fail "Failed to copy /opt from container" }

    Write-Host "Removing temporary container..."
    docker rm $Container | Out-Null
    if ($LASTEXITCODE -ne 0) { Fail "Failed to remove temporary container" }

    Write-Host "Removing old zip (if exists)..."
    if (Test-Path $ZipFile) {
        Remove-Item -Force $ZipFile
    }

    Write-Host "Creating Lambda layer zip..."
    Compress-Archive -Path "$OptDir\*" -DestinationPath $ZipFile
    if (-not (Test-Path $ZipFile)) {
        Fail "ZIP file was not created"
    }

    Write-Host ""
    Write-Host "SUCCESS: Lambda layer created -> $ZipFile" -ForegroundColor Green
}
catch {
    Write-Host ""
    Write-Host "UNHANDLED ERROR:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

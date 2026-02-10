
$archivePath = "lib\_archive"
if (!(Test-Path -Path $archivePath)) {
    New-Item -ItemType Directory -Force -Path $archivePath
}

$itemsToMove = @(
    "lib\screens",
    "lib\widgets",
    "lib\services",
    "lib\models",
    "lib\themes",
    "lib\constants",
    "lib\auth",
    "lib\home_screen.dart",
    "lib\main.dart",
    "lib\pose_debug_screen.dart"
)

foreach ($item in $itemsToMove) {
    if (Test-Path -Path $item) {
        Write-Host "Moving $item to $archivePath..."
        Move-Item -Path $item -Destination $archivePath -Force
    } else {
        Write-Host "$item not found, skipping."
    }
}
Write-Host "Archiving complete."

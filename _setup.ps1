# Directory where the script is located
$scriptDir = $PSScriptRoot

# Install Font if Not Exists
$fontFile = Join-Path -Path $scriptDir -ChildPath "SauceCodeProNerdFont-SemiBold.ttf"
$fontFileName = "SauceCodeProNerdFont-SemiBold.ttf"
$fontsFolderPath = "C:\Windows\Fonts"
$destinationFontPath = Join-Path -Path $fontsFolderPath -ChildPath $fontFileName

if (-not (Test-Path $destinationFontPath)) {
    Copy-Item $fontFile $fontsFolderPath
    Write-Host "Font installed successfully."
} else {
    Write-Host "Font already installed."
}

# Overwrite Windows Terminal settings.json
$settingsJsonPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$sourceSettingsJson = Join-Path -Path $scriptDir -ChildPath "wt_settings.json"
if (Test-Path $sourceSettingsJson) {
    Copy-Item $sourceSettingsJson $settingsJsonPath -Force
} else {
    Write-Host "wt_settings.json not found in the script directory."
}

# Copy starship.toml to ~/.config/starship.toml
$configFolderPath = Join-Path -Path $HOME -ChildPath ".config"
if (-not (Test-Path $configFolderPath)) {
    New-Item -ItemType Directory -Path $configFolderPath
}
$starshipFilePath = Join-Path -Path $scriptDir -ChildPath "starship.toml"
if (Test-Path $starshipFilePath) {
    Copy-Item $starshipFilePath "$configFolderPath\starship.toml" -Force
} else {
    Write-Host "starship.toml not found in the script directory."
}

exit
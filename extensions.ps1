# List of extensions to install or upgrade
$extensions = @(
    "dracula-theme.theme-dracula",
    "ms-vscode.remote-explorer",
    "ms-azuretools.vscode-docker",
    "timkmecl.chatgpt",
    "innoverio.vscode-dbt-power-user",
    "samuelcolvin.jinjahtml",
    "redhat.vscode-yaml",
    "ms-python.python",
    "hashicorp.terraform",
    "hashicorp.hcl",
    "esbenp.prettier-vscode"
)

# Get the list of installed extensions and versions
$installedExtensions = (code --list-extensions --show-versions) -split [Environment]::NewLine

# Uninstall extensions that are not in the list
foreach ($installedExtension in $installedExtensions) {
    $extensionName = $installedExtension -split '@' | Select-Object -First 1
    if ($extensionName -notin $extensions) {
        Write-Host "Uninstalling $extensionName..."
        Start-Process code -ArgumentList "--uninstall-extension", "$extensionName" -Wait
        Write-Host "Uninstalled $extensionName."
    }
}

# Check and install or upgrade each extension
foreach ($extension in $extensions) {
    $extensionInfo = $installedExtensions | Where-Object { $_ -match "$extension" }
    if ($extensionInfo) {
        # Extension is installed; check for upgrades
        Write-Host "Checking for updates to $extension..."
        Start-Process code -ArgumentList "--install-extension", "$extension", "--force" -Wait
        Write-Host "Updated $extension to the latest version."
    } else {
        # Extension is not installed; install it
        Write-Host "Installing $extension..."
        Start-Process code -ArgumentList "--install-extension", "$extension" -Wait
        Write-Host "Installed $extension."
    }
}

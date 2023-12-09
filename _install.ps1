# Check if WSL is installed
if (Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux | Select-Object -ExpandProperty State -ErrorAction SilentlyContinue) {
    Write-Host "WSL is already installed."
} else {
    # Install WSL
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart
    # Restart the computer
    Restart-Computer -Force
}

# Check if Debian is installed
$debianInstalled = wsl -l | Where-Object { $_ -match 'Debian' }
if ($debianInstalled) {
    Write-Host "Debian is already installed in WSL."
} else {
    # Install Debian
    wsl --install -d Debian
    # Restart the computer
    Restart-Computer -Force
}


# List of programs to install or update
$programs = @(
    # "Elgato.StreamDeck",
    # "FocusriteAudioEngineeringLtd.FocusriteControl",
    "Chocolatey.Chocolatey",
    "Microsoft.AppInstaller",
    "Microsoft.VisualStudio.2022.Community",
    "Microsoft.VCRedist.2015+.x64",
    "Microsoft.VCRedist.2015+.x86",
    "Microsoft.WindowsSDK.10.0.22000",
    "Microsoft.WindowsTerminal",
    "Starship.Starship",
    "Docker.DockerDesktop",
    "Postman.Postman",
    "Google.CloudSDK",
    "SimbaTechnologies.SimbaODBCDriverforGoogleBigQuery",
    "Discord.Discord",
    "Flow-Launcher.Flow-Launcher",
    "GIMP.GIMP",
    "7zip.7zip",
    "Greenshot.Greenshot",
    "Valve.Steam",
    "Zoom.Zoom",
    "SlackTechnologies.Slack",
    "Logitech.GHUB",
    "VideoLAN.VLC",
    "Nvidia.GeForceExperience",
    "Nvidia.PhysX",
    "Google.Chrome",
    "WizardsoftheCoast.MTGALauncher"
)

# Prompt for App Installer Update
Write-Host "Please ensure that the App Installer is up to date for winget to work properly. Press any key after updating."
Start-Process "https://apps.microsoft.com/detail/9NBLGGH4NNS1?hl=en-us&gl=US"
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

foreach ($program in $programs) {
    $installed = winget list --id $program

    if ($installed -match $program) {
        # Program is installed, check for updates
        Write-Host "$program is already installed. Checking for updates..."
        winget upgrade --id $program -h --accept-source-agreements --include-unknown
    }
    else {
        # Program is not installed, proceed with installation
        Write-Host "$program is not installed. Installing..."
        winget install --id $program -h --accept-source-agreements
    }
}

# Update Chocolatey
choco upgrade chocolatey -y

# List of programs to install or update
$programs = @(
    "chocolatey",
    "chocolatey-core.extension",
    "chocolatey-compatibility.extension",
    "chocolatey-windowsupdate.extension",
    "cpu-z",
    "epicgameslauncher",
    "icue",
    "gh",
    "git",
    "gpu-z"
    "mingw",
    "notepadplusplus",
    "neovim",
    "nodejs",
    "code"
)

# Get list of installed Chocolatey packages
$installedPackages = choco list --local-only

foreach ($program in $programs) {
    if ($installedPackages -like "*$program*") {
        # Program is installed, check for updates
        Write-Host "$program is already installed. Checking for updates..."
        choco upgrade $program -y
    }
    else {
        # Program is not installed, proceed with installation
        Write-Host "$program is not installed. Installing..."
        choco install $program -y
    }
}

$installerPath = Join-Path -Path $PSScriptRoot -ChildPath "Battle.net-Setup.exe"
Start-Process -FilePath $installerPath -ArgumentList '--lang=enUS --installpath="C:\Program Files (x86)\Battle.net"' -Wait -NoNewWindow

# Load System.Windows.Forms for the MessageBox
Add-Type -AssemblyName System.Windows.Forms

# Display a message box when the script finishes
[System.Windows.Forms.MessageBox]::Show("Script execution has completed.", "Script Finished", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)

exit
# List of programs to install or update
$programs = @(
    "Chocolatey.Chocolatey",
    "Microsoft.AppInstaller",
    "Microsoft.VisualStudio.2022.Community",
    "Microsoft.DevHome",
    "Microsoft.VCRedist.2015+.x64",
    "Microsoft.VCRedist.2015+.x86",
    "Microsoft.CLRTypesSQLServer.2019",
    "Microsoft.VisualStudioCode",
    "Microsoft.WindowsSDK.10.0.22000",
    "Microsoft.WindowsTerminal",
    "Starship.Starship",
    "Docker.DockerDesktop",
    "Discord.Discord",
    "Flow-Launcher.Flow-Launcher",
    "FocusriteAudioEngineeringLtd.FocusriteControl",
    "GIMP.GIMP",
    "Google.CloudSDK",
    "Greenshot.Greenshot",
    "Postman.Postman",
    "Valve.Steam",
    "Zoom.Zoom",
    "SlackTechnologies.Slack",
    "7zip.7zip",
    "Elgato.StreamDeck",
    "SimbaTechnologies.SimbaODBCDriverforGoogleBigQuery",
    "Logitech.GHUB",
    "VideoLAN.VLC",
    "Nvidia.GeForceExperience",
    "Nvidia.PhysX",
    "Google.Chrome",
    "GitHub.cli",
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
        winget upgrade --id $program --silent --accept-source-agreements --include-unknown
    }
    else {
        # Program is not installed, proceed with installation
        Write-Host "$program is not installed. Installing..."
        winget install --id $program --silent --accept-source-agreements
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
    "git",
    "mingw",
    "notepadplusplus",
    "neovim",
    "nodejs"
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

Battle.net-Setup.exe --lang=enUS --installpath="C:\Program Files (x86)\Battle.net"

# Load System.Windows.Forms for the MessageBox
Add-Type -AssemblyName System.Windows.Forms

# Display a message box when the script finishes
[System.Windows.Forms.MessageBox]::Show("Script execution has completed.", "Script Finished", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)

exit
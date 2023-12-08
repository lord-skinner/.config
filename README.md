### Install/Update Applications


```powershell
# Open an elevated Powershell Prompt and run installs
Start-Process PowerShell -Verb RunAs -ArgumentList "-NoExit", "-Command", "& { (Join-Path $PWD '_install.ps1') | Invoke-Expression }"

# Run the setup script
Start-Process PowerShell -Verb RunAs -ArgumentList "-NoExit", "-Command", "& { (Join-Path $PWD '_setup.ps1') | Invoke-Expression }"
```

### Chris Titus Tech's Windows Utility

```powershell
irm https://christitus.com/win | iex
```
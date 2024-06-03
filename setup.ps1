#request administrator permissions
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Output "Please run this script with administrator privilege"
    exit
}

#choco
if (Get-Command choco -ErrorAction SilentlyContinue) {
    Write-Output "chocolatey already installed"
}
else {
    Write-Output "installing chocolatey"
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

#make refrenshenv available
$env:ChocolateyInstall = Convert-Path "$((Get-Command choco).Path)\..\.."   
Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"

#Git
if (Get-Command git -ErrorAction SilentlyContinue) {
    Write-Output "Git already installed"
}
else {
    Write-Output "installing git..."
    choco install git -y

}

#font
choco install jetbrainsmono -y

#VS Code
if (Get-Command code -ErrorAction SilentlyContinue) {
    Write-Output "VS Code already installed"
}
else {
    Write-Output "installing VS Code..."
    choco install vscode -y
    $roamingPath = [System.IO.Path]::Combine($env:APPDATA, "Code", "User")
    New-Item -ItemType Directory -Path $roamingPath -Force
}

#make code available
refreshenv

#config vs code
$scriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$vscodeSettingsPath = [System.IO.Path]::Combine($env:APPDATA, "Code", "User", "settings.json")
$vscodeKeybindingsPath = [System.IO.Path]::Combine($env:APPDATA, "Code", "User", "keybindings.json")

$settingsPath = Join-Path -Path $scriptDirectory -ChildPath "settings.json"

if (Test-Path $settingsPath) {
    $settingsContent = Get-Content $settingsPath -Raw
    $settingsContent | Out-File -FilePath $vscodeSettingsPath -Encoding utf8 -Force
    Write-Output "VS Code settings updated!"
} 
$keybindingsPath = Join-Path $scriptDirectory -ChildPath "keybindings.json"

if (Test-Path $keybindingsPath) {
    $keybindingsContent = Get-Content $keybindingsPath -Raw
    $keybindingsContent | Out-File -FilePath $vscodeKeybindingsPath -Encoding utf8 -Force
    Write-Output "VS Code keybindings updated!"
} 

#vim
code --install-extension vscodevim.vim
#icon theme
code --install-extension PKief.material-icon-theme
#theme
code --install-extension enkia.tokyo-night

#WSL
if (Get-Command wsl -ErrorAction SilentlyContinue) {
    Write-Output "WSL2 already installed"
}
else {
    Write-Output "Activating WSL feature..."
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    
    Write-Output "Activating virtual machine feature..."
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
    
    Write-Output "Downloading the last package for WSL 2 core..."
    $wslUpdateUrl = "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi"
    $wslUpdatePath = "$env:TEMP\wsl_update_x64.msi"
    Invoke-WebRequest -Uri $wslUpdateUrl -OutFile $wslUpdatePath
    
    Write-Output "Installing WSL2 last update..."
    Start-Process msiexec.exe -ArgumentList "/i $wslUpdatePath /quiet /norestart" -Wait
    
    Write-Output "Deleting WSL2 installer..."
    Remove-Item -Path $wslUpdatePath -Force
    
    Write-Output "Setting WSL2 as default version..."
    wsl --set-default-version 2
    
}

#Docker
if (Get-Command docker -ErrorAction SilentlyContinue) {
    Write-Output "docker already installed"
}
else {
    Write-Output "installing docker desktop..."
    choco install docker-desktop -y

}

#reboot and verify
Write-Output "installations complete, your computer will restart"
Restart-Computer -Force
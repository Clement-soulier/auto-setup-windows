$choco = $false
$git = $false
$font = $false
$code = $false
$vim = $false
$icon = $false
$theme = $false
$wsl = $false
$docker = $false

#choco
if (Get-Command choco -ErrorAction SilentlyContinue) {
    $choco = $true
}

#git
if (Get-Command git -ErrorAction SilentlyContinue) {
    $git = $true
    #config username
    $gitUserName = Read-Host "Please enter your git username"
    git config --global user.name $gitUserName
    #config e-mail
    $gitUserEmail = Read-Host "Please enter your git e-mail"
    git config --global user.email $gitUserEmail
}

#font
function Test-FontInstalled {
    param (
        [string]$fontName
    )

    $fontRegKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
    $fonts = Get-ItemProperty -Path $fontRegKey
    foreach ($fontInList in $fonts.PSObject.Properties) {
        if ($fontInList.Name -eq $fontName) {
            return $true
        }
    }
    
    return $false
}

$fontName = "JetBrains Mono Regular (TrueType)"

if (Test-FontInstalled -fontName $fontName) {
    $font = $true
} 

#code
if (Get-Command code -ErrorAction SilentlyContinue) {
    $code = $true 
}

#code extensions
$extensions = code --list-extensions
if ($extensions -contains "vscodevim.vim") {
    $vim = $true
}
if ($extensions -contains "PKief.material-icon-theme") {
    $icon = $true
}
if ($extensions -contains "enkia.tokyo-night") {
    $theme = $true
}

#wsl
if (Get-Command wsl -ErrorAction SilentlyContinue) {
    $wsl = $true
}

#docker
if (Get-Command docker -ErrorAction SilentlyContinue) {
    $docker = $true
}

#conclusion message
if ($git -and $code -and $vim -and $icon -and $theme -and $wsl -and $docker -and $choco -and $font) {
    Write-Output "Everything is installed!"
} else {
    Write-Output "The following components failed to install, please rerun the installation script or install them manually:"
    if (-not $choco) {
        Write-Output "chocolatey"
    }
    if (-not $git) {
        Write-Output "git"
    }
    if (-not $font) {
        Write-Output "$fontName"
    }
    if (-not $code) {
        Write-Output "vs code"
    }
    if (-not $vim) {
        Write-Output "vim extension for vs code"
    }
    if (-not $icon) {
        Write-Output "icon extension for vs code"
    }
    if (-not $theme) {
        Write-Output "theme extension for vs code"
    }
    if (-not $wsl) {
        Write-Output "WSL 2"
    }
    if (-not $docker) {
        Write-Output "docker"
    }
}
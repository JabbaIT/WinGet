<#
    .SYNOPSIS 
        This will install WinGet (Microsoft.DesktopAppInstaller) package

    .DESCRIPTION 
        This script will install WinGet (Microsoft.DesktopAppInstaller) onto Local Machine 

    .PARAMETER PackageURL 
        The URL of the Appx Installer
    
    .PARAMETER DownloadLocation
        The location of where to download Installer. 

    .EXAMPLE 
        .\Install-WinGet.ps1
            This will download and start the installation of WinGet (Microswoft.DesktopAppInstaller)

    .NOTES
        =================================
            Author: Jamie Price
            Date: 07/08/2022
            FileName: Install-WinGet.ps1
            Version = 1.1
        =================================
#>

[cmdletbinding()]
param(    
    [Parameter(Mandatory = $false)]       
    [string]$PackageUrl = "https://github.com/microsoft/winget-cli/releases/download/v1.3.2091/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle",

    [Parameter(Mandatory = $false)]       
    [string]$DownloadLocation = "$($env:USERPROFILE)\Downloads"    
)

Write-Verbose -Message "Checking Download Location $($DownloadLocation)"
if(!(Test-Path -Path $DownloadLocation)) {
    Write-Error -Message "Unable to find download location $($DownloadLocation)"
    return
}

Write-Verbose -Message "Downloading the WinGet Install"
try {
        
    Write-Verbose -Message "As the Installer already been downloaded?"
    if((Test-Path -Path "$($DownloadLocation)\WinGetAppInstaller.msixbundle" )) {
        
        $ifAppInstallerIsPresent = Read-Host "App Installer is already download, do you want to overwrite (Y/N)?"        
        
        Write-Verbose -Message "Responding to User Input"
        if($ifAppInstallerIsPresent -eq "Y") {            
            Write-Host "Redownloading Package" -ForegroundColor Yellow
            Invoke-WebRequest -Uri $PackageUrl -OutFile "$($DownloadLocation)\WinGetAppInstaller.msixbundle" -ErrorAction Stop
            Write-Host "Download Completed" -ForegroundColor Green
        }
        else {
            Write-Host "Continuing on with Installation" -ForegroundColor Green
        }        
    }
    else {
        Write-Host "Downloading App Installer" -ForegroundColor Green
        Invoke-WebRequest -Uri $PackageUrl -OutFile "$($DownloadLocation)\WinGetAppInstaller.msixbundle" -ErrorAction Stop
        Write-Host "Download Completed" -ForegroundColor Green
    }
}
catch {
    Write-Error -Message "Failed to download WinGet Installer" -Category OperationStopped
    return
}

Write-Verbose -Message "Install WinGet"
try {
    
    if(!(Get-AppPackage -Name "Microsoft.DesktopAppInstaller")) {
        Write-Verbose -Message "Installing Microsoft AppInsaller"
        Add-AppPackage -Path "$($DownloadLocation)\WinGetAppInstaller.msixbundle" -ErrorAction Stop      
        Write-Host "Microsoft.DesktopAppInstaller now installed" -ForegroundColor Green
    }
    else {

        $reinstall = Read-host "Do you wish to re-install Microsoft DesktopInstaller (Y/N)"
        if($reinstall.ToLower -eq "y") {
            Write-Verbose -Message "Installing Microsoft AppInsaller"
            Add-AppPackage -Path "$($DownloadLocation)\WinGetAppInstaller.msixbundle" -ErrorAction Stop      
            Write-Host "Microsoft.DesktopAppInstaller now installed" -ForegroundColor Green
        }
    }
}
catch {
    Write-Error -Message "Failed to install WinGet App Package"
    return
}

Write-Host "Installation Completed" -ForegroundColor Green
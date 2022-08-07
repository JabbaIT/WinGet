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
            Version = 1.0
        =================================
#>

[cmdletbinding()]
param(    

    #URL of WinGet (Microsoft.DesktopAppInstaller) package
    [Parameter(Mandatory = $false)]       
    [string]$PackageUrl = "https://github.com/microsoft/winget-cli/releases/download/v1.3.2091/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle",

    #Download location for WinGet (Microsoft.AppInstaller) package
    [Parameter(Mandatory = $false)]       
    [string]$DownloadLocation = "$($env:USERPROFILE)\Downloads"    
)

#Variables 
[bool]$freshInstall | out-null

Write-Verbose -Message "Checking Download Location $($DownloadLocation)"
if(!(Test-Path -Path $DownloadLocation)) {
    Write-Error -Message "Unable to find download location $($DownloadLocation)" -RecommendedAction "Check the download location is available"
    return
}

Write-Verbose -Message "Downloading the WinGet Install"
try {
        
    #Checking if WinGet (Microsoft.AppInstaller.msixbundle already downloaded)
    if((Test-Path -Path "$($DownloadLocation)\WinGetAppInstaller.msixbundle" )) {
        
        #Asking the User if want to re-download and overwrite
        $ifAppInstallerIsPresent = Read-Host "App Installer is already download, do you want to re-download overwrite (Y/N)?"                            
        if($ifAppInstallerIsPresent.ToLower -eq "y") {            
            
            Write-Host "Redownloading Package" -ForegroundColor Yellow
            Invoke-WebRequest -Uri $PackageUrl -OutFile "$($DownloadLocation)\WinGetAppInstaller.msixbundle" -ErrorAction Stop
            
            Write-Host "Download Completed" -ForegroundColor Green            
            $freshInstall = $true
        }
        else {
            Write-Host "Continuing on to next Step -> Installation" -ForegroundColor Green
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
    
    #Checking if WinGet (Microsoft.AppInstaller is already installed)
    if(!(Get-AppPackage -Name "Microsoft.DesktopAppInstaller")) {

        #Instaling WinGet (Microsoft.DesktopAppInstaller)
        Write-Verbose -Message "Installing Microsoft AppInsaller"
        Add-AppPackage -Path "$($DownloadLocation)\WinGetAppInstaller.msixbundle" -ErrorAction Stop      

        #Display Output Message
        Write-Host "Microsoft.DesktopAppInstaller now installed" -ForegroundColor Green
    }
    elseif(!$freshInstall) {

        #Asking User if want to re-install WinGet (Microsoft.DesktopAppInstall) package
        $reinstall = Read-host "Do you wish to re-install Microsoft DesktopInstaller (Y/N)"
        
        #Processing User Response
        if($reinstall.ToLower -eq "y") {

            Write-Verbose -Message "Re-Installing Microsoft AppInsaller"            
            Add-AppPackage -Path "$($DownloadLocation)\WinGetAppInstaller.msixbundle" -ErrorAction Stop      

            #Output Message
            Write-Host "Microsoft.DesktopAppInstaller now re-installed" -ForegroundColor Green
        }
    }
    else {
        Write-Host "Completing Installation" -ForegroundColor Green
    }
}
catch {
    Write-Error -Message "Failed to install WinGet App Package"
    return
}

#Script Completed
Write-Host "Installation Completed" -ForegroundColor Green
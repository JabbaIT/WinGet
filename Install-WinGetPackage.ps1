<#
    .SYNOPSIS 
        Install WinGet Package

    .DESCRIPTION
        Install Winget Packages 

    .PARAMETER PackageId
        The name of the package to install

    .PARAMETER AcceptAgreements
        Auto Accept the package Agreements

    .PARAMETER Scope
        Select if to install Package as User or Machine Level
        By Default it will install as User

    .EXAMPLE
        .\Install-WinGetPackage.ps1 -PackageId Google.Chrome
        This example will install Google Chrome

    .EXAMPLE
        .\Install-WinGetPackage.ps1 -PackageId Google.Chrome -AcceptAgreements
        This example will install Google Chrome and auto accept the agreements

    .EXAMPLE
        .\Install-WinGetPackage.ps1 -PackageId Google.Chrome -AcceptAgreements -Scope Machine
        This example will install Google Chrome and auto accept the agreements and install as Machine Level

    .NOTES
        =================================
            Author: Jamie Price
            Date: 26/07/2022
            FileName: Install-WinGetPackage.ps1
            Version = 1.1
        =================================
#>

[cmdletbinding()]
param(
    # PackageId Parameter    
    [parameter(Mandatory = $true, HelpMessage = "Enter in the name of the WinGet package to install", Position = 1)]
    [string]$PackageId, 

    # Auto Agreement Acceptance Switch
    [parameter(Mandatory = $false, Position = 2)]
    [switch]$AcceptAgreements, 

<<<<<<< HEAD
    # Scope of Installation
=======
>>>>>>> main
    [parameter(Mandatory = $false, HelpMessage = "Select if User or Machine Installation Scope", Position = 3)]
    [ValidateSet('User', 'Machine')]
    [string]$Scope = "User"
)

try {
    
    # As Accpet Agreement Switch enabled
    if(!$AcceptAgreements) {
        Write-Verbose -Message "Install WinGet Package $($PackageId)"
        
<<<<<<< HEAD
        # Is this going to be Machine Scope Install
=======
>>>>>>> main
        if($scope -eq "Machine" ) {
            Write-Verbose -Message "Install $($PackageId) as Machine"
            Start-Process -FilePath "WinGet" -ArgumentList "install -e --id $($PackageId) --scope Machine" -ErrorAction Stop -Wait -NoNewWindow
        }
        else {
            Write-Verbose -Message "Install $($PackageId) as User"
            Start-Process -FilePath "WinGet" -ArgumentList "install -e --id $($PackageId) --scope User" -ErrorAction Stop -Wait -NoNewWindow
        }
    } else {
        Write-Verbose -Message "Install WinGet Package $($PackageId) with Package Agreement Selected"
<<<<<<< HEAD
        # Is this going to be Machine Scope Install
=======

>>>>>>> main
        if($scope -eq "Machine" ) {        
            Write-Verbose -Message "Install $($PackageId) as Machine"
            Start-Process -FilePath "WinGet" -ArgumentList "install --id $($PackageId) --accept-package-agreements --scope Machine " -ErrorAction Stop -Wait -NoNewWindow
        }
        else {
            Write-Verbose -Message "Install $($PackageId) as User"
            Start-Process -FilePath "WinGet" -ArgumentList "install --id $($PackageId) --accept-package-agreements --scope User " -ErrorAction Stop -Wait -NoNewWindow
        }
    }

    # Todo - Look how to get output of install
    Write-Verbose -Message "Checking if the Package Installed"
    if($LASTEXITCODE -ne 0) 
    {
        Write-Host "$($PackageId) installed" -ForegroundColor Green
    }
}
catch {
    Write-Error -Message "Failed to install $($PackageId)" -Category NotInstalled
    return
}

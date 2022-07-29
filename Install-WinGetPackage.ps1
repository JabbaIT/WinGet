<#
    .SYNOPSIS 
        Install WinGet Package

    .DESCRIPTION
        Install Winget Packages 

    .PARAMETER PackageId
        The name of the package to install

    .PARAMETER AcceptAgreements
        Auto Accept the package Agreements

    .EXAMPLE
        .\Install-WinGetPackage.ps1 -PackageId Google.Chrome
        This example will install Google Chrome

    .EXAMPLE
        .\Install-WinGetPackage.ps1 -PackageId Google.Chrome -AcceptAgreements
        This example will install Google Chrome and auto accept the agreements

    .NOTES
        =================================
            Author: Jamie Price
            Date: 26/07/2022
            FileName: Install-WinGetPackage.ps1
            Version = 1.0
        =================================
#>

[cmdletbinding()]
param(
    [parameter(Mandatory = $true, HelpMessage = "Enter in the name of the WinGet package to install", Position = 1)]
    [string]$PackageId, 

    [parameter(Mandatory = $false, Position = 2)]
    [switch]$AcceptAgreements
)

try {
    
    if(!$AcceptAgreements) {
        Write-Verbose -Message "Install WinGet Package $($PackageId)"
        Start-Process -FilePath "WinGet" -ArgumentList "install -e --id $($PackageId)" -ErrorAction Stop -Wait -NoNewWindow
    } else {
        Write-Verbose -Message "Install WinGet Package $($PackageId) with Package Agreement Selected"
        Start-Process -FilePath "WinGet" -ArgumentList "install --id $($PackageId) --accept-package-agreements" -ErrorAction Stop -Wait -NoNewWindow
    }

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

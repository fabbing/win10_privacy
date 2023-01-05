<#
Copyright 2023 fabbing

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
version 3 as published by the Free Software Foundation.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.
#>

$RegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\"
$SvchostNetName = "svchost-net.exe"


function Configure-Service-Registry {
    [cmdletbinding()]
    param(
        [string]$ServiceName
    )
    
    Write-Verbose ("Configuring service [{0}]" -f $ServiceName)

    $ServicePath = Join-Path -Path $RegistryPath -ChildPath $ServiceName

    $ImagePathEntry = Get-ItemProperty -Path $ServicePath -Name ImagePath
    $CurrentPath = $ImagePathEntry.ImagePath
    $NewPath = $CurrentPath -creplace "svchost.exe", $SvchostNetName

    if ($CurrentPath -eq $NewPath) {
        Write-Verbose "Nothing to do"
        return $false
    }

    #Write-Verbose ("Current ImagePath: {0}" -f $CurrentPath)
    Write-Verbose ("Updated ImagePath: {0}" -f $NewPath)

    Set-ItemProperty -Path $ServicePath -Name "ImagePath" -Value $NewPath
    return $true
}


function My-Stop-Service {
    [cmdletbinding()]
    param(
        [string[]]$ServiceName
    )

    Write-Verbose ("Stopping service [{0}]" -f $ServiceName) # XXX
    Stop-Service -Name $ServiceName
}


function Configure-Service {
    [cmdletbinding()]
    param(
        [string]$ServiceName
    )

    if (Configure-Service-Registry -Verbose $ServiceName) {
        My-Stop-Service -Verbose $ServiceName
    }
}


function Configure-All-Services {
    [cmdletbinding()]
    param(
        [string[]]$ServiceNames
    )

    Write-Verbose "Configuring all services..."

    foreach ($ServiceName in $ServiceNames) {
        Configure-Service -Verbose $ServiceName
    }
    
    Write-Verbose "Done"
}
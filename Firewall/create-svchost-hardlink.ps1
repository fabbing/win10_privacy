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

$SvcHostNetName = "svchost-net.exe"

# File paths
$SvcHostDir = "C:\Windows\System32\"
$SvcHostPath = [System.String]::Concat($SvcHostDir,"svchost.exe")
$SvcHostNetPath = [System.String]::Concat($SvcHostDir,$SvcHostNetName)

function Show-ACL {
    param (
        [string] $File
    )
    $Acl = Get-Acl -Path $File

    Write-Host "File = " $File
    Write-Host "Owner = " $Acl.Owner
    $Acl.Access | Format-Table
}

# Users
$MyUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().User
$TrustedInstallerUser = New-Object System.Security.Principal.NTAccount("NT SERVICE\TrustedInstaller")


# Get svchost.exe ACL
$AclOrig = Get-Acl -Path $SvcHostPath
$AclTemp = Get-Acl -Path $SvcHostPath


# Debug
Show-ACL $SvcHostPath


# Allow current user full control
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($MyUser, "FullControl", "Allow")
$AclTemp.SetAccessRule($AccessRule)
# Change owner to current user
$AclTemp.SetOwner($MyUser)
# Apply ACL to svchost.exe
$AclTemp | Set-Acl -Path $SvcHostPath


# Create a hardlink
New-Item -ItemType HardLink -Path $SvcHostNetPath -Value $SvcHostPath


# Restore svchost.exe original ACL
$AclOrig | Set-Acl -Path $SvcHostPath


# Debug
Show-ACL $SvcHostPath
Show-ACL $SvcHostNetPath
#Get-ChildItem "toto-net.txt" | Format-List Name, Mode, ModeWithoutHardlink, LinkType
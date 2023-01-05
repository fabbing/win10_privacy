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

. "$PSScriptRoot\fw-services-common.ps1"

$AllServices = [string[]]("DoSvc", "BITS", "wuauserv", "NcaSvc")

Configure-All-Services -Verbose $AllServices
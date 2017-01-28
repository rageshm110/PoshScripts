<#
.SYNOPSIS
Get memory details of a remote server

.DESCRIPTION
Get the Availbale physical memory, FreePhysicalMemory, and Percerntage of Memory Usage remotely.

.PARAMETER ComputerName
Accepts a list of computer names or IP addresses

.EXAMPLE
Get-MemoryUsage -ComputerName computer1
Get-MemoryUsage -ComputerName computer1,computer2

.LINK
https://posh-scripting.blogspot.in/2016/10/memory-usage.html

#>

function Get-MemoryUsage{
    [CmdletBinding()]
    Param
    (
        # A computer name or list of computer names
        [Parameter(Mandatory=$False,ValueFromPipelineByPropertyName=$true,Position=0)]
        [string[]]$ComputerName = 'localhost'
    )
    $result = @()
    foreach ($computer in $ComputerName){
        $memory = Get-WmiObject -class win32_operatingsystem -ComputerName $computer | `
        Select-Object @{n='ComputerName';e={$_.PSComputerName}},
        @{n='TotalMemory GB';e={"{0:N2}" -f [int]($_.TotalVisibleMemorySize / 1MB)}},
        @{n='FreePhysicalMemory GB';e={"{0:N2}" -f ($_.FreePhysicalMemory / 1MB)}},
        @{n='% MemoryUsage'; e={"{0:N2}" -f ((($_.TotalVisibleMemorySize - `
        $_.FreePhysicalMemory)/$_.TotalVisibleMemorySize)*100)}} #| Format-List
        $result += $memory
        }
    $result
}

Get-MemoryUsage
function Get-SecWAPs
{

    <#
    Synopsis
    To use each workstation as a sensor, by checking for available wireless networks and comparing it to the baseline of networks
    This works with CSIS Control 7 Wireless Device Control
    #>

    [CmdletBinding()]
    param(
        [Switch]$CreateBaseline
    )

    $computer = Get-Content Env:\COMPUTERNAME
    $filename = Get-DateISO8601 -Prefix ".\$computer-WAPS" -Suffix ".xml"


    netsh wlan show network | Export-Clixml $filename

    if($CreateBaseline)
    {
        Rename-Item $filename "$computer-WAP-Baseline.xml"
        Move-Item ".\$computer-WAP-Baseline.xml" .\Baselines
        if(Test-Path ".\Baselines\$computer-WAP-Baseline.xml"){
   		Write-Warning "The baseline file for this computer has been created, running this script again."
        	Invoke-Expression $MyInvocation.MyCommand
        }
	    
    }
    else
    {
        Compare-SecWAPs
    }

    
}

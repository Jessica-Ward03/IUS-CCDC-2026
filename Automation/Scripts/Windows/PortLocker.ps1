$AllowedPorts = @(50,25,110,587,8089,9997,8000,636,88,464,3269,1801,2107,21)   # Port Whitelist
$Profile = "Any"                     

Set-NetFirewallProfile -Profile $Profile -DefaultInboundAction Block


Get-NetFirewallRule |
    Where-Object {
        $_.Direction -eq "Inbound" -and
        $_.Action -eq "Allow" -and
        $_.Enabled -eq "True"
    } |
    Remove-NetFirewallRule

#allow for whitelisted ports
foreach ($Port in $AllowedPorts) {
    New-NetFirewallRule `
        -DisplayName "Allow Port $Port" `
        -Direction Inbound `
        -Action Allow `
        -Protocol TCP `
        -LocalPort $Port `
        -Profile $Profile `
        -Enabled True
}

Write-Host "Inbound firewall locked down."
Write-Host "Allowed ports:" ($AllowedPorts -join ", ")

$Profile = "Any"   # Domain, Private, Public, or Any

Set-NetFirewallProfile `
    -Profile $Profile `
    -DefaultInboundAction Allow `
    -DefaultOutboundAction Allow


Get-NetFirewallRule |
    Where-Object {
        $_.DisplayName -like "Allow Port *" -and
        $_.Direction -eq "Inbound"
    } |
    Remove-NetFirewallRule
Write-Host "Firewall settings restored."
Write-Host "Default inbound/outbound traffic is now allowed."

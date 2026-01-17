while (&true){
    Get-Localuser| Select Name, Enabled, Lastlogon, Description
    Start-Sleep 300 seconds
}
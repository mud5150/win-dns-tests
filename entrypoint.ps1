# Zone has to be created at runtime since the container server name is set at runtime
Add-DnsServerPrimaryZone -name $env:AD_DOMAIN -ZoneFile $env:AD_DOMAIN
$env:AD_SERVER = $env:COMPUTERNAME
Invoke-Expression "$args"
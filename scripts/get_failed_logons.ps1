<# Exports failed logon events (ID 4625) from the Security log to CSV. Run as administrator. #>
param(
  [int]$Max = 200,
  [string]$Out = ".\failed_logons.csv"
)

Get-WinEvent -FilterHashtable @{ LogName = 'Security'; Id = 4625 } -MaxEvents $Max |
  ForEach-Object {
    $xml = [xml]$_.ToXml()
    $d = @{}
    $xml.Event.EventData.Data | ForEach-Object { $d[$_.Name] = $_.'#text' }
    [pscustomobject]@{
      Time      = $_.TimeCreated.ToString("s")
      User      = $d['TargetUserName']
      Source    = $d['IpAddress']
      LogonType = $d['LogonType']
    }
  } | Export-Csv $Out -NoTypeInformation -Encoding UTF8

Write-Host "Exported to $Out"

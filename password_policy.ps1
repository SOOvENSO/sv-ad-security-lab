<# Sets the default domain password and lockout policy. Run on the DC. #>
param([string]$DnsName = "sv.local")

Import-Module ActiveDirectory
Set-ADDefaultDomainPasswordPolicy -Identity $DnsName `
  -MinPasswordLength 12 `
  -ComplexityEnabled $true `
  -MaxPasswordAge (New-TimeSpan -Days 90) `
  -LockoutThreshold 5 `
  -LockoutDuration (New-TimeSpan -Minutes 15) `
  -LockoutObservationWindow (New-TimeSpan -Minutes 15)

Get-ADDefaultDomainPasswordPolicy -Identity $DnsName

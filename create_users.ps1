<#
Creates the lab OU structure, two groups, an IT admin account and employees from a CSV.
Run on the domain controller (ActiveDirectory module required).
All names are fictional. Passwords are typed at run time and never stored.
#>
param(
  [string]$DomainDN = "DC=sv,DC=local",
  [string]$DnsName  = "sv.local",
  [string]$CsvPath  = ".\users.csv"
)

Import-Module ActiveDirectory
$empPwd = Read-Host "Lab password for employee accounts" -AsSecureString
$admPwd = Read-Host "Lab password for khalidaslaoui" -AsSecureString

foreach ($ou in "Employees", "IT", "Groups") {
  if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$ou'")) {
    New-ADOrganizationalUnit -Name $ou -Path $DomainDN
  }
}

foreach ($g in "Employees-Group", "IT-Support") {
  if (-not (Get-ADGroup -Filter "Name -eq '$g'")) {
    New-ADGroup -Name $g -GroupScope Global -GroupCategory Security -Path "OU=Groups,$DomainDN"
  }
}

if (-not (Get-ADUser -Filter "SamAccountName -eq 'khalidaslaoui'")) {
  New-ADUser -Name "khalidaslaoui" -SamAccountName "khalidaslaoui" -UserPrincipalName "khalidaslaoui@$DnsName" `
    -Path "OU=IT,$DomainDN" -AccountPassword $admPwd -Enabled $true
}
Add-ADGroupMember -Identity "IT-Support" -Members "khalidaslaoui"

Import-Csv $CsvPath | ForEach-Object {
  if (-not (Get-ADUser -Filter "SamAccountName -eq '$($_.Sam)'")) {
    New-ADUser -Name "$($_.First) $($_.Last)" -GivenName $_.First -Surname $_.Last `
      -SamAccountName $_.Sam -UserPrincipalName "$($_.Sam)@$DnsName" `
      -Path "OU=Employees,$DomainDN" -AccountPassword $empPwd `
      -ChangePasswordAtLogon $true -Enabled $true
  }
  Add-ADGroupMember -Identity "Employees-Group" -Members $_.Sam
}

<#
Enables auditing of logon-related events (run as administrator).
Subcategory names are localized. On a non-English Windows, list yours with:
  auditpol /list /subcategory:*
#>
$subs = "Logon", "Account Lockout", "Credential Validation", "User Account Management"
foreach ($s in $subs) {
  auditpol /set /subcategory:"$s" /success:enable /failure:enable
}
auditpol /get /category:*

# create array to store users
$users = @()

# create array to store groups
$groups = @(
"itq it cinisello home","ITH it padova home"
)

# loop each group for members
foreach ($group in $groups)
{
    $members = Get-ADGroupMember $group
    foreach ($member in $members)
    {
        $user = Get-ADUser $member -Properties name, samaccountname, PasswordNeverExpires, PasswordExpired, Passwordlastset, UserPrincipalName
        $users += $user
    }
}

# output desired properties
$users | select samaccountname, name , passwordexpired, passwordlastset,UserPrincipalName 
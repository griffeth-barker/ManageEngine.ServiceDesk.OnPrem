function New-SDPOrgUser {
    <#
    .SYNOPSIS
        Creates a new org user in ServiceDesk Plus.
    .PARAMETER Name
        Full name of the org user.
    .PARAMETER FirstName
        First name.
    .PARAMETER MiddleName
        Middle name.
    .PARAMETER LastName
        Last name.
    .PARAMETER LoginName
        Login/username.
    .PARAMETER Password
        Password for the new user.
    .PARAMETER EmailId
        Primary email address.
    .PARAMETER Phone
        Phone number.
    .PARAMETER Mobile
        Mobile number.
    .PARAMETER JobTitle
        Job title.
    .PARAMETER EmployeeId
        Employee ID.
    .PARAMETER IsVipUser
        Mark the user as a VIP user.
    .PARAMETER DepartmentId
        ID of the department to associate.
    .PARAMETER ReportingToId
        ID of the user this org user reports to.
    .EXAMPLE
        New-SDPOrgUser -Name 'Jane Smith' -LoginName 'jsmith' -EmailId 'jsmith@example.com'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPOrgUser')]
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter()]
        [string]$FirstName,

        [Parameter()]
        [string]$MiddleName,

        [Parameter()]
        [string]$LastName,

        [Parameter()]
        [string]$LoginName,

        [Parameter()]
        [string]$Password,

        [Parameter()]
        [string]$EmailId,

        [Parameter()]
        [string]$Phone,

        [Parameter()]
        [string]$Mobile,

        [Parameter()]
        [string]$JobTitle,

        [Parameter()]
        [string]$EmployeeId,

        [Parameter()]
        [switch]$IsVipUser,

        [Parameter()]
        [string]$DepartmentId,

        [Parameter()]
        [string]$ReportingToId
    )

    $body = @{ name = $Name }

    if ($PSBoundParameters.ContainsKey('FirstName'))    { $body['first_name']   = $FirstName }
    if ($PSBoundParameters.ContainsKey('MiddleName'))   { $body['middle_name']  = $MiddleName }
    if ($PSBoundParameters.ContainsKey('LastName'))     { $body['last_name']    = $LastName }
    if ($PSBoundParameters.ContainsKey('LoginName'))    { $body['login_name']   = $LoginName }
    if ($PSBoundParameters.ContainsKey('Password'))     { $body['password']     = $Password }
    if ($PSBoundParameters.ContainsKey('EmailId'))      { $body['email_id']     = $EmailId }
    if ($PSBoundParameters.ContainsKey('Phone'))        { $body['phone']        = $Phone }
    if ($PSBoundParameters.ContainsKey('Mobile'))       { $body['mobile']       = $Mobile }
    if ($PSBoundParameters.ContainsKey('JobTitle'))     { $body['jobtitle']     = $JobTitle }
    if ($PSBoundParameters.ContainsKey('EmployeeId'))   { $body['employee_id']  = $EmployeeId }
    if ($PSBoundParameters.ContainsKey('IsVipUser'))    { $body['is_vipuser']   = $IsVipUser.IsPresent }
    if ($PSBoundParameters.ContainsKey('DepartmentId')) { $body['department']   = @{ id = $DepartmentId } }
    if ($PSBoundParameters.ContainsKey('ReportingToId')) { $body['reporting_to'] = @{ id = $ReportingToId } }

    if ($PSCmdlet.ShouldProcess($Name, 'Create SDP Org User')) {
        $response = Invoke-SDPRestMethod -Endpoint 'orgusers' -Method POST -Body @{ orguser = $body }
        [SDPOrgUser]::new($response.orguser)
    }
}

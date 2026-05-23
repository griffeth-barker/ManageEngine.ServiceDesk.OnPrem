function New-SDPUser {
    <#
    .SYNOPSIS
        Creates a new user (requester) in ServiceDesk Plus.
    .PARAMETER Name
        Full name of the user.
    .PARAMETER FirstName
        First name.
    .PARAMETER MiddleName
        Middle name.
    .PARAMETER LastName
        Last name.
    .PARAMETER LoginName
        Login/username.
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
    .PARAMETER Description
        Description or notes about the user.
    .PARAMETER IsVipUser
        Mark the user as a VIP user.
    .PARAMETER DepartmentId
        ID of the department to associate.
    .PARAMETER ReportingToId
        ID of the user this user reports to.
    .EXAMPLE
        New-SDPUser -Name 'John Doe' -LoginName 'jdoe' -EmailId 'jdoe@example.com'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPUser')]
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
        [string]$Description,

        [Parameter()]
        [switch]$IsVipUser,

        [Parameter()]
        [string]$DepartmentId,

        [Parameter()]
        [string]$ReportingToId
    )

    $body = @{ name = $Name }

    if ($PSBoundParameters.ContainsKey('FirstName'))     { $body['first_name']   = $FirstName }
    if ($PSBoundParameters.ContainsKey('MiddleName'))    { $body['middle_name']  = $MiddleName }
    if ($PSBoundParameters.ContainsKey('LastName'))      { $body['last_name']    = $LastName }
    if ($PSBoundParameters.ContainsKey('LoginName'))     { $body['login_name']   = $LoginName }
    if ($PSBoundParameters.ContainsKey('EmailId'))       { $body['email_id']     = $EmailId }
    if ($PSBoundParameters.ContainsKey('Phone'))         { $body['phone']        = $Phone }
    if ($PSBoundParameters.ContainsKey('Mobile'))        { $body['mobile']       = $Mobile }
    if ($PSBoundParameters.ContainsKey('JobTitle'))      { $body['jobtitle']     = $JobTitle }
    if ($PSBoundParameters.ContainsKey('EmployeeId'))    { $body['employee_id']  = $EmployeeId }
    if ($PSBoundParameters.ContainsKey('Description'))   { $body['description']  = $Description }
    if ($PSBoundParameters.ContainsKey('IsVipUser'))     { $body['is_vipuser']   = $IsVipUser.IsPresent }
    if ($PSBoundParameters.ContainsKey('DepartmentId'))  { $body['department']   = @{ id = $DepartmentId } }
    if ($PSBoundParameters.ContainsKey('ReportingToId')) { $body['reporting_to'] = @{ id = $ReportingToId } }

    if ($PSCmdlet.ShouldProcess($Name, 'Create SDP User')) {
        $response = Invoke-SDPRestMethod -Endpoint 'users' -Method POST -Body @{ user = $body }
        [SDPUser]::new($response.user)
    }
}

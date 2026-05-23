function Set-SDPUser {
    <#
    .SYNOPSIS
        Updates an existing user in ServiceDesk Plus.
    .PARAMETER Id
        The ID of the user to update.
    .PARAMETER Name
        Full name.
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
        Description or notes.
    .PARAMETER IsVipUser
        Mark the user as a VIP user.
    .PARAMETER DepartmentId
        ID of the department to associate.
    .PARAMETER ReportingToId
        ID of the user this user reports to.
    .EXAMPLE
        Set-SDPUser -Id '12345' -JobTitle 'Team Lead'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPUser')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id,

        [Parameter()]
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
        [bool]$IsVipUser,

        [Parameter()]
        [string]$DepartmentId,

        [Parameter()]
        [string]$ReportingToId
    )

    process {
        $body = @{}

        if ($PSBoundParameters.ContainsKey('Name'))          { $body['name']         = $Name }
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
        if ($PSBoundParameters.ContainsKey('IsVipUser'))     { $body['is_vipuser']   = $IsVipUser }
        if ($PSBoundParameters.ContainsKey('DepartmentId'))  { $body['department']   = @{ id = $DepartmentId } }
        if ($PSBoundParameters.ContainsKey('ReportingToId')) { $body['reporting_to'] = @{ id = $ReportingToId } }

        if ($PSCmdlet.ShouldProcess("User $Id", 'Update SDP User')) {
            $response = Invoke-SDPRestMethod -Endpoint "users/$Id" -Method PUT -Body @{ user = $body }
            [SDPUser]::new($response.user)
        }
    }
}

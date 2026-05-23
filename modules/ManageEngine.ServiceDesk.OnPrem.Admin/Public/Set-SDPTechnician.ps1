function Set-SDPTechnician {
    <#
    .SYNOPSIS
        Updates an existing technician in ServiceDesk Plus.
    .PARAMETER Id
        The ID of the technician to update.
    .PARAMETER Name
        Full name.
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
        Mark the technician as a VIP user.
    .PARAMETER DepartmentId
        ID of the department to associate.
    .PARAMETER ReportingToId
        ID of the technician this person reports to.
    .EXAMPLE
        Set-SDPTechnician -Id '12345' -Phone '555-0100'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPTechnician')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id,

        [Parameter()]
        [string]$Name,

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
        [bool]$IsVipUser,

        [Parameter()]
        [string]$DepartmentId,

        [Parameter()]
        [string]$ReportingToId
    )

    process {
        $body = @{}

        if ($PSBoundParameters.ContainsKey('Name'))          { $body['name']         = $Name }
        if ($PSBoundParameters.ContainsKey('EmailId'))       { $body['email_id']     = $EmailId }
        if ($PSBoundParameters.ContainsKey('Phone'))         { $body['phone']        = $Phone }
        if ($PSBoundParameters.ContainsKey('Mobile'))        { $body['mobile']       = $Mobile }
        if ($PSBoundParameters.ContainsKey('JobTitle'))      { $body['jobtitle']     = $JobTitle }
        if ($PSBoundParameters.ContainsKey('EmployeeId'))    { $body['employee_id']  = $EmployeeId }
        if ($PSBoundParameters.ContainsKey('IsVipUser'))     { $body['is_vipuser']   = $IsVipUser }
        if ($PSBoundParameters.ContainsKey('DepartmentId'))  { $body['department']   = @{ id = $DepartmentId } }
        if ($PSBoundParameters.ContainsKey('ReportingToId')) { $body['reporting_to'] = @{ id = $ReportingToId } }

        if ($PSCmdlet.ShouldProcess("Technician $Id", 'Update SDP Technician')) {
            $response = Invoke-SDPRestMethod -Endpoint "technicians/$Id" -Method PUT -Body @{ technician = $body }
            [SDPTechnician]::new($response.technician)
        }
    }
}

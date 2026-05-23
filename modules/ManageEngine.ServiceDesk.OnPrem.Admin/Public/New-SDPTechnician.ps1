function New-SDPTechnician {
    <#
    .SYNOPSIS
        Creates a new technician in ServiceDesk Plus.
    .PARAMETER Name
        Full name of the technician.
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
        New-SDPTechnician -Name 'Bob Jones' -EmailId 'bjones@example.com'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPTechnician')]
    param(
        [Parameter(Mandatory)]
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
        [switch]$IsVipUser,

        [Parameter()]
        [string]$DepartmentId,

        [Parameter()]
        [string]$ReportingToId
    )

    $body = @{ name = $Name }

    if ($PSBoundParameters.ContainsKey('EmailId'))       { $body['email_id']     = $EmailId }
    if ($PSBoundParameters.ContainsKey('Phone'))         { $body['phone']        = $Phone }
    if ($PSBoundParameters.ContainsKey('Mobile'))        { $body['mobile']       = $Mobile }
    if ($PSBoundParameters.ContainsKey('JobTitle'))      { $body['jobtitle']     = $JobTitle }
    if ($PSBoundParameters.ContainsKey('EmployeeId'))    { $body['employee_id']  = $EmployeeId }
    if ($PSBoundParameters.ContainsKey('IsVipUser'))     { $body['is_vipuser']   = $IsVipUser.IsPresent }
    if ($PSBoundParameters.ContainsKey('DepartmentId'))  { $body['department']   = @{ id = $DepartmentId } }
    if ($PSBoundParameters.ContainsKey('ReportingToId')) { $body['reporting_to'] = @{ id = $ReportingToId } }

    if ($PSCmdlet.ShouldProcess($Name, 'Create SDP Technician')) {
        $response = Invoke-SDPRestMethod -Endpoint 'technicians' -Method POST -Body @{ technician = $body }
        [SDPTechnician]::new($response.technician)
    }
}

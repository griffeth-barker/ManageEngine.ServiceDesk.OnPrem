function New-SDPDepartment {
    <#
    .SYNOPSIS
        Creates a new department in ServiceDesk Plus.
    .PARAMETER Name
        Name of the department.
    .PARAMETER Description
        Description of the department.
    .PARAMETER DepartmentHeadId
        ID of the user who heads this department.
    .PARAMETER SiteId
        ID of the site to associate.
    .EXAMPLE
        New-SDPDepartment -Name 'Engineering' -Description 'Software engineering teams'
    .EXAMPLE
        New-SDPDepartment -Name 'IT' -DepartmentHeadId '5' -SiteId '3'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPDepartment')]
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter()]
        [string]$Description,

        [Parameter()]
        [string]$DepartmentHeadId,

        [Parameter()]
        [string]$SiteId
    )

    $body = @{ name = $Name }

    if ($PSBoundParameters.ContainsKey('Description'))     { $body['description']      = $Description }
    if ($PSBoundParameters.ContainsKey('DepartmentHeadId')) { $body['department_head'] = @{ id = $DepartmentHeadId } }
    if ($PSBoundParameters.ContainsKey('SiteId'))          { $body['site']             = @{ id = $SiteId } }

    if ($PSCmdlet.ShouldProcess($Name, 'Create SDP Department')) {
        $response = Invoke-SDPRestMethod -Endpoint 'departments' -Method POST -Body @{ department = $body }
        [SDPDepartment]::new($response.department)
    }
}

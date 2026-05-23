function Set-SDPDepartment {
    <#
    .SYNOPSIS
        Updates an existing department in ServiceDesk Plus.
    .PARAMETER Id
        The ID of the department to update.
    .PARAMETER Name
        New name.
    .PARAMETER Description
        New description.
    .PARAMETER DepartmentHeadId
        ID of the user who heads this department.
    .PARAMETER SiteId
        ID of the site to associate.
    .EXAMPLE
        Set-SDPDepartment -Id '2' -Description 'Software engineering and DevOps'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPDepartment')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id,

        [Parameter()]
        [string]$Name,

        [Parameter()]
        [string]$Description,

        [Parameter()]
        [string]$DepartmentHeadId,

        [Parameter()]
        [string]$SiteId
    )

    process {
        $body = @{}

        if ($PSBoundParameters.ContainsKey('Name'))             { $body['name']             = $Name }
        if ($PSBoundParameters.ContainsKey('Description'))      { $body['description']      = $Description }
        if ($PSBoundParameters.ContainsKey('DepartmentHeadId')) { $body['department_head']  = @{ id = $DepartmentHeadId } }
        if ($PSBoundParameters.ContainsKey('SiteId'))           { $body['site']             = @{ id = $SiteId } }

        if ($PSCmdlet.ShouldProcess("Department $Id", 'Update SDP Department')) {
            $response = Invoke-SDPRestMethod -Endpoint "departments/$Id" -Method PUT -Body @{ department = $body }
            [SDPDepartment]::new($response.department)
        }
    }
}

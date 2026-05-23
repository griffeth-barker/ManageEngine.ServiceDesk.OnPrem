function Convert-SDPUserToTechnician {
    <#
    .SYNOPSIS
        Converts a user (requester) to a technician in ServiceDesk Plus.
    .PARAMETER Id
        The ID of the user to promote to technician.
    .EXAMPLE
        Convert-SDPUserToTechnician -Id '12345'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("User $Id", 'Convert SDP User to Technician')) {
            Invoke-SDPRestMethod -Endpoint "users/$Id/change_as_technician" -Method PUT -Body @{ technician = @{} }
        }
    }
}

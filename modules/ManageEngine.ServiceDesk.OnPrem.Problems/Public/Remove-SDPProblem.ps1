function Remove-SDPProblem {
    <#
    .SYNOPSIS
        Permanently deletes a problem from ServiceDesk Plus.
    .PARAMETER Id
        The ID of the problem to delete.
    .EXAMPLE
        Remove-SDPProblem -Id '12345'
    .EXAMPLE
        Get-SDPProblem -Id '12345' | Remove-SDPProblem
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Problem $Id", 'Permanently delete SDP Problem')) {
            Invoke-SDPRestMethod -Endpoint "problems/$Id" -Method DELETE
        }
    }
}

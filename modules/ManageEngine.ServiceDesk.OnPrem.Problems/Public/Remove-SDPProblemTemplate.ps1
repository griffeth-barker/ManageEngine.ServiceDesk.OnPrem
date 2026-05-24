function Remove-SDPProblemTemplate {
    <#
    .SYNOPSIS
        Deletes a problem template from ServiceDesk Plus.
    .PARAMETER Id
        The ID of the template to delete.
    .EXAMPLE
        Remove-SDPProblemTemplate -Id '5'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Problem Template $Id", 'Delete SDP Problem Template')) {
            Invoke-SDPRestMethod -Endpoint "problem_templates/$Id" -Method DELETE
        }
    }
}

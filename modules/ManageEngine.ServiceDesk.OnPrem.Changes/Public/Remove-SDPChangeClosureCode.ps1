function Remove-SDPChangeClosureCode {
    <#
    .SYNOPSIS
        Deletes a change closure code from ServiceDesk Plus.
    .PARAMETER Id
        The ID of the closure code to delete.
    .EXAMPLE
        Remove-SDPChangeClosureCode -Id '1'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    if ($PSCmdlet.ShouldProcess("Closure code $Id", 'Delete SDP Change closure code')) {
        Invoke-SDPRestMethod -Endpoint "change_closure_codes/$Id" -Method DELETE
    }
}

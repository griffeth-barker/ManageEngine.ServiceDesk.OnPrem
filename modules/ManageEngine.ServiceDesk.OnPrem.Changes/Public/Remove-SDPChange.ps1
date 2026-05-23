function Remove-SDPChange {
    <#
    .SYNOPSIS
        Removes a change from ServiceDesk Plus.
    .DESCRIPTION
        By default, moves the change to the trash (soft delete, reversible with Restore-SDPChange).
        Use -Permanent to hard-delete the change instead.
    .PARAMETER Id
        The ID of the change to remove.
    .PARAMETER Permanent
        When specified, permanently deletes the change instead of moving it to the trash.
    .EXAMPLE
        Remove-SDPChange -Id '12345'
    .EXAMPLE
        Remove-SDPChange -Id '12345' -Permanent
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id,

        [Parameter()]
        [switch]$Permanent
    )

    process {
        if ($Permanent) {
            if ($PSCmdlet.ShouldProcess("Change $Id", 'Permanently delete SDP Change')) {
                Invoke-SDPRestMethod -Endpoint "changes/$Id" -Method DELETE
            }
        } else {
            if ($PSCmdlet.ShouldProcess("Change $Id", 'Move SDP Change to trash')) {
                Invoke-SDPRestMethod -Endpoint "changes/$Id/move_to_trash" -Method DELETE
            }
        }
    }
}

function Remove-SDPCategory {
    <#
    .SYNOPSIS
        Removes a category from ServiceDesk Plus.
    .PARAMETER Id
        The ID of the category to remove.
    .EXAMPLE
        Remove-SDPCategory -Id '10'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Category $Id", 'Remove SDP Category')) {
            Invoke-SDPRestMethod -Endpoint "categories/$Id" -Method DELETE
        }
    }
}

function Remove-SDPSubcategory {
    <#
    .SYNOPSIS
        Removes a subcategory from ServiceDesk Plus.
    .PARAMETER Id
        The ID of the subcategory to remove.
    .EXAMPLE
        Remove-SDPSubcategory -Id '50'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Subcategory $Id", 'Remove SDP Subcategory')) {
            Invoke-SDPRestMethod -Endpoint "subcategories/$Id" -Method DELETE
        }
    }
}

function Set-SDPChangeClosureRule {
    <#
    .SYNOPSIS
        Updates a change closure rule in ServiceDesk Plus.
    .PARAMETER Id
        The ID of the closure rule to update.
    .PARAMETER AdditionalFields
        Hashtable of fields to update on the closure rule.
    .EXAMPLE
        Set-SDPChangeClosureRule -Id '1' -AdditionalFields @{ is_mandatory = $true }
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id,

        [Parameter(Mandatory)]
        [hashtable]$AdditionalFields
    )

    if ($PSCmdlet.ShouldProcess("Closure rule $Id", 'Update SDP Change closure rule')) {
        $response = Invoke-SDPRestMethod -Endpoint "change_closure_rules/$Id" -Method PUT -Body @{ change_closure_rule = $AdditionalFields }
        $response.change_closure_rule
    }
}

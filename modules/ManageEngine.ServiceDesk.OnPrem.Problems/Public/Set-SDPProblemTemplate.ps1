function Set-SDPProblemTemplate {
    <#
    .SYNOPSIS
        Updates a problem template in ServiceDesk Plus.
    .PARAMETER Id
        The ID of the template to update.
    .PARAMETER Name
        Updated template name.
    .PARAMETER Description
        Updated description.
    .PARAMETER AdditionalFields
        Hashtable of additional fields to merge into the request body.
    .EXAMPLE
        Set-SDPProblemTemplate -Id '5' -Name 'Network Outage Investigation v2'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id,

        [Parameter()]
        [string]$Name,

        [Parameter()]
        [string]$Description,

        [Parameter()]
        [hashtable]$AdditionalFields
    )

    process {
        $body = @{}

        if ($PSBoundParameters.ContainsKey('Name'))        { $body['name']        = $Name }
        if ($PSBoundParameters.ContainsKey('Description')) { $body['description'] = $Description }

        if ($AdditionalFields) {
            foreach ($key in $AdditionalFields.Keys) { $body[$key] = $AdditionalFields[$key] }
        }

        if ($PSCmdlet.ShouldProcess("Problem Template $Id", 'Update SDP Problem Template')) {
            $response = Invoke-SDPRestMethod -Endpoint "problem_templates/$Id" -Method PUT -Body @{ problem_template = $body }
            $response.problem_template
        }
    }
}

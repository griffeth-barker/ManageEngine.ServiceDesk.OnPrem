function New-SDPProblemTemplate {
    <#
    .SYNOPSIS
        Creates a new problem template in ServiceDesk Plus.
    .PARAMETER Name
        The name of the template.
    .PARAMETER Description
        Description of the template.
    .PARAMETER AdditionalFields
        Hashtable of additional fields to include in the request body.
    .EXAMPLE
        New-SDPProblemTemplate -Name 'Network Outage Investigation' -Description 'Standard template for network outage problems.'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter()]
        [string]$Description,

        [Parameter()]
        [hashtable]$AdditionalFields
    )

    $body = @{ name = $Name }

    if ($PSBoundParameters.ContainsKey('Description')) { $body['description'] = $Description }

    if ($AdditionalFields) {
        foreach ($key in $AdditionalFields.Keys) { $body[$key] = $AdditionalFields[$key] }
    }

    if ($PSCmdlet.ShouldProcess($Name, 'Create SDP Problem Template')) {
        $response = Invoke-SDPRestMethod -Endpoint 'problem_templates' -Method POST -Body @{ problem_template = $body }
        $response.problem_template
    }
}

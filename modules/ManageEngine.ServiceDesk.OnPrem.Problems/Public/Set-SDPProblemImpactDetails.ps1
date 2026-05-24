function Set-SDPProblemImpactDetails {
    <#
    .SYNOPSIS
        Updates the impact details for a ServiceDesk Plus problem.
    .PARAMETER ProblemId
        The ID of the problem.
    .PARAMETER Id
        The ID of the impact details entry to update.
    .PARAMETER Content
        Updated description of the business or service impact.
    .PARAMETER AdditionalFields
        Hashtable of additional fields to merge into the request body.
    .EXAMPLE
        Set-SDPProblemImpactDetails -ProblemId '12345' -Id '1' -Content 'Now affecting 350 users after additional sites reported issues.'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ProblemId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id,

        [Parameter()]
        [string]$Content,

        [Parameter()]
        [hashtable]$AdditionalFields
    )

    process {
        $body = @{}
        if ($PSBoundParameters.ContainsKey('Content')) { $body['description'] = $Content }

        if ($AdditionalFields) {
            foreach ($key in $AdditionalFields.Keys) { $body[$key] = $AdditionalFields[$key] }
        }

        if ($PSCmdlet.ShouldProcess("Impact details $Id on Problem $ProblemId", 'Update impact details')) {
            $response = Invoke-SDPRestMethod -Endpoint "problems/$ProblemId/impact_details/$Id" -Method PUT -Body @{ impact_details = $body }
            $response.impact_details
        }
    }
}

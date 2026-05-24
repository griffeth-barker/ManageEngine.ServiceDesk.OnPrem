function Add-SDPProblemImpactDetails {
    <#
    .SYNOPSIS
        Adds impact details to a ServiceDesk Plus problem.
    .PARAMETER ProblemId
        The ID of the problem.
    .PARAMETER Content
        Description of the business or service impact.
    .PARAMETER AdditionalFields
        Hashtable of additional fields to include in the request body.
    .EXAMPLE
        Add-SDPProblemImpactDetails -ProblemId '12345' -Content 'Email services unavailable for 200 users across three sites.'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ProblemId,

        [Parameter(Mandatory)]
        [string]$Content,

        [Parameter()]
        [hashtable]$AdditionalFields
    )

    process {
        $body = @{ description = $Content }

        if ($AdditionalFields) {
            foreach ($key in $AdditionalFields.Keys) { $body[$key] = $AdditionalFields[$key] }
        }

        if ($PSCmdlet.ShouldProcess("Problem $ProblemId", 'Add impact details')) {
            $response = Invoke-SDPRestMethod -Endpoint "problems/$ProblemId/impact_details" -Method POST -Body @{ impact_details = $body }
            $response.impact_details
        }
    }
}

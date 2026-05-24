function Get-SDPProblemImpactDetails {
    <#
    .SYNOPSIS
        Retrieves the impact details for a ServiceDesk Plus problem.
    .PARAMETER ProblemId
        The ID of the problem.
    .EXAMPLE
        Get-SDPProblemImpactDetails -ProblemId '12345'
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ProblemId
    )

    process {
        $response = Invoke-SDPRestMethod -Endpoint "problems/$ProblemId/impact_details"
        $response.impact_details
    }
}

function Get-SDPProblemSymptoms {
    <#
    .SYNOPSIS
        Retrieves the symptoms recorded for a ServiceDesk Plus problem.
    .PARAMETER ProblemId
        The ID of the problem.
    .EXAMPLE
        Get-SDPProblemSymptoms -ProblemId '12345'
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ProblemId
    )

    process {
        $response = Invoke-SDPRestMethod -Endpoint "problems/$ProblemId/symptoms"
        $response.symptoms
    }
}

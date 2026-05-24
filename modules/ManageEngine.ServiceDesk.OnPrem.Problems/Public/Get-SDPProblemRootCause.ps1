function Get-SDPProblemRootCause {
    <#
    .SYNOPSIS
        Retrieves the root cause analysis for a ServiceDesk Plus problem.
    .PARAMETER ProblemId
        The ID of the problem.
    .EXAMPLE
        Get-SDPProblemRootCause -ProblemId '12345'
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ProblemId
    )

    process {
        $response = Invoke-SDPRestMethod -Endpoint "problems/$ProblemId/root_cause"
        $response.root_cause
    }
}

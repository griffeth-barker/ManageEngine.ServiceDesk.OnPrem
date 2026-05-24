function Get-SDPProblemAssociation {
    <#
    .SYNOPSIS
        Retrieves associations for a ServiceDesk Plus problem.
    .PARAMETER ProblemId
        The ID of the problem.
    .PARAMETER Type
        The type of association to retrieve: Incident or Change.
    .EXAMPLE
        Get-SDPProblemAssociation -ProblemId '12345' -Type Incident
    .EXAMPLE
        Get-SDPProblemAssociation -ProblemId '12345' -Type Change
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ProblemId,

        [Parameter(Mandatory)]
        [ValidateSet('Incident', 'Change')]
        [string]$Type
    )

    process {
        $endpointMap = @{
            Incident = 'associated_incidents'
            Change   = 'associated_change'
        }
        $responseKey = @{
            Incident = 'associated_requests'
            Change   = 'associated_change'
        }

        $endpoint = "problems/$ProblemId/$($endpointMap[$Type])"
        $response = Invoke-SDPRestMethod -Endpoint $endpoint
        $response.($responseKey[$Type])
    }
}

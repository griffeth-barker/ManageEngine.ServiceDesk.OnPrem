function Get-SDPChangeAssociation {
    <#
    .SYNOPSIS
        Retrieves associations (requests, problems, projects) for a ServiceDesk Plus change.
    .PARAMETER ChangeId
        The ID of the change.
    .PARAMETER Type
        The type of association to retrieve:
          InitiatedRequest    - requests initiated by this change
          InitiatedByRequest  - requests that caused/initiated this change
          Problem             - problems associated with this change
          Project             - projects associated with this change
    .PARAMETER PageSize
        Number of records per page (1–100). Defaults to 100.
    .PARAMETER StartIndex
        1-based starting index. Defaults to 1.
    .PARAMETER All
        Automatically pages through all results.
    .EXAMPLE
        Get-SDPChangeAssociation -ChangeId '12345' -Type Problem
    .EXAMPLE
        Get-SDPChangeAssociation -ChangeId '12345' -Type InitiatedRequest -All
    #>
    [CmdletBinding(DefaultParameterSetName = 'List')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ChangeId,

        [Parameter(Mandatory)]
        [ValidateSet('InitiatedRequest', 'InitiatedByRequest', 'Problem', 'Project')]
        [string]$Type,

        [Parameter(ParameterSetName = 'List')]
        [ValidateRange(1, 100)]
        [int]$PageSize = 100,

        [Parameter(ParameterSetName = 'List')]
        [int]$StartIndex = 1,

        [Parameter(ParameterSetName = 'List')]
        [switch]$All
    )

    $endpointMap = @{
        InitiatedRequest   = 'initiated_requests'
        InitiatedByRequest = 'initiated_by_requests'
        Problem            = 'problems'
        Project            = 'projects'
    }
    $endpoint = "changes/$ChangeId/$($endpointMap[$Type])"

    process {
        $listInfo = @{ row_count = $PageSize }

        if ($All) {
            $index = $StartIndex
            do {
                $listInfo['start_index'] = $index
                $response = Invoke-SDPRestMethod -Endpoint $endpoint -InputData @{ list_info = $listInfo }
                $response
                $index += $PageSize
            } while ($response.list_info.has_more_rows)
        } else {
            $listInfo['start_index'] = $StartIndex
            Invoke-SDPRestMethod -Endpoint $endpoint -InputData @{ list_info = $listInfo }
        }
    }
}

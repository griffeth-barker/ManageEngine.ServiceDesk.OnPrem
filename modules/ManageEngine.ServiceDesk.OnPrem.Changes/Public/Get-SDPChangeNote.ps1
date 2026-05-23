function Get-SDPChangeNote {
    <#
    .SYNOPSIS
        Retrieves notes for a ServiceDesk Plus change.
    .PARAMETER ChangeId
        The ID of the parent change.
    .PARAMETER Id
        The ID of a specific note to retrieve.
    .PARAMETER PageSize
        Number of records per page (1–100). Defaults to 100.
    .PARAMETER StartIndex
        1-based starting index for the page. Defaults to 1.
    .PARAMETER All
        Automatically pages through all results.
    .EXAMPLE
        Get-SDPChangeNote -ChangeId '12345'
    .EXAMPLE
        Get-SDPChangeNote -ChangeId '12345' -Id '67890'
    #>
    [CmdletBinding(DefaultParameterSetName = 'List')]
    [OutputType('SDPChangeNote')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ChangeId,

        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [string]$Id,

        [Parameter(ParameterSetName = 'List')]
        [ValidateRange(1, 100)]
        [int]$PageSize = 100,

        [Parameter(ParameterSetName = 'List')]
        [int]$StartIndex = 1,

        [Parameter(ParameterSetName = 'List')]
        [switch]$All
    )

    process {
        if ($PSCmdlet.ParameterSetName -eq 'Id') {
            $response = Invoke-SDPRestMethod -Endpoint "changes/$ChangeId/notes/$Id"
            [SDPChangeNote]::new($ChangeId, $response.note)
            return
        }

        $listInfo = @{ row_count = $PageSize }

        if ($All) {
            $index = $StartIndex
            do {
                $listInfo['start_index'] = $index
                $response = Invoke-SDPRestMethod -Endpoint "changes/$ChangeId/notes" -InputData @{ list_info = $listInfo }
                foreach ($n in $response.notes) { [SDPChangeNote]::new($ChangeId, $n) }
                $index += $PageSize
            } while ($response.list_info.has_more_rows)
        } else {
            $listInfo['start_index'] = $StartIndex
            $response = Invoke-SDPRestMethod -Endpoint "changes/$ChangeId/notes" -InputData @{ list_info = $listInfo }
            foreach ($n in $response.notes) { [SDPChangeNote]::new($ChangeId, $n) }
        }
    }
}

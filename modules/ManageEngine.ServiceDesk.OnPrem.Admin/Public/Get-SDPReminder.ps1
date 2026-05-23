function Get-SDPReminder {
    <#
    .SYNOPSIS
        Retrieves one or more reminders from ServiceDesk Plus.
    .PARAMETER Id
        The ID of the reminder to retrieve.
    .PARAMETER PageSize
        Number of records per page (1–100). Defaults to 100.
    .PARAMETER StartIndex
        1-based starting index for the page. Defaults to 1.
    .PARAMETER All
        Automatically pages through all results.
    .EXAMPLE
        Get-SDPReminder -Id '10'
    .EXAMPLE
        Get-SDPReminder -All
    #>
    [CmdletBinding(DefaultParameterSetName = 'List')]
    [OutputType('SDPReminder')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
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
            $response = Invoke-SDPRestMethod -Endpoint "reminders/$Id"
            [SDPReminder]::new($response.reminder)
            return
        }

        $listInfo = @{ row_count = $PageSize }

        if ($All) {
            $index = $StartIndex
            do {
                $listInfo['start_index'] = $index
                $response = Invoke-SDPRestMethod -Endpoint 'reminders' -InputData @{ list_info = $listInfo }
                foreach ($r in $response.reminders) { [SDPReminder]::new($r) }
                $index += $PageSize
            } while ($response.list_info.has_more_rows)
        } else {
            $listInfo['start_index'] = $StartIndex
            $response = Invoke-SDPRestMethod -Endpoint 'reminders' -InputData @{ list_info = $listInfo }
            foreach ($r in $response.reminders) { [SDPReminder]::new($r) }
        }
    }
}

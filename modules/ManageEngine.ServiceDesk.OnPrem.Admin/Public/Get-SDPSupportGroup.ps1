function Get-SDPSupportGroup {
    <#
    .SYNOPSIS
        Retrieves one or more support groups from ServiceDesk Plus.
    .PARAMETER Id
        The ID of the support group to retrieve.
    .PARAMETER PageSize
        Number of records per page (1–100). Defaults to 100.
    .PARAMETER StartIndex
        1-based starting index for the page. Defaults to 1.
    .PARAMETER All
        Automatically pages through all results and returns every support group.
    .EXAMPLE
        Get-SDPSupportGroup -Id '7'
    .EXAMPLE
        Get-SDPSupportGroup -All
    #>
    [CmdletBinding(DefaultParameterSetName = 'List')]
    [OutputType('SDPSupportGroup')]
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
            $response = Invoke-SDPRestMethod -Endpoint "support_groups/$Id"
            [SDPSupportGroup]::new($response.support_group)
            return
        }

        $listInfo = @{ row_count = $PageSize }

        if ($All) {
            $index = $StartIndex
            do {
                $listInfo['start_index'] = $index
                $response = Invoke-SDPRestMethod -Endpoint 'support_groups' -InputData @{ list_info = $listInfo }
                foreach ($g in $response.support_groups) { [SDPSupportGroup]::new($g) }
                $index += $PageSize
            } while ($response.list_info.has_more_rows)
        } else {
            $listInfo['start_index'] = $StartIndex
            $response = Invoke-SDPRestMethod -Endpoint 'support_groups' -InputData @{ list_info = $listInfo }
            foreach ($g in $response.support_groups) { [SDPSupportGroup]::new($g) }
        }
    }
}

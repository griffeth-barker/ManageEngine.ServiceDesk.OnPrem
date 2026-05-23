function New-SDPChangeNote {
    <#
    .SYNOPSIS
        Adds a note to a change in ServiceDesk Plus.
    .PARAMETER ChangeId
        The ID of the change.
    .PARAMETER Description
        The content of the note.
    .PARAMETER ShowToRequester
        When specified, the note is visible to the requester.
    .EXAMPLE
        New-SDPChangeNote -ChangeId '12345' -Description 'CAB approval obtained.'
    .EXAMPLE
        New-SDPChangeNote -ChangeId '12345' -Description 'Implementation underway.' -ShowToRequester
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPChangeNote')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ChangeId,

        [Parameter(Mandatory)]
        [string]$Description,

        [Parameter()]
        [switch]$ShowToRequester
    )

    process {
        $body = @{ description = $Description }
        if ($ShowToRequester) { $body['show_to_requester'] = $true }

        if ($PSCmdlet.ShouldProcess("Change $ChangeId", 'Add note to SDP Change')) {
            $response = Invoke-SDPRestMethod -Endpoint "changes/$ChangeId/notes" -Method POST -Body @{ note = $body }
            [SDPChangeNote]::new($ChangeId, $response.note)
        }
    }
}

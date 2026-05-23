function Set-SDPChangeNote {
    <#
    .SYNOPSIS
        Updates a note on a ServiceDesk Plus change.
    .PARAMETER ChangeId
        The ID of the parent change.
    .PARAMETER Id
        The ID of the note to update.
    .PARAMETER Description
        Updated note content.
    .PARAMETER ShowToRequester
        Updated visibility flag.
    .EXAMPLE
        Set-SDPChangeNote -ChangeId '12345' -Id '1' -Description 'Updated note content.'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPChangeNote')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ChangeId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id,

        [Parameter()]
        [string]$Description,

        [Parameter()]
        [bool]$ShowToRequester
    )

    process {
        $body = @{}
        if ($PSBoundParameters.ContainsKey('Description'))    { $body['description']       = $Description }
        if ($PSBoundParameters.ContainsKey('ShowToRequester')) { $body['show_to_requester'] = $ShowToRequester }

        if ($PSCmdlet.ShouldProcess("Note $Id on Change $ChangeId", 'Update SDP Change note')) {
            $response = Invoke-SDPRestMethod -Endpoint "changes/$ChangeId/notes/$Id" -Method PUT -Body @{ note = $body }
            [SDPChangeNote]::new($ChangeId, $response.note)
        }
    }
}

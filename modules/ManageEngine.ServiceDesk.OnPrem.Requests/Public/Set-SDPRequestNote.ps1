function Set-SDPRequestNote {
    <#
    .SYNOPSIS
        Updates a note on a ServiceDesk Plus request.
    .PARAMETER RequestId
        The ID of the parent request.
    .PARAMETER Id
        The ID of the note to update.
    .PARAMETER Description
        Updated note content.
    .PARAMETER ShowToRequester
        Whether the note should be visible to the requester.
    .EXAMPLE
        Set-SDPRequestNote -RequestId '12345' -Id '67890' -Description 'Updated note text.'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPRequestNote')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$RequestId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id,

        [Parameter()]
        [string]$Description,

        [Parameter()]
        [bool]$ShowToRequester
    )

    process {
        $body = @{}

        if ($PSBoundParameters.ContainsKey('Description'))     { $body['description']       = $Description }
        if ($PSBoundParameters.ContainsKey('ShowToRequester')) { $body['show_to_requester'] = $ShowToRequester }

        if ($PSCmdlet.ShouldProcess("Note $Id on Request $RequestId", 'Update SDP Request Note')) {
            $response = Invoke-SDPRestMethod -Endpoint "requests/$RequestId/notes/$Id" -Method PUT -Body @{ note = $body }
            [SDPRequestNote]::new($RequestId, $response.note)
        }
    }
}

function Set-SDPProblemNote {
    <#
    .SYNOPSIS
        Updates a note on a ServiceDesk Plus problem.
    .PARAMETER ProblemId
        The ID of the parent problem.
    .PARAMETER Id
        The ID of the note to update.
    .PARAMETER Description
        Updated content of the note.
    .PARAMETER ShowToRequester
        When specified, the note is made visible to the requester.
    .EXAMPLE
        Set-SDPProblemNote -ProblemId '12345' -Id '67890' -Description 'Updated analysis complete.'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPProblemNote')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ProblemId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id,

        [Parameter()]
        [string]$Description,

        [Parameter()]
        [bool]$ShowToRequester
    )

    process {
        $body = @{}
        if ($PSBoundParameters.ContainsKey('Description'))    { $body['description']      = $Description }
        if ($PSBoundParameters.ContainsKey('ShowToRequester')) { $body['show_to_requester'] = $ShowToRequester }

        if ($PSCmdlet.ShouldProcess("Note $Id on Problem $ProblemId", 'Update SDP Problem note')) {
            $response = Invoke-SDPRestMethod -Endpoint "problems/$ProblemId/notes/$Id" -Method PUT -Body @{ note = $body }
            [SDPProblemNote]::new($ProblemId, $response.note)
        }
    }
}

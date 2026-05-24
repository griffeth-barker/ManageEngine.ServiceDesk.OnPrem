function New-SDPProblemNote {
    <#
    .SYNOPSIS
        Adds a note to a problem in ServiceDesk Plus.
    .PARAMETER ProblemId
        The ID of the problem.
    .PARAMETER Description
        The content of the note.
    .PARAMETER ShowToRequester
        When specified, the note is visible to the requester.
    .EXAMPLE
        New-SDPProblemNote -ProblemId '12345' -Description 'Root cause identified as misconfigured DNS.'
    .EXAMPLE
        New-SDPProblemNote -ProblemId '12345' -Description 'Workaround applied.' -ShowToRequester
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPProblemNote')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ProblemId,

        [Parameter(Mandatory)]
        [string]$Description,

        [Parameter()]
        [switch]$ShowToRequester
    )

    process {
        $body = @{ description = $Description }
        if ($ShowToRequester) { $body['show_to_requester'] = $true }

        if ($PSCmdlet.ShouldProcess("Problem $ProblemId", 'Add note to SDP Problem')) {
            $response = Invoke-SDPRestMethod -Endpoint "problems/$ProblemId/notes" -Method POST -Body @{ note = $body }
            [SDPProblemNote]::new($ProblemId, $response.note)
        }
    }
}

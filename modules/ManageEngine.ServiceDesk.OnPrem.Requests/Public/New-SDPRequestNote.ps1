function New-SDPRequestNote {
    <#
    .SYNOPSIS
        Adds a note to a ServiceDesk Plus request.
    .PARAMETER RequestId
        The ID of the request to add the note to.
    .PARAMETER Description
        The content of the note.
    .PARAMETER ShowToRequester
        When specified, the note is visible to the requester. Defaults to false.
    .PARAMETER MarkFirstResponse
        Marks this note as the first response to the requester.
    .PARAMETER AddToLinkedRequests
        Adds the note to all requests linked to this one.
    .EXAMPLE
        New-SDPRequestNote -RequestId '12345' -Description 'Investigating the issue.'
    .EXAMPLE
        New-SDPRequestNote -RequestId '12345' -Description 'Resolved.' -ShowToRequester
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPRequestNote')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$RequestId,

        [Parameter(Mandatory)]
        [string]$Description,

        [Parameter()]
        [switch]$ShowToRequester,

        [Parameter()]
        [switch]$MarkFirstResponse,

        [Parameter()]
        [switch]$AddToLinkedRequests
    )

    process {
        $body = @{
            description       = $Description
            show_to_requester = $ShowToRequester.IsPresent
        }

        if ($MarkFirstResponse)    { $body['mark_first_response']       = $true }
        if ($AddToLinkedRequests)  { $body['add_to_linked_requests']    = $true }

        if ($PSCmdlet.ShouldProcess("Request $RequestId", 'Add SDP Request Note')) {
            $response = Invoke-SDPRestMethod -Endpoint "requests/$RequestId/notes" -Method POST -Body @{ note = $body }
            [SDPRequestNote]::new($RequestId, $response.note)
        }
    }
}

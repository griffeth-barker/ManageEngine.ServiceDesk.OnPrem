function Deny-SDPApproval {
    <#
    .SYNOPSIS
        Rejects a pending approval on a ServiceDesk Plus request.
    .PARAMETER RequestId
        The ID of the request.
    .PARAMETER LevelNumber
        The approval level number.
    .PARAMETER ApprovalId
        The ID of the approval to act on.
    .PARAMETER Comments
        Optional comments to include with the rejection.
    .EXAMPLE
        Deny-SDPApproval -RequestId '12345' -LevelNumber 1 -ApprovalId '1' -Comments 'Missing business justification.'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory)]
        [string]$RequestId,

        [Parameter(Mandatory)]
        [int]$LevelNumber,

        [Parameter(Mandatory)]
        [string]$ApprovalId,

        [Parameter()]
        [string]$Comments
    )

    $body = @{}
    if ($PSBoundParameters.ContainsKey('Comments')) { $body['comments'] = $Comments }

    if ($PSCmdlet.ShouldProcess("Approval $ApprovalId on Request $RequestId (Level $LevelNumber)", 'Reject SDP Approval')) {
        Invoke-SDPRestMethod `
            -Endpoint "requests/$RequestId/approval_levels/$LevelNumber/approvals/$ApprovalId/_reject" `
            -Method PUT `
            -Body @{ approval = $body }
    }
}

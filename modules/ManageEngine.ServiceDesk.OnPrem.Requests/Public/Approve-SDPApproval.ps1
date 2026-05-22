function Approve-SDPApproval {
    <#
    .SYNOPSIS
        Approves a pending approval on a ServiceDesk Plus request.
    .PARAMETER RequestId
        The ID of the request.
    .PARAMETER LevelNumber
        The approval level number.
    .PARAMETER ApprovalId
        The ID of the approval to act on.
    .PARAMETER Comments
        Optional comments to include with the approval action.
    .EXAMPLE
        Approve-SDPApproval -RequestId '12345' -LevelNumber 1 -ApprovalId '1'
    .EXAMPLE
        Approve-SDPApproval -RequestId '12345' -LevelNumber 1 -ApprovalId '1' -Comments 'Approved per manager request.'
    #>
    [CmdletBinding(SupportsShouldProcess)]
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

    if ($PSCmdlet.ShouldProcess("Approval $ApprovalId on Request $RequestId (Level $LevelNumber)", 'Approve SDP Approval')) {
        Invoke-SDPRestMethod `
            -Endpoint "requests/$RequestId/approval_levels/$LevelNumber/approvals/$ApprovalId/_approve" `
            -Method PUT `
            -Body @{ approval = $body }
    }
}

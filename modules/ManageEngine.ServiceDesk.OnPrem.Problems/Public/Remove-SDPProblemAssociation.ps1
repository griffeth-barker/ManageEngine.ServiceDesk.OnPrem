function Remove-SDPProblemAssociation {
    <#
    .SYNOPSIS
        Removes an association between a ServiceDesk Plus problem and an incident or change.
    .PARAMETER ProblemId
        The ID of the problem.
    .PARAMETER Type
        The type of association to remove: Incident or Change.
    .PARAMETER AssociatedId
        The ID of the incident (request) or change to disassociate.
    .EXAMPLE
        Remove-SDPProblemAssociation -ProblemId '12345' -Type Incident -AssociatedId '789'
    .EXAMPLE
        Remove-SDPProblemAssociation -ProblemId '12345' -Type Change -AssociatedId '456'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ProblemId,

        [Parameter(Mandatory)]
        [ValidateSet('Incident', 'Change')]
        [string]$Type,

        [Parameter(Mandatory)]
        [string]$AssociatedId
    )

    process {
        $endpointMap = @{
            Incident = 'associated_incidents'
            Change   = 'associated_change'
        }
        $bodyKeyMap = @{
            Incident = 'request'
            Change   = 'change'
        }

        $endpoint = "problems/$ProblemId/$($endpointMap[$Type])"
        $bodyKey  = $bodyKeyMap[$Type]
        $body     = @{ $bodyKey = @{ id = $AssociatedId } }

        if ($PSCmdlet.ShouldProcess("Problem $ProblemId", "Disassociate $Type $AssociatedId")) {
            Invoke-SDPRestMethod -Endpoint $endpoint -Method DELETE -Body $body
        }
    }
}

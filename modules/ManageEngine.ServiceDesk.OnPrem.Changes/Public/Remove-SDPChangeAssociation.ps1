function Remove-SDPChangeAssociation {
    <#
    .SYNOPSIS
        Removes an association (request, problem, or project) from a ServiceDesk Plus change.
    .PARAMETER ChangeId
        The ID of the change.
    .PARAMETER Type
        The type of association to remove:
          InitiatedRequest    - request initiated by this change
          InitiatedByRequest  - request that caused/initiated this change
          Problem             - problem associated with this change
          Project             - project associated with this change
    .PARAMETER AssociatedId
        The ID of the associated record to dissociate.
    .EXAMPLE
        Remove-SDPChangeAssociation -ChangeId '12345' -Type Problem -AssociatedId '456'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ChangeId,

        [Parameter(Mandatory)]
        [ValidateSet('InitiatedRequest', 'InitiatedByRequest', 'Problem', 'Project')]
        [string]$Type,

        [Parameter(Mandatory)]
        [string]$AssociatedId
    )

    process {
        $endpointMap = @{
            InitiatedRequest   = 'initiated_requests'
            InitiatedByRequest = 'initiated_by_requests'
            Problem            = 'problems'
            Project            = 'projects'
        }
        $bodyKeyMap = @{
            InitiatedRequest   = 'request'
            InitiatedByRequest = 'request'
            Problem            = 'problem'
            Project            = 'project'
        }
        $endpoint = "changes/$ChangeId/$($endpointMap[$Type])"
        $bodyKey  = $bodyKeyMap[$Type]
        $body     = @{ $bodyKey = @{ id = $AssociatedId } }

        if ($PSCmdlet.ShouldProcess("Change $ChangeId", "Dissociate $Type $AssociatedId")) {
            Invoke-SDPRestMethod -Endpoint $endpoint -Method DELETE -Body $body
        }
    }
}

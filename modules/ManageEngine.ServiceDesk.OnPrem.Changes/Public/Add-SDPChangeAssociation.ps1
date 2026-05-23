function Add-SDPChangeAssociation {
    <#
    .SYNOPSIS
        Associates a request, problem, or project with a ServiceDesk Plus change.
    .PARAMETER ChangeId
        The ID of the change.
    .PARAMETER Type
        The type of association:
          InitiatedRequest    - associate a request initiated by this change
          InitiatedByRequest  - associate a request that caused/initiated this change
          Problem             - associate a problem with this change
          Project             - associate a project with this change
    .PARAMETER AssociatedId
        The ID of the request, problem, or project to associate.
    .EXAMPLE
        Add-SDPChangeAssociation -ChangeId '12345' -Type Problem -AssociatedId '456'
    .EXAMPLE
        Add-SDPChangeAssociation -ChangeId '12345' -Type InitiatedRequest -AssociatedId '789'
    #>
    [CmdletBinding(SupportsShouldProcess)]
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

        if ($PSCmdlet.ShouldProcess("Change $ChangeId", "Associate $Type $AssociatedId")) {
            Invoke-SDPRestMethod -Endpoint $endpoint -Method POST -Body $body
        }
    }
}

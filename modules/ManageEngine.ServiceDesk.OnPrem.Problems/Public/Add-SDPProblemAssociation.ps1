function Add-SDPProblemAssociation {
    <#
    .SYNOPSIS
        Associates an incident or change with a ServiceDesk Plus problem.
    .PARAMETER ProblemId
        The ID of the problem.
    .PARAMETER Type
        The type of association: Incident or Change.
    .PARAMETER AssociatedId
        The ID of the incident (request) or change to associate.
    .EXAMPLE
        Add-SDPProblemAssociation -ProblemId '12345' -Type Incident -AssociatedId '789'
    .EXAMPLE
        Add-SDPProblemAssociation -ProblemId '12345' -Type Change -AssociatedId '456'
    #>
    [CmdletBinding(SupportsShouldProcess)]
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

        if ($PSCmdlet.ShouldProcess("Problem $ProblemId", "Associate $Type $AssociatedId")) {
            Invoke-SDPRestMethod -Endpoint $endpoint -Method POST -Body $body
        }
    }
}

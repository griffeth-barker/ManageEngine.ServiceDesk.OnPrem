function Set-SDPProblemRootCause {
    <#
    .SYNOPSIS
        Updates the root cause analysis for a ServiceDesk Plus problem.
    .PARAMETER ProblemId
        The ID of the problem.
    .PARAMETER Id
        The ID of the root cause entry to update.
    .PARAMETER Content
        Updated root cause description or analysis text.
    .PARAMETER AdditionalFields
        Hashtable of additional fields to merge into the request body.
    .EXAMPLE
        Set-SDPProblemRootCause -ProblemId '12345' -Id '1' -Content 'Updated: DNS TTL mismatch caused caching issue.'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ProblemId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id,

        [Parameter()]
        [string]$Content,

        [Parameter()]
        [hashtable]$AdditionalFields
    )

    process {
        $body = @{}
        if ($PSBoundParameters.ContainsKey('Content')) { $body['description'] = $Content }

        if ($AdditionalFields) {
            foreach ($key in $AdditionalFields.Keys) { $body[$key] = $AdditionalFields[$key] }
        }

        if ($PSCmdlet.ShouldProcess("Root cause $Id on Problem $ProblemId", 'Update root cause')) {
            $response = Invoke-SDPRestMethod -Endpoint "problems/$ProblemId/root_cause/$Id" -Method PUT -Body @{ root_cause = $body }
            $response.root_cause
        }
    }
}

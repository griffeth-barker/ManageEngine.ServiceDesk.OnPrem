function Add-SDPProblemRootCause {
    <#
    .SYNOPSIS
        Adds a root cause analysis entry to a ServiceDesk Plus problem.
    .PARAMETER ProblemId
        The ID of the problem.
    .PARAMETER Content
        The root cause description or analysis text.
    .PARAMETER AdditionalFields
        Hashtable of additional fields to include in the request body.
    .EXAMPLE
        Add-SDPProblemRootCause -ProblemId '12345' -Content 'Misconfigured DNS record pointing to decommissioned server.'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ProblemId,

        [Parameter(Mandatory)]
        [string]$Content,

        [Parameter()]
        [hashtable]$AdditionalFields
    )

    process {
        $body = @{ description = $Content }

        if ($AdditionalFields) {
            foreach ($key in $AdditionalFields.Keys) { $body[$key] = $AdditionalFields[$key] }
        }

        if ($PSCmdlet.ShouldProcess("Problem $ProblemId", 'Add root cause')) {
            $response = Invoke-SDPRestMethod -Endpoint "problems/$ProblemId/root_cause" -Method POST -Body @{ root_cause = $body }
            $response.root_cause
        }
    }
}

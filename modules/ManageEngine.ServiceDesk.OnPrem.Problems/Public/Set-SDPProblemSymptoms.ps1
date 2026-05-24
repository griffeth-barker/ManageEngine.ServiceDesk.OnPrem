function Set-SDPProblemSymptoms {
    <#
    .SYNOPSIS
        Updates the symptoms recorded for a ServiceDesk Plus problem.
    .PARAMETER ProblemId
        The ID of the problem.
    .PARAMETER Id
        The ID of the symptoms entry to update.
    .PARAMETER Content
        Updated description of the observed symptoms.
    .PARAMETER AdditionalFields
        Hashtable of additional fields to merge into the request body.
    .EXAMPLE
        Set-SDPProblemSymptoms -ProblemId '12345' -Id '1' -Content 'Timeout errors confirmed on all mailbox servers, not just shared mailboxes.'
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

        if ($PSCmdlet.ShouldProcess("Symptoms $Id on Problem $ProblemId", 'Update symptoms')) {
            $response = Invoke-SDPRestMethod -Endpoint "problems/$ProblemId/symptoms/$Id" -Method PUT -Body @{ symptoms = $body }
            $response.symptoms
        }
    }
}

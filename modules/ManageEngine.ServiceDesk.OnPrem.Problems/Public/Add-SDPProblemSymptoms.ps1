function Add-SDPProblemSymptoms {
    <#
    .SYNOPSIS
        Adds symptoms to a ServiceDesk Plus problem.
    .PARAMETER ProblemId
        The ID of the problem.
    .PARAMETER Content
        Description of the observed symptoms.
    .PARAMETER AdditionalFields
        Hashtable of additional fields to include in the request body.
    .EXAMPLE
        Add-SDPProblemSymptoms -ProblemId '12345' -Content 'Users receive timeout errors when accessing shared mailboxes; Outlook freezes on profile load.'
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

        if ($PSCmdlet.ShouldProcess("Problem $ProblemId", 'Add symptoms')) {
            $response = Invoke-SDPRestMethod -Endpoint "problems/$ProblemId/symptoms" -Method POST -Body @{ symptoms = $body }
            $response.symptoms
        }
    }
}

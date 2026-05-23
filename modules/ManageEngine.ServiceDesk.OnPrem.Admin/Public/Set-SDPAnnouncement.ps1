function Set-SDPAnnouncement {
    <#
    .SYNOPSIS
        Updates an existing announcement in ServiceDesk Plus.
    .PARAMETER Id
        The ID of the announcement to update.
    .PARAMETER Title
        New title.
    .PARAMETER Content
        New body content.
    .PARAMETER IsPublic
        Whether the announcement is publicly visible.
    .PARAMETER PriorityId
        ID of the priority level.
    .PARAMETER FromDate
        New start date/time.
    .PARAMETER ToDate
        New expiry date/time.
    .EXAMPLE
        Set-SDPAnnouncement -Id '5' -Title 'Maintenance Rescheduled'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPAnnouncement')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id,

        [Parameter()]
        [string]$Title,

        [Parameter()]
        [string]$Content,

        [Parameter()]
        [bool]$IsPublic,

        [Parameter()]
        [string]$PriorityId,

        [Parameter()]
        [datetime]$FromDate,

        [Parameter()]
        [datetime]$ToDate
    )

    process {
        $body = @{}

        if ($PSBoundParameters.ContainsKey('Title'))      { $body['title']     = $Title }
        if ($PSBoundParameters.ContainsKey('Content'))    { $body['content']   = $Content }
        if ($PSBoundParameters.ContainsKey('IsPublic'))   { $body['is_public'] = $IsPublic }
        if ($PSBoundParameters.ContainsKey('PriorityId')) { $body['priority']  = @{ id = $PriorityId } }
        if ($PSBoundParameters.ContainsKey('FromDate'))   { $body['from_date'] = @{ value = [DateTimeOffset]::new($FromDate).ToUnixTimeMilliseconds() } }
        if ($PSBoundParameters.ContainsKey('ToDate'))     { $body['to_date']   = @{ value = [DateTimeOffset]::new($ToDate).ToUnixTimeMilliseconds() } }

        if ($PSCmdlet.ShouldProcess("Announcement $Id", 'Update SDP Announcement')) {
            $response = Invoke-SDPRestMethod -Endpoint "announcements/$Id" -Method PUT -Body @{ announcement = $body }
            [SDPAnnouncement]::new($response.announcement)
        }
    }
}

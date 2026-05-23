function New-SDPAnnouncement {
    <#
    .SYNOPSIS
        Creates a new announcement in ServiceDesk Plus.
    .PARAMETER Title
        Title of the announcement.
    .PARAMETER Content
        Body content of the announcement.
    .PARAMETER IsPublic
        When specified, the announcement is visible to all users (not just technicians).
    .PARAMETER PriorityId
        ID of the priority level for the announcement.
    .PARAMETER FromDate
        Start date/time from which the announcement is active.
    .PARAMETER ToDate
        End date/time after which the announcement expires. Omit for no expiry.
    .EXAMPLE
        New-SDPAnnouncement -Title 'Planned Maintenance' -Content 'Servers will be offline Saturday 10pm-2am.' -IsPublic
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPAnnouncement')]
    param(
        [Parameter(Mandatory)]
        [string]$Title,

        [Parameter(Mandatory)]
        [string]$Content,

        [Parameter()]
        [switch]$IsPublic,

        [Parameter()]
        [string]$PriorityId,

        [Parameter()]
        [datetime]$FromDate,

        [Parameter()]
        [datetime]$ToDate
    )

    $body = @{
        title     = $Title
        content   = $Content
        is_public = $IsPublic.IsPresent
    }

    if ($PSBoundParameters.ContainsKey('PriorityId')) { $body['priority']   = @{ id = $PriorityId } }
    if ($PSBoundParameters.ContainsKey('FromDate'))   { $body['from_date']  = @{ value = [DateTimeOffset]::new($FromDate).ToUnixTimeMilliseconds() } }
    if ($PSBoundParameters.ContainsKey('ToDate'))     { $body['to_date']    = @{ value = [DateTimeOffset]::new($ToDate).ToUnixTimeMilliseconds() } }

    if ($PSCmdlet.ShouldProcess($Title, 'Create SDP Announcement')) {
        $response = Invoke-SDPRestMethod -Endpoint 'announcements' -Method POST -Body @{ announcement = $body }
        [SDPAnnouncement]::new($response.announcement)
    }
}

class SDPAnnouncement {
    [string]$Id
    [string]$Title
    [string]$Content
    [bool]$IsPublic
    [SDPReference]$Priority
    [nullable[datetime]]$FromDate
    [nullable[datetime]]$ToDate
    [pscustomobject]$RawData

    SDPAnnouncement([object]$data) {
        $this.Id       = $data.id
        $this.Title    = $data.title
        $this.Content  = $data.content
        $this.IsPublic = [bool]$data.is_public

        if ($data.priority) { $this.Priority = [SDPReference]::new($data.priority) }

        $this.FromDate = [SDPUtil]::ParseTime($data.from_date)
        $this.ToDate   = [SDPUtil]::ParseTime($data.to_date)

        $this.RawData = $data
    }

    [string] ToString() { return $this.Title ?? [string]::Empty }
}

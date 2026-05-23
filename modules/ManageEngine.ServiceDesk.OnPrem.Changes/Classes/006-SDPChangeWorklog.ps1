class SDPChangeWorklog {
    [string]$Id
    [string]$ChangeId
    [string]$Description
    [SDPReference]$Owner
    [SDPReference]$Template
    [string]$TimeSpentHours
    [string]$TimeSpentMinutes
    [nullable[datetime]]$StartTime
    [nullable[datetime]]$EndTime
    [nullable[datetime]]$CreatedTime
    [SDPReference]$CreatedBy
    [bool]$IncludeNonOperationalHours
    [pscustomobject]$RawData

    SDPChangeWorklog([string]$changeId, [object]$data) {
        $this.ChangeId    = $changeId
        $this.Id          = $data.id
        $this.Description = $data.description
        $this.IncludeNonOperationalHours = [bool]$data.include_nonoperational_hours

        if ($data.owner)      { $this.Owner     = [SDPReference]::new($data.owner) }
        if ($data.template)   { $this.Template  = [SDPReference]::new($data.template) }
        if ($data.created_by) { $this.CreatedBy = [SDPReference]::new($data.created_by) }

        if ($data.time_spent) {
            $this.TimeSpentHours   = $data.time_spent.hours
            $this.TimeSpentMinutes = $data.time_spent.minutes
        }

        $this.StartTime   = [SDPUtil]::ParseTime($data.start_time)
        $this.EndTime     = [SDPUtil]::ParseTime($data.end_time)
        $this.CreatedTime = [SDPUtil]::ParseTime($data.created_time)

        $this.RawData = $data
    }
}

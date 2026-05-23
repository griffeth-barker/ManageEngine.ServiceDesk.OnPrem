class SDPChangeDeploymentSchedule {
    [string]$Id
    [string]$ChangeId
    [string]$Description
    [SDPReference]$Status
    [nullable[datetime]]$ScheduledStartTime
    [nullable[datetime]]$ScheduledEndTime
    [nullable[datetime]]$ActualStartTime
    [nullable[datetime]]$ActualEndTime
    [pscustomobject]$RawData

    SDPChangeDeploymentSchedule([string]$changeId, [object]$data) {
        $this.ChangeId    = $changeId
        $this.Id          = $data.id
        $this.Description = $data.description

        if ($data.status) { $this.Status = [SDPReference]::new($data.status) }

        $this.ScheduledStartTime = [SDPUtil]::ParseTime($data.scheduled_start_time)
        $this.ScheduledEndTime   = [SDPUtil]::ParseTime($data.scheduled_end_time)
        $this.ActualStartTime    = [SDPUtil]::ParseTime($data.actual_start_time)
        $this.ActualEndTime      = [SDPUtil]::ParseTime($data.actual_end_time)

        $this.RawData = $data
    }
}

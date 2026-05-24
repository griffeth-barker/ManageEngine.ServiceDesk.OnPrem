class SDPProblemTask {
    [string]$Id
    [string]$ProblemId
    [string]$Title
    [string]$Description
    [SDPReference]$Status
    [SDPReference]$Priority
    [SDPReference]$Owner
    [SDPReference]$Group
    [SDPReference]$Type
    [int]$PercentageCompletion
    [nullable[datetime]]$CreatedTime
    [nullable[datetime]]$DueByTime
    [nullable[datetime]]$ScheduledStartTime
    [nullable[datetime]]$ScheduledEndTime
    [nullable[datetime]]$ActualStartTime
    [nullable[datetime]]$ActualEndTime
    [string]$EstimatedEffort
    [pscustomobject]$RawData

    SDPProblemTask([string]$problemId, [object]$data) {
        $this.ProblemId            = $problemId
        $this.Id                   = $data.id
        $this.Title                = $data.title
        $this.Description          = $data.description
        $this.PercentageCompletion = [int]$data.percentage_completion

        if ($data.status)   { $this.Status   = [SDPReference]::new($data.status) }
        if ($data.priority) { $this.Priority = [SDPReference]::new($data.priority) }
        if ($data.owner)    { $this.Owner    = [SDPReference]::new($data.owner) }
        if ($data.group)    { $this.Group    = [SDPReference]::new($data.group) }
        if ($data.type)     { $this.Type     = [SDPReference]::new($data.type) }

        $this.CreatedTime        = [SDPUtil]::ParseTime($data.created_time)
        $this.DueByTime          = [SDPUtil]::ParseTime($data.due_by_time)
        $this.ScheduledStartTime = [SDPUtil]::ParseTime($data.scheduled_start_time)
        $this.ScheduledEndTime   = [SDPUtil]::ParseTime($data.scheduled_end_time)
        $this.ActualStartTime    = [SDPUtil]::ParseTime($data.actual_start_time)
        $this.ActualEndTime      = [SDPUtil]::ParseTime($data.actual_end_time)

        if ($data.estimated_effort) {
            $ef = $data.estimated_effort
            $this.EstimatedEffort = $ef.display_value ?? "$($ef.hours)h $($ef.minutes)m"
        }

        $this.RawData = $data
    }
}

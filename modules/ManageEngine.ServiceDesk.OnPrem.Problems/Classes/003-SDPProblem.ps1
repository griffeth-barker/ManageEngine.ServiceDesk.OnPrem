class SDPProblem {
    [string]$Id
    [string]$Title
    [string]$Description
    [SDPReference]$Status
    [SDPReference]$Priority
    [SDPReference]$Urgency
    [SDPReference]$Impact
    [SDPReference]$Requester
    [SDPReference]$CreatedBy
    [SDPReference]$Technician
    [SDPReference]$Group
    [SDPReference]$Site
    [SDPReference]$Department
    [SDPReference]$Category
    [SDPReference]$Subcategory
    [SDPReference]$ClosureCode
    [nullable[datetime]]$DueByTime
    [nullable[datetime]]$CreatedTime
    [nullable[datetime]]$UpdatedTime
    [nullable[datetime]]$ClosedTime
    [pscustomobject]$UdfFields
    [pscustomobject]$RawData

    SDPProblem([object]$data) {
        $this.Id          = $data.id
        $this.Title       = $data.title
        $this.Description = $data.description

        if ($data.status)       { $this.Status      = [SDPReference]::new($data.status) }
        if ($data.priority)     { $this.Priority    = [SDPReference]::new($data.priority) }
        if ($data.urgency)      { $this.Urgency     = [SDPReference]::new($data.urgency) }
        if ($data.impact)       { $this.Impact      = [SDPReference]::new($data.impact) }
        if ($data.requester)    { $this.Requester   = [SDPReference]::new($data.requester) }
        if ($data.created_by)   { $this.CreatedBy   = [SDPReference]::new($data.created_by) }
        if ($data.technician)   { $this.Technician  = [SDPReference]::new($data.technician) }
        if ($data.group)        { $this.Group       = [SDPReference]::new($data.group) }
        if ($data.site)         { $this.Site        = [SDPReference]::new($data.site) }
        if ($data.department)   { $this.Department  = [SDPReference]::new($data.department) }
        if ($data.category)     { $this.Category    = [SDPReference]::new($data.category) }
        if ($data.subcategory)  { $this.Subcategory = [SDPReference]::new($data.subcategory) }
        if ($data.closure_code) { $this.ClosureCode = [SDPReference]::new($data.closure_code) }

        $this.DueByTime   = [SDPUtil]::ParseTime($data.due_by_time)
        $this.CreatedTime = [SDPUtil]::ParseTime($data.created_time)
        $this.UpdatedTime = [SDPUtil]::ParseTime($data.updated_time)
        $this.ClosedTime  = [SDPUtil]::ParseTime($data.closed_time)

        if ($data.udf_fields) { $this.UdfFields = $data.udf_fields }
        $this.RawData = $data
    }
}

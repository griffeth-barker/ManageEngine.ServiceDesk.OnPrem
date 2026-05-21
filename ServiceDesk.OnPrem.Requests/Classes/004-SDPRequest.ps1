class SDPRequest {
    [string]$Id
    [string]$Subject
    [string]$Description
    [SDPReference]$Status
    [SDPReference]$Priority
    [SDPReference]$Urgency
    [SDPReference]$Impact
    [SDPReference]$RequestType
    [SDPReference]$Mode
    [SDPReference]$Level
    [SDPReference]$Category
    [SDPReference]$Subcategory
    [SDPReference]$Item
    [SDPReference]$Requester
    [SDPReference]$CreatedBy
    [SDPReference]$Technician
    [SDPReference]$Group
    [SDPReference]$Site
    [SDPReference]$Department
    [nullable[datetime]]$CreatedTime
    [nullable[datetime]]$UpdatedTime
    [nullable[datetime]]$DueByTime
    [nullable[datetime]]$ResolvedTime
    [nullable[datetime]]$ClosedTime
    [bool]$IsOverdue
    [bool]$IsServiceRequest
    [string]$Resolution
    [pscustomobject]$UdfFields
    [pscustomobject]$RawData

    SDPRequest([object]$data) {
        $this.Id            = $data.id
        $this.Subject       = $data.subject
        $this.Description   = $data.description
        $this.IsOverdue     = [bool]$data.is_overdue
        $this.IsServiceRequest = [bool]$data.is_service_request

        if ($data.status)       { $this.Status      = [SDPReference]::new($data.status) }
        if ($data.priority)     { $this.Priority     = [SDPReference]::new($data.priority) }
        if ($data.urgency)      { $this.Urgency      = [SDPReference]::new($data.urgency) }
        if ($data.impact)       { $this.Impact       = [SDPReference]::new($data.impact) }
        if ($data.request_type) { $this.RequestType  = [SDPReference]::new($data.request_type) }
        if ($data.mode)         { $this.Mode         = [SDPReference]::new($data.mode) }
        if ($data.level)        { $this.Level        = [SDPReference]::new($data.level) }
        if ($data.category)     { $this.Category     = [SDPReference]::new($data.category) }
        if ($data.subcategory)  { $this.Subcategory  = [SDPReference]::new($data.subcategory) }
        if ($data.item)         { $this.Item         = [SDPReference]::new($data.item) }
        if ($data.requester)    { $this.Requester    = [SDPReference]::new($data.requester) }
        if ($data.created_by)   { $this.CreatedBy    = [SDPReference]::new($data.created_by) }
        if ($data.technician)   { $this.Technician   = [SDPReference]::new($data.technician) }
        if ($data.group)        { $this.Group        = [SDPReference]::new($data.group) }
        if ($data.site)         { $this.Site         = [SDPReference]::new($data.site) }
        if ($data.department)   { $this.Department   = [SDPReference]::new($data.department) }

        $this.CreatedTime  = [SDPUtil]::ParseTime($data.created_time)
        $this.UpdatedTime  = [SDPUtil]::ParseTime($data.updated_time)
        $this.DueByTime    = [SDPUtil]::ParseTime($data.due_by_time)
        $this.ResolvedTime = [SDPUtil]::ParseTime($data.resolved_time)
        $this.ClosedTime   = [SDPUtil]::ParseTime($data.closed_time)

        if ($data.resolution) { $this.Resolution = $data.resolution.content }
        if ($data.udf_fields) { $this.UdfFields  = $data.udf_fields }

        $this.RawData = $data
    }
}

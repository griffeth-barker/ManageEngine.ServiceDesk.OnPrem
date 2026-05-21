class SDPRequestNote {
    [string]$Id
    [string]$RequestId
    [string]$Description
    [bool]$ShowToRequester
    [SDPReference]$AddedBy
    [SDPReference]$LastUpdatedBy
    [nullable[datetime]]$AddedTime
    [nullable[datetime]]$LastUpdatedTime
    [pscustomobject]$RawData

    SDPRequestNote([string]$requestId, [object]$data) {
        $this.RequestId    = $requestId
        $this.Id           = $data.id
        $this.Description  = $data.description
        $this.ShowToRequester = [bool]$data.show_to_requester

        if ($data.added_by)       { $this.AddedBy       = [SDPReference]::new($data.added_by) }
        if ($data.last_updated_by){ $this.LastUpdatedBy  = [SDPReference]::new($data.last_updated_by) }

        $this.AddedTime       = [SDPUtil]::ParseTime($data.added_time)
        $this.LastUpdatedTime = [SDPUtil]::ParseTime($data.last_updated_time)

        $this.RawData = $data
    }
}

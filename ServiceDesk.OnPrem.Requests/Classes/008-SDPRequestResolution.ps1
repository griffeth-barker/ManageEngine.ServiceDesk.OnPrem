class SDPRequestResolution {
    [string]$RequestId
    [string]$Content
    [SDPReference]$SubmittedBy
    [nullable[datetime]]$SubmittedOn
    [pscustomobject]$RawData

    SDPRequestResolution([string]$requestId, [object]$data) {
        $this.RequestId = $requestId
        $this.Content   = $data.content

        if ($data.submitted_by) { $this.SubmittedBy = [SDPReference]::new($data.submitted_by) }

        $this.SubmittedOn = [SDPUtil]::ParseTime($data.submitted_on)
        $this.RawData     = $data
    }
}

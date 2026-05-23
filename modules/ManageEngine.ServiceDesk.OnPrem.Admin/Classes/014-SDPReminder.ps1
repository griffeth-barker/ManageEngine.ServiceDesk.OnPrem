class SDPReminder {
    [string]$Id
    [string]$Summary
    [string]$Status
    [nullable[datetime]]$Date
    [pscustomobject]$RawData

    SDPReminder([object]$data) {
        $this.Id      = $data.id
        $this.Summary = $data.summary
        $this.Status  = $data.status

        $this.Date = [SDPUtil]::ParseTime($data.date)

        $this.RawData = $data
    }

    [string] ToString() { return $this.Summary ?? [string]::Empty }
}

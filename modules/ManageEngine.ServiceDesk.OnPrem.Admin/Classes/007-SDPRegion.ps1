class SDPRegion {
    [string]$Id
    [string]$Name
    [string]$Description
    [pscustomobject]$RawData

    SDPRegion([object]$data) {
        $this.Id          = $data.id
        $this.Name        = $data.name
        $this.Description = $data.description
        $this.RawData     = $data
    }

    [string] ToString() { return $this.Name ?? [string]::Empty }
}

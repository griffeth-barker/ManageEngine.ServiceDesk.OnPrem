class SDPSupportGroup {
    [string]$Id
    [string]$Name
    [string]$Description
    [SDPReference]$Site
    [pscustomobject]$RawData

    SDPSupportGroup([object]$data) {
        $this.Id          = $data.id
        $this.Name        = $data.name
        $this.Description = $data.description

        if ($data.site) { $this.Site = [SDPReference]::new($data.site) }

        $this.RawData = $data
    }

    [string] ToString() { return $this.Name ?? [string]::Empty }
}

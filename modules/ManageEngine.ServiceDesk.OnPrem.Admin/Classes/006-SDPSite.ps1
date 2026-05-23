class SDPSite {
    [string]$Id
    [string]$Name
    [string]$Description
    [string]$EmailId
    [string]$City
    [string]$State
    [string]$Country
    [SDPReference]$Region
    [pscustomobject]$RawData

    SDPSite([object]$data) {
        $this.Id          = $data.id
        $this.Name        = $data.name
        $this.Description = $data.description
        $this.EmailId     = $data.email_id
        $this.City        = $data.city
        $this.State       = $data.state
        $this.Country     = $data.country

        if ($data.region) { $this.Region = [SDPReference]::new($data.region) }

        $this.RawData = $data
    }

    [string] ToString() { return $this.Name ?? [string]::Empty }
}

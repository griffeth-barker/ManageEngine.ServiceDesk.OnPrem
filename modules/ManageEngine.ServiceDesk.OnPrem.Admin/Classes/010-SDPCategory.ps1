class SDPCategory {
    [string]$Id
    [string]$Name
    [string]$Description
    [SDPReference]$Technician
    [pscustomobject]$RawData

    SDPCategory([object]$data) {
        $this.Id          = $data.id
        $this.Name        = $data.name
        $this.Description = $data.description

        if ($data.technician) { $this.Technician = [SDPReference]::new($data.technician) }

        $this.RawData = $data
    }

    [string] ToString() { return $this.Name ?? [string]::Empty }
}

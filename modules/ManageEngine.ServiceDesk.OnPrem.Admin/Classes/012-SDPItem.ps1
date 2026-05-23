class SDPItem {
    [string]$Id
    [string]$Name
    [string]$Description
    [SDPReference]$Subcategory
    [pscustomobject]$RawData

    SDPItem([object]$data) {
        $this.Id          = $data.id
        $this.Name        = $data.name
        $this.Description = $data.description

        if ($data.subcategory) { $this.Subcategory = [SDPReference]::new($data.subcategory) }

        $this.RawData = $data
    }

    [string] ToString() { return $this.Name ?? [string]::Empty }
}

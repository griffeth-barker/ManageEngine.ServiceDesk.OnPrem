class SDPSubcategory {
    [string]$Id
    [string]$Name
    [string]$Description
    [SDPReference]$Category
    [pscustomobject]$RawData

    SDPSubcategory([object]$data) {
        $this.Id          = $data.id
        $this.Name        = $data.name
        $this.Description = $data.description

        if ($data.category) { $this.Category = [SDPReference]::new($data.category) }

        $this.RawData = $data
    }

    [string] ToString() { return $this.Name ?? [string]::Empty }
}

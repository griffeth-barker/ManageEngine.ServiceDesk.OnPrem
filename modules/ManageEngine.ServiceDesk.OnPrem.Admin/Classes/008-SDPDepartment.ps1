class SDPDepartment {
    [string]$Id
    [string]$Name
    [string]$Description
    [SDPReference]$DepartmentHead
    [SDPReference]$Site
    [pscustomobject]$RawData

    SDPDepartment([object]$data) {
        $this.Id          = $data.id
        $this.Name        = $data.name
        $this.Description = $data.description

        if ($data.department_head) { $this.DepartmentHead = [SDPReference]::new($data.department_head) }
        if ($data.site)            { $this.Site            = [SDPReference]::new($data.site) }

        $this.RawData = $data
    }

    [string] ToString() { return $this.Name ?? [string]::Empty }
}

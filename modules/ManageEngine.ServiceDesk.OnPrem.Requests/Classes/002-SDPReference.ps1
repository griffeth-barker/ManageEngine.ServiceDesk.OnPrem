class SDPReference {
    [string]$Id
    [string]$Name

    SDPReference([object]$data) {
        $this.Id   = $data.id
        $this.Name = $data.name
    }

    [string] ToString() { return $this.Name ?? [string]::Empty }
}

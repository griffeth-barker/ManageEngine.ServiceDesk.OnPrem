class SDPOrgUser {
    [string]$Id
    [string]$Name
    [string]$FirstName
    [string]$MiddleName
    [string]$LastName
    [string]$LoginName
    [string]$EmailId
    [string]$Phone
    [string]$Mobile
    [string]$JobTitle
    [string]$EmployeeId
    [bool]$IsVipUser
    [SDPReference]$Department
    [SDPReference]$ReportingTo
    [pscustomobject]$RawData

    SDPOrgUser([object]$data) {
        $this.Id         = $data.id
        $this.Name       = $data.name
        $this.FirstName  = $data.first_name
        $this.MiddleName = $data.middle_name
        $this.LastName   = $data.last_name
        $this.LoginName  = $data.login_name
        $this.EmailId    = $data.email_id
        $this.Phone      = $data.phone
        $this.Mobile     = $data.mobile
        $this.JobTitle   = $data.jobtitle
        $this.EmployeeId = $data.employee_id
        $this.IsVipUser  = [bool]$data.is_vipuser

        if ($data.department)   { $this.Department  = [SDPReference]::new($data.department) }
        if ($data.reporting_to) { $this.ReportingTo = [SDPReference]::new($data.reporting_to) }

        $this.RawData = $data
    }

    [string] ToString() { return $this.Name ?? [string]::Empty }
}

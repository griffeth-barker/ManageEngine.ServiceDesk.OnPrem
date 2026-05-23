# Examples

## Connecting

```powershell
$key = Get-Secret -Name 'SdpTechnicianKey'
Connect-SDPService -BaseUri 'https://sdp.corp.local:8080' -TechnicianKey $key

# Multi-portal installs
Connect-SDPService -BaseUri 'https://sdp.corp.local' -TechnicianKey $key -PortalId 2

# Self-signed / untrusted certificates
Connect-SDPService -BaseUri 'https://sdp.corp.local' -TechnicianKey $key -SkipCertificateCheck

Disconnect-SDPService
```

## Requests

```powershell
# List open requests
Get-SDPRequest -Filter @(@{ field = 'status.name'; condition = 'eq'; value = 'Open' }) -All

# Get a single request
Get-SDPRequest -Id '12345'

# Create a request
New-SDPRequest -Subject 'Cannot access VPN' -RequesterName 'Jane Smith' -PriorityName 'High'

# Update a request
Set-SDPRequest -Id '12345' -TechnicianName 'Bob Jones' -StatusName 'In Progress'

# Pipeline: close all resolved requests
Get-SDPRequest -Filter @(@{ field = 'status.name'; condition = 'eq'; value = 'Resolved' }) -All |
    Set-SDPRequest -StatusName 'Closed'

# Notes
New-SDPRequestNote -RequestId '12345' -Description 'Escalated to Tier 2.' -ShowToRequester
Get-SDPRequestNote -RequestId '12345'
Set-SDPRequestNote -RequestId '12345' -Id '1' -Description 'Updated note.'
Remove-SDPRequestNote -RequestId '12345' -Id '1'

# Worklogs
New-SDPRequestWorklog -RequestId '12345' -TimeSpentHours '1' -TimeSpentMinutes '30' -Description 'Troubleshooting session'
Get-SDPRequestWorklog -RequestId '12345'
Remove-SDPRequestWorklog -RequestId '12345' -Id '1'

# Resolution
New-SDPRequestResolution -RequestId '12345' -Content 'Reset credentials. Issue resolved.'
Get-SDPRequestResolution -RequestId '12345'

# Approvals
Get-SDPApproval
Approve-SDPApproval -RequestId '12345' -LevelNumber 1 -ApprovalId '1' -Comments 'Approved.'
Deny-SDPApproval   -RequestId '12345' -LevelNumber 1 -ApprovalId '1' -Comments 'Missing justification.'
```

## Changes

```powershell
# List all open changes
Get-SDPChange -Filter @(@{ field = 'status.name'; condition = 'eq'; value = 'Open' }) -All

# Get a single change
Get-SDPChange -Id '12345'

# Create a change
New-SDPChange -Title 'Patch Tuesday rollout' -ChangeTypeName 'Normal' -PriorityName 'High' -TechnicianName 'Bob Jones'

# Update a change (including descriptive fields)
Set-SDPChange -Id '12345' -StatusName 'Implementation' -BackOutPlan 'Step 1: Restore from snapshot.'

# Bulk operations
Close-SDPChange -Id '12345','67890' -ClosureCodeName 'Successful'
Invoke-SDPChangePickup -Id '12345'
Set-SDPChangeAssignment -Id '12345' -TechnicianName 'Bob Jones'

# Soft-delete (trash) and restore
Remove-SDPChange -Id '12345'
Restore-SDPChange -Id '12345'

# Notes
New-SDPChangeNote -ChangeId '12345' -Description 'CAB approved.' -ShowToRequester
Get-SDPChangeNote -ChangeId '12345'
Set-SDPChangeNote -ChangeId '12345' -Id '1' -Description 'Updated note.'
Remove-SDPChangeNote -ChangeId '12345' -Id '1'

# Tasks
New-SDPChangeTask -ChangeId '12345' -Title 'Backup configuration'
Get-SDPChangeTask -ChangeId '12345'
Set-SDPChangeTask -ChangeId '12345' -Id '1' -StatusName 'Completed'
Remove-SDPChangeTask -ChangeId '12345' -Id '1'

# Worklogs
New-SDPChangeWorklog -ChangeId '12345' -Description 'Applied patches' -OwnerName 'Bob Jones' -StartTime (Get-Date).AddHours(-1) -EndTime (Get-Date)
Get-SDPChangeWorklog -ChangeId '12345'
Remove-SDPChangeWorklog -ChangeId '12345' -Id '1'

# Deployment schedules
New-SDPChangeDeploymentSchedule -ChangeId '12345' -Description 'Maintenance window' -ScheduledStartTime (Get-Date) -ScheduledEndTime (Get-Date).AddHours(2)
Get-SDPChangeDeploymentSchedule -ChangeId '12345'
Remove-SDPChangeDeploymentSchedule -ChangeId '12345' -Id '1'

# Associations
Add-SDPChangeAssociation -ChangeId '12345' -Type Problem -AssociatedId '456'
Get-SDPChangeAssociation -ChangeId '12345' -Type InitiatedRequest
Remove-SDPChangeAssociation -ChangeId '12345' -Type Problem -AssociatedId '456'

# Config/lookup data
Get-SDPChangeType
Get-SDPChangeStatus
Get-SDPChangeStage
Get-SDPCAB
Get-SDPChangeRisk
Get-SDPChangeRole
Get-SDPChangeReason
Get-SDPChangeClosureCode
Get-SDPChangeClosureRule
```

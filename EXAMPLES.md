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

## Problems

```powershell
# List open problems
Get-SDPProblem -Filter @(@{ field = 'status.name'; condition = 'eq'; value = 'Open' }) -All

# Get a single problem
Get-SDPProblem -Id '12345'

# Create a problem
New-SDPProblem -Title 'Exchange server repeatedly crashing' -PriorityName 'High' -TechnicianName 'Bob Jones'

# Update a problem
Set-SDPProblem -Id '12345' -StatusName 'In Progress' -GroupName 'Infrastructure'

# Bulk operations
Invoke-SDPProblemPickup -Id '12345'
Set-SDPProblemAssignment -Id '12345' -TechnicianName 'Bob Jones'
Close-SDPProblem -Id '12345','67890' -ClosureCodeName 'Resolved' -Comments 'Root cause eliminated.'

# Delete (permanent — no trash variant)
Remove-SDPProblem -Id '12345'

# Notes
New-SDPProblemNote -ProblemId '12345' -Description 'Escalated to Tier 2.'
Get-SDPProblemNote -ProblemId '12345'
Set-SDPProblemNote -ProblemId '12345' -Id '1' -Description 'Updated note.'
Remove-SDPProblemNote -ProblemId '12345' -Id '1'

# Tasks
New-SDPProblemTask -ProblemId '12345' -Title 'Analyse affected systems' -OwnerName 'Bob Jones'
Get-SDPProblemTask -ProblemId '12345'
Set-SDPProblemTask -ProblemId '12345' -Id '1' -StatusName 'Completed'
Remove-SDPProblemTask -ProblemId '12345' -Id '1'
Invoke-SDPProblemTaskTrigger -ProblemId '12345' -Id '1'
Invoke-SDPProblemTaskMark -ProblemId '12345' -Id '1'
Close-SDPProblemTask -ProblemId '12345' -Id '1'
Set-SDPProblemTaskAssignment -ProblemId '12345' -Id '1' -TechnicianName 'Bob Jones'

# Task dependencies
Add-SDPProblemTaskDependency -ProblemId '12345' -TaskId '1' -DependsOnTaskId '2'
Get-SDPProblemTaskDependency -ProblemId '12345' -TaskId '1'
Remove-SDPProblemTaskDependency -ProblemId '12345' -TaskId '1' -DependsOnTaskId '2'

# Task comments
New-SDPProblemTaskComment -ProblemId '12345' -TaskId '1' -Content 'Started investigation.'
Get-SDPProblemTaskComment -ProblemId '12345' -TaskId '1'
Set-SDPProblemTaskComment -ProblemId '12345' -TaskId '1' -Id '1' -Content 'Updated.'
Add-SDPProblemTaskCommentReply -ProblemId '12345' -TaskId '1' -CommentId '1' -Content 'Acknowledged.'
Remove-SDPProblemTaskComment -ProblemId '12345' -TaskId '1' -Id '1'

# Task worklogs
New-SDPProblemTaskWorklog -ProblemId '12345' -TaskId '1' -Description 'Patched affected nodes' -OwnerName 'Bob Jones' -StartTime (Get-Date).AddHours(-1) -EndTime (Get-Date)
Get-SDPProblemTaskWorklog -ProblemId '12345' -TaskId '1'
Remove-SDPProblemTaskWorklog -ProblemId '12345' -TaskId '1' -Id '1'

# Worklogs
New-SDPProblemWorklog -ProblemId '12345' -Description 'Investigated root cause' -OwnerName 'Bob Jones' -StartTime (Get-Date).AddHours(-2) -EndTime (Get-Date)
Get-SDPProblemWorklog -ProblemId '12345'
Remove-SDPProblemWorklog -ProblemId '12345' -Id '1'

# Analysis sub-resources
Add-SDPProblemRootCause -ProblemId '12345' -Content 'Memory leak in service X.'
Get-SDPProblemRootCause -ProblemId '12345'
Set-SDPProblemRootCause -ProblemId '12345' -Content 'Updated root cause analysis.'

Add-SDPProblemSymptoms -ProblemId '12345' -Content 'Servers restart every 6 hours.'
Get-SDPProblemSymptoms -ProblemId '12345'
Set-SDPProblemSymptoms -ProblemId '12345' -Content 'Updated symptoms.'

Add-SDPProblemImpactDetails -ProblemId '12345' -Content 'Affects 500 users in the London office.'
Get-SDPProblemImpactDetails -ProblemId '12345'
Set-SDPProblemImpactDetails -ProblemId '12345' -Content 'Updated impact details.'

# Associations
Add-SDPProblemAssociation -ProblemId '12345' -Type Incident -AssociatedId '789'
Add-SDPProblemAssociation -ProblemId '12345' -Type Change -AssociatedId '456'
Get-SDPProblemAssociation -ProblemId '12345' -Type Incident
Remove-SDPProblemAssociation -ProblemId '12345' -Type Incident -AssociatedId '789'

# Templates
Get-SDPProblemTemplate
New-SDPProblemTemplate -Name 'Exchange Outage'
Set-SDPProblemTemplate -Id '1' -Name 'Exchange Outage v2'
Remove-SDPProblemTemplate -Id '1'
```

## Admin

```powershell
# Org users (portal accounts)
Get-SDPOrgUser
Get-SDPOrgUser -Id '12345'
New-SDPOrgUser -Name 'Jane Smith' -LoginName 'jsmith' -EmailId 'jsmith@example.com'
Set-SDPOrgUser -Id '12345' -JobTitle 'Senior Analyst'
Remove-SDPOrgUser -Id '12345'

# Users (requesters)
Get-SDPUser
Get-SDPUser -Id '12345'
New-SDPUser -Name 'Alice Brown' -EmailId 'abrown@example.com' -Phone '555-1234'
Set-SDPUser -Id '12345' -Phone '555-5678'
Remove-SDPUser -Id '12345'

# Technicians
Get-SDPTechnician
Get-SDPTechnician -Id '12345'
New-SDPTechnician -Name 'Bob Jones' -EmailId 'bjones@example.com' -JobTitle 'L2 Engineer'
Set-SDPTechnician -Id '12345' -JobTitle 'L3 Engineer'
Remove-SDPTechnician -Id '12345'
Convert-SDPUserToTechnician -Id '12345'
Convert-SDPTechnicianToUser -Id '12345'

# Org structure
New-SDPRegion -Name 'EMEA'
Get-SDPRegion; Set-SDPRegion -Id '1' -Name 'EMEA Region'; Remove-SDPRegion -Id '1'

New-SDPSite -Name 'Austin HQ' -City 'Austin' -State 'TX' -Country 'USA'
Get-SDPSite; Set-SDPSite -Id '1' -Description 'Main campus'; Remove-SDPSite -Id '1'

New-SDPDepartment -Name 'IT Operations'
Get-SDPDepartment; Set-SDPDepartment -Id '1' -Name 'IT Ops'; Remove-SDPDepartment -Id '1','2'

New-SDPSupportGroup -Name 'Service Desk'
Get-SDPSupportGroup; Set-SDPSupportGroup -Id '1' -Name 'Help Desk'; Remove-SDPSupportGroup -Id '1'

# Categorization
New-SDPCategory -Name 'Hardware'
Get-SDPCategory; Set-SDPCategory -Id '1' -Name 'Hardware'; Remove-SDPCategory -Id '1'

New-SDPSubcategory -CategoryId '1' -Name 'Laptops'
Get-SDPSubcategory -CategoryId '1'; Set-SDPSubcategory -Id '1' -Name 'Laptops'; Remove-SDPSubcategory -Id '1'

New-SDPItem -SubcategoryId '1' -Name 'Dell XPS 15'
Get-SDPItem; Set-SDPItem -Id '1' -Name 'Dell XPS 15 (2024)'; Remove-SDPItem -Id '1'

# Reference data (Status, Priority, Urgency, Impact, Level, Mode)
Get-SDPStatus; New-SDPStatus -Name 'Pending Vendor'; Set-SDPStatus -Id '1' -Name 'Awaiting Vendor'; Remove-SDPStatus -Id '1'
Get-SDPPriority; New-SDPPriority -Name 'Critical'; Set-SDPPriority -Id '1' -Name 'P1-Critical'; Remove-SDPPriority -Id '1'
Get-SDPUrgency; New-SDPUrgency -Name 'Immediate'; Remove-SDPUrgency -Id '1'
Get-SDPImpact; New-SDPImpact -Name 'Enterprise'; Remove-SDPImpact -Id '1'
Get-SDPLevel; New-SDPLevel -Name 'Tier 3'; Remove-SDPLevel -Id '1'
Get-SDPMode; New-SDPMode -Name 'Chat'; Remove-SDPMode -Id '1'

# Priority matrix
Get-SDPPriorityMatrix
New-SDPPriorityMatrix -UrgencyId '1' -ImpactId '1' -PriorityId '1'
Set-SDPPriorityMatrix -Id '1' -PriorityId '2'
Remove-SDPPriorityMatrix -Id '1'
Get-SDPPriorityMatrixOverride
Set-SDPPriorityMatrixOverride -Id '1' -PriorityId '2'

# Announcements
Get-SDPAnnouncement
New-SDPAnnouncement -Title 'Planned Maintenance' -Content 'Servers offline Saturday 10pm-2am.' -IsPublic -FromDate (Get-Date) -ToDate (Get-Date).AddDays(1)
Set-SDPAnnouncement -Id '1' -Title 'Planned Maintenance (Updated)'
Remove-SDPAnnouncement -Id '1'

# Reminders
Get-SDPReminder
New-SDPReminder -Summary 'Follow up on request 25' -Date (Get-Date).AddDays(1)
Set-SDPReminder -Id '1' -Summary 'Updated reminder'
Open-SDPReminder -Id '1'
Close-SDPReminder -Id '1'
Remove-SDPReminder -Id '1'
```

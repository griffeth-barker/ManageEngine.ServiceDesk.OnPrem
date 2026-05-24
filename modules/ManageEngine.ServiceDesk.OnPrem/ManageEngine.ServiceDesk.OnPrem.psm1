$subModules = @(
    'ManageEngine.ServiceDesk.OnPrem.Core'
    'ManageEngine.ServiceDesk.OnPrem.Requests'
    'ManageEngine.ServiceDesk.OnPrem.Changes'
    'ManageEngine.ServiceDesk.OnPrem.Admin'
    'ManageEngine.ServiceDesk.OnPrem.Problems'
)

foreach ($name in $subModules) {
    Import-Module $name -Force -Global
}

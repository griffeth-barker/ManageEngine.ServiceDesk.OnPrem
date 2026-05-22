$subModules = @(
    'ManageEngine.ServiceDesk.OnPrem.Core'
    'ManageEngine.ServiceDesk.OnPrem.Requests'
)

foreach ($name in $subModules) {
    Import-Module $name -Force -Global
}

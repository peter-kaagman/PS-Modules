@{
    RootModule        = 'GraphHelper.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = '8a7e3c2d-5f1a-4b9c-8e6d-1a3f5c8b2e9d'
    Author            = 'Peter Kaagman'
    CompanyName       = 'Atlas College'
    Description       = 'PowerShell module for efficient Microsoft Graph API requests with pagination and memory optimization'
    PowerShellVersion = '5.1'
    FunctionsToExport = @('Invoke-GraphAPIRequest')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
    FileList          = @('GraphHelper.psm1', 'GraphHelper.psd1', 'README.md')
}

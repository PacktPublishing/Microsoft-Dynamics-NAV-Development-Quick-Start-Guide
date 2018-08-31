Import-Module “C:\Program Files (x86)\Microsoft Dynamics NAV\91\RoleTailored Client\Microsoft.Dynamics.Nav.Ide.psm1”

function Deploy-ObjectsToTestServer
{
    Param(
        [Parameter(Mandatory = $true)]
        [string] $DevelopmentDatabaseName,


        [Parameter(Mandatory = $true)]
        [string] $TestDatabaseName,

        [Parameter(Mandatory = $true)]
        [string] $DevelopmentServerName,

        [Parameter(Mandatory = $false, ParameterSetName = "SeparateTestServer")]
        [string] $TestServerName,

        [Parameter(Mandatory = $false, ParameterSetName = "SingelServerSetup")]
        [switch] $SingleServer = $true,

        [Parameter(Mandatory = $true)]
        [string] $NavServerInstance,


        [Parameter(Mandatory = $true)]
        [string] $ObjectFilter
    )

    if ($SingleServer)
    {
        $TestServerName = $DevelopmentServerName
    }

    [string] $tempFileName = [System.IO.Path]::GetTempFileName() + ".txt"

    Export-NAVApplicationObject -DatabaseName $DevelopmentDatabaseName -DatabaseServer $DevelopmentServerName -Path $tempFileName -Filter $ObjectFilter
    Import-NAVApplicationObject -Path $tempFileName -DatabaseName $TestDatabaseName -DatabaseServer $TestServerName
    Compile-NAVApplicationObject -DatabaseName $TestDatabaseName -DatabaseServer $TestServerName -NavServerName $NavServerInstance -Filter $ObjectFilter
}
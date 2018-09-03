if ([Environment]::Is64BitProcess)
{
    $RtcFolder = 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Microsoft Dynamics NAV\110\RoleTailored Client'
}
else
{
    $RtcFolder = 'HKLM:\SOFTWARE\Microsoft\Microsoft Dynamics NAV\110\RoleTailored Client'
}

Test-Path $RtcFolder
$IdeModulePath = (Join-Path (Get-ItemProperty $RtcFolder).Path Microsoft.Dynamics.Nav.Ide.psm1)
Import-Module $IdeModulePath

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
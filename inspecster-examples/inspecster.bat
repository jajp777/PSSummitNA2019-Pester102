@ECHO OFF

REM pwsh -Command "Import-Module ..\inspecster\Pester.psd1; Invoke-Pester %* | ConvertTo-JSON -Depth 10"
pwsh -Command "Import-Module ..\inspecster\Pester.psd1; (Invoke-Pester %*).TestResult | ConvertTo-JSON -Depth 1"


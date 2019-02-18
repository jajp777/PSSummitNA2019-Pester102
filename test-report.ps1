# Run Pester and generate output
Remove-Item 'PSTestReport\artifacts\PesterResults.json' -Force -Confirm:$false -ErrorAction SilentlyContinue
& pwsh -Command "Import-Module .\inspecster\Pester.psd1; Invoke-Pester .\inspecster-examples\windows-baselines -Passthru | ConvertTo-JSON -Depth 5 | Set-Content '.\PSTestReport\artifacts\PesterResults.json'"


Push-Location PSTestReport
 # Example:
$options = @{
  BuildNumber = 23
  GitRepo = "glennsarti/PSSummitNA2019-Pester102"
  GitRepoURL = "https://github.com/glennsarti/PSSummitNA2019-Pester102"
  CiURL = "http://something/job/somerepo/"
  ShowHitCommands = $false
  Compliance = 0.4
  #ScriptAnalyzerFile = ".\artifacts\ScriptAnalyzerResults.json"
  PesterFile = ".\artifacts\PesterResults.json"
  OutputDir = ".\artifacts"
}

.\Invoke-PSTestReport.ps1 @options

Pop-Location

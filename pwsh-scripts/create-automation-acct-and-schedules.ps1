$json = (Get-Content -Raw -path './pwsh-scripts/automation-params.json' | Out-String | ConvertFrom-Json)

$resourceGroup = $json.ResourceGroup
$name = $json.name
$aaName = $json.aaName
$startTime = $json.startTime

write-output($json)

$today = Get-Date -UFormat %D
$eveningstop = $today + " 6PM"
$tomorrow = (Get-Date(Get-Date).AddDays(1) -UFormat %D)
$morningstart = $tomorrow + " " + $startTime
[System.DayOfWeek[]]$weekdays = @( `
  [System.DayOfWeek]::Monday, `
  [System.DayOfWeek]::Tuesday, `
  [System.DayOfWeek]::Wednesday, `
  [System.DayOfWeek]::Thursday, `
  [System.DayOfWeek]::Friday `
)
$hkTimezone = 'Asia/Hong_Kong'

$User = "runbook"
$Password = ConvertTo-SecureString "runbookPassword" -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $Password

# New-AzAutomationAccount `
#   -ResourceGroup $resourceGroup `
#   -Name $aaName `
#   -Location 'japaneast'

# New-AzAutomationCredential `
#   -ResourceGroup $resourceGroup `
#   -AutomationAccountName $aaName `
#   -Name "RunbookCredentials" `
#   -Value $Credential

# $subscriptionId = (Get-AzSubscription).Id
# $FieldValues = @{"AutomationCertificateName"="RunbookCredentials";"SubscriptionID"=$subscriptionId}
# New-AzAutomationConnection `
#    -Name "RunbookConnection" `
#    -ConnectionTypeName "Azure" `
#    -ConnectionFieldValues $FieldValues `
#    -ResourceGroupName "TrainingResource" `
#    -AutomationAccountName $aaName

New-AzAutomationSchedule `
  -ResourceGroup $resourceGroup `
  -AutomationAccountName $aaName `
  -Name $name"-evening-stopvm" `
  -StartTime $eveningstop `
  -DaysOfWeek $weekdays `
  -TimeZone $hkTimezone `
  -Description "Stops all Resource Group VMs at night" `
  -WeekInterval 1

New-AzAutomationSchedule `
  -ResourceGroup $resourceGroup `
  -AutomationAccountName $aaName `
  -Name $name"-morning-startvm" `
  -StartTime $morningstart `
  -DaysOfWeek $weekdays `
  -TimeZone $hkTimezone `
  -Description "Starts all Resource Group VMs in the morning" `
  -WeekInterval 1

$runbooksdir = '/Users/cchoipalo/Websites/azure-hands-on/pwsh-scripts/runbooks'

$runbooks = Get-ChildItem -Path $runbooksdir -Name

foreach ($runbook in $runbooks) {
  $runbookName = [System.IO.Path]::GetFileNameWithoutExtension($runbook)

  write-output $runbooksdir'/'$runbook
  write-output $runbookName

  $existingRunbook = (Get-AzAutomationRunbook `
    -Name $runbookName `
    -ResourceGroupName $resourceGroup `
    -AutomationAccountName $aaName)

  if (!$existingRunbook) {
    New-AzAutomationRunbook `
      -Name $runbookName `
      -ResourceGroupName $resourceGroup `
      -AutomationAccountName $aaName `
      -Type 'PowerShell'
  }

  Import-AzAutomationRunbook `
    -Name $runbookName `
    -ResourceGroupName $resourceGroup `
    -AutomationAccountName $aaName `
    -Type PowerShell `
    -Path $runbooksdir/$runbook `
    -Force `
    -Published
}

write-output "-----LINKING RUNBOOKS TO SCHEDULES-----"

Unregister-AzAutomationScheduledRunbook `
  –AutomationAccountName $aaName `
  -ResourceGroupName $resourceGroup `
  –Name 'startstopvms' `
  –ScheduleName $name"-morning-startvm" `
  -Force

Unregister-AzAutomationScheduledRunbook `
  –AutomationAccountName $aaName `
  -ResourceGroupName $resourceGroup `
  –Name 'startstopvms' `
  –ScheduleName $name"-evening-stopvm" `
  -Force

$startParams = @{"VMAction"=$json.VMAction}
# $stopParams = @{"VMAction"="Stop"}

write-output $startParams
write-output $stopParams

Register-AzAutomationScheduledRunbook `
  –AutomationAccountName $aaName `
  -ResourceGroupName $resourceGroup `
  –Name 'startstopvms' `
  –ScheduleName $name"-morning-startvm" `
  –Parameters $startParams

Register-AzAutomationScheduledRunbook `
  –AutomationAccountName $aaName `
  -ResourceGroupName $resourceGroup `
  –Name 'startstopvms' `
  –ScheduleName $name"-evening-stopvm" `
  –Parameters $stopParams

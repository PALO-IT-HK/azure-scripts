(Get-AzKeyVaultSecret `
  -vaultName 'TrainingResource' `
  -name "Secret").SecretValueText

// Importing dependencies
const msRestAzure = require('ms-rest-azure');
const keyVault = require('azure-keyvault');
const app = require('express')();

// Initialize port
const port = process.env.PORT || 3000;

// Create Vault URL from App Settings
const vaultUrl = `https://${process.env.VaultName}.vault.azure.net/`;

// Map of key vault secret names to values
let vaultSecretsMap = {};

const authenticateToKeyVault = async () => {
  try {
    let credentials;
    if (process.env.NODE_ENV === 'production') {
      credentials = await msRestAzure.loginWithAppServiceMSI({ resource: 'https://vault.azure.net' });
    } else {
      // For non-App Service environments. Set the APP_ID, APP_SECRET and TENANT_ID environment
      // variables to use.
      const appId = process.env.APP_ID;
      const appSecret = process.env.APP_SECRET;
      const tenantId = process.env.TENANT_ID;
      credentials = await msRestAzure.loginWithServicePrincipalSecret(appId, appSecret, tenantId);
    }
    return credentials;
  } catch(err) {
    throw err.message;
  }
}

const getKeyVaultSecrets = async credentials => {
  // Create a key vault client
  let keyVaultClient = new keyVault.KeyVaultClient(credentials);
  try {
    let secrets = await keyVaultClient.getSecrets(vaultUrl);
    // For each secret name, get the secret value from the vault
    for (const secret of secrets) {
      // Only load enabled secrets - getSecret will return an error for disabled secrets
      if (secret.attributes.enabled) {
        let secretId = secret.id;
        let secretName = secretId.substring(secretId.lastIndexOf('/') + 1);
        let secretValue = await keyVaultClient.getSecret(vaultUrl, secretName, '');
        vaultSecretsMap[secretName] = secretValue.value;
      }
    }
  } catch(err) {
    console.log(err.message)
  }
}

app.get('/api/SecretTest', (req, res) => {
  let secretName = 'SecretPassword';
  let response;
  if (secretName in vaultSecretsMap) {
    response = `Secret value: ${vaultSecretsMap[secretName]}\n\nThis is for testing only! Never output a secret to a response or anywhere else in a real app!`;
  } else {
    response = `Error: No secret named ${secretName} was found...`
  }
  res.type('text');
  res.send(response);
});

(async () =>  {
  let credentials = await authenticateToKeyVault();
  await getKeyVaultSecrets(credentials);
  app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
  });
})().catch(err => console.log(err));

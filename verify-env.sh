#!/bin/bash

# 1. Fetch secrets from Vault
echo "--- Fetching secrets from Vault ---"
SECRET=$(vault kv get -format=json secret/dynatrace/automation)
CLIENT_ID=$(echo $SECRET | jq -r '.data.data.client_id')
CLIENT_SECRET=$(echo $SECRET | jq -r '.data.data.client_secret')
AUTH_URL=$(echo $SECRET | jq -r '.data.data.automation_env_url')
DT_URL=$(echo $SECRET | jq -r '.data.data.dt_env_url')

# 2. Verify Connectivity
echo "--- Checking Connectivity ---"
curl -I -s $DT_URL > /dev/null && echo "Dynatrace Live API: OK" || echo "Dynatrace Live API: FAILED"
curl -I -s $AUTH_URL > /dev/null && echo "Dynatrace Automation API: OK" || echo "Dynatrace Automation API: FAILED"

# 3. Verify OAuth2 Token Exchange (The likely source of 'invalid_request')
echo "--- Testing OAuth2 Token Exchange ---"
RESPONSE=$(curl -s -X POST "${AUTH_URL}/sso/oauth2/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=client_credentials" \
  -d "client_id=${CLIENT_ID}" \
  -d "client_secret=${CLIENT_SECRET}" \
  -d "scope=document:documents:read document:documents:write")

if [[ $RESPONSE == *"access_token"* ]]; then
  echo "OAuth2 Exchange: SUCCESS"
else
  echo "OAuth2 Exchange: FAILED"
  echo "Response: $RESPONSE"
fi
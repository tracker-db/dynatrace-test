#!/bin/bash
# Save this as create_client.sh
# Requires 'jq' installed (brew install jq)
# Requires 'vault' CLI configured and authenticated

# 1. ACCOUNT URN
ACCOUNT_URN="urn:dtaccount:8b22ecd8-4bf4-48f4-b258-01d0a51980f7"

echo "Please enter your Dynatrace Account Management API Token (starts with dt0s02...):"
read -s ACCOUNT_TOKEN
echo ""

# 2. RUN THE AUTOMATION
echo "Creating new OAuth2 client in Dynatrace..."
RESPONSE=$(curl -s -X POST "https://api.dynatrace.com/iam/v1/accounts/${ACCOUNT_URN}/oauth2/clients" \
     -H "Authorization: Bearer ${ACCOUNT_TOKEN}" \
     -H "Content-Type: application/json" \
     -d '{
           "name": "terraform-automation-client",
           "grantTypes": ["client_credentials"],
           "scopes": [
             "document:documents:read",
             "document:documents:write",
             "synthetic:monitors:read",
             "synthetic:monitors:write"
           ]
         }')

CLIENT_ID=$(echo "$RESPONSE" | jq -r '.id')
CLIENT_SECRET=$(echo "$RESPONSE" | jq -r '.secret')

if [ "$CLIENT_ID" == "null" ] || [ -z "$CLIENT_ID" ]; then
    echo "Failed to create client. API Response:"
    echo "$RESPONSE"
    exit 1
fi

echo "Client created successfully! ID: $CLIENT_ID"

# 3. PUSH TO VAULT
echo "Storing credentials in Vault at secret/dynatrace/automation..."
# Using vault kv patch to only update the client_id and client_secret without wiping out other values
vault kv patch secret/dynatrace/automation client_id="$CLIENT_ID" client_secret="$CLIENT_SECRET"

echo "Done! You can now run terraform apply."
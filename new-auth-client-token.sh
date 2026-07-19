#!/bin/bash
# Save this as create_client.sh
# Requires 'jq' installed (brew install jq)

# 1. REPLACE THESE TWO VALUES ONCE
ACCOUNT_URN="urn:dtaccount:8b22ecd8-4bf4-48f4-b258-01d0a51980f7"
ACCOUNT_TOKEN="PASTE_YOUR_ACCOUNT_API_TOKEN_HERE"

# 2. RUN THE AUTOMATION
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

# 3. OUTPUT THE RESULTS
echo "Client created successfully!"
echo $RESPONSE | jq -r '.id' > client_id.txt
echo $RESPONSE | jq -r '.secret' > client_secret.txt
echo "Client ID saved to client_id.txt"
echo "Client Secret saved to client_secret.txt"
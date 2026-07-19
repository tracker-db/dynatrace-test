#!/bin/bash
CLIENT_ID=$(vault kv get -field=client_id secret/dynatrace/automation)
CLIENT_SECRET=$(vault kv get -field=client_secret secret/dynatrace/automation)
TOKEN_URL="https://sso.dynatrace.com/sso/oauth2/token"
RESOURCE="urn:dtaccount:8b22ecd8-4bf4-48f4-b258-01d0a51980f7"

OAUTH_TOKEN=$(curl -s -X POST $TOKEN_URL \
  -d "grant_type=client_credentials" \
  -d "client_id=$CLIENT_ID" \
  -d "client_secret=$CLIENT_SECRET" \
  -d "resource=$RESOURCE" \
  -d "scope=document:documents:read document:documents:write" | jq -r .access_token)

echo "TOKEN: $OAUTH_TOKEN"
if [ "$OAUTH_TOKEN" != "null" ]; then
  curl -s -X GET "https://vav17921.apps.dynatrace.com/platform/document/v1/documents/e1d55e53-4441-4049-b35e-bdc9099bf04d" \
    -H "Authorization: Bearer $OAUTH_TOKEN" > doc_result.json
  cat doc_result.json | jq .
fi

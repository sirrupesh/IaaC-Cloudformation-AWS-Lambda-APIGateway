#!/bin/bash

# Get the API URL from the CloudFormation outputs
API_URL=$(aws cloudformation describe-stacks --stack-name calculator-api --query "Stacks[0].Outputs[?OutputKey=='ApiUrl'].OutputValue" --output text)

# Get the API Key ID from the CloudFormation outputs
API_KEY_ID=$(aws cloudformation describe-stacks --stack-name calculator-api --query "Stacks[0].Outputs[?OutputKey=='ApiKeyId'].OutputValue" --output text)

# Get the actual API Key value using the API Key ID
API_KEY=$(aws apigateway get-api-key --api-key $API_KEY_ID --include-value --query "value" --output text)

if [ -z "$API_KEY" ] || [ -z "$API_URL" ]; then
  echo "Error: Could not retrieve API Key or API URL. Make sure the stack is deployed."
  exit 1
fi

echo "Testing Add Operation..."
curl -X POST "${API_URL}/calculator/add" \
  -H "x-api-key: ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{"a": 5, "b": 3}'

echo -e "\n\nTesting Subtract Operation..."
curl -X POST "${API_URL}/calculator/subtract" \
  -H "x-api-key: ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{"a": 5, "b": 3}'

echo -e "\n"

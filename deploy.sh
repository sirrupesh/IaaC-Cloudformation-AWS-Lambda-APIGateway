#!/bin/bash

# Check if deployment-config.env exists
if [ ! -f deployment-config.env ]; then
  echo "Error: deployment-config.env not found. Run package.sh first."
  exit 1
fi

# Load deployment configuration
source deployment-config.env

# Deploy the CloudFormation stack
aws cloudformation deploy \
  --template-file template.yaml \
  --stack-name calculator-api \
  --capabilities CAPABILITY_IAM \
  --parameter-overrides \
    LambdaCodeBucket=$BUCKET_NAME \
    AddFunctionS3Key=$ADD_FUNCTION_KEY \
    SubtractFunctionS3Key=$SUBTRACT_FUNCTION_KEY

# Get the API URL from the CloudFormation outputs
API_URL=$(aws cloudformation describe-stacks --stack-name calculator-api --query "Stacks[0].Outputs[?OutputKey=='ApiUrl'].OutputValue" --output text)

# Get the API Key ID from the CloudFormation outputs
API_KEY_ID=$(aws cloudformation describe-stacks --stack-name calculator-api --query "Stacks[0].Outputs[?OutputKey=='ApiKeyId'].OutputValue" --output text)

# Get the actual API Key value using the API Key ID
API_KEY=$(aws apigateway get-api-key --api-key $API_KEY_ID --include-value --query "value" --output text)

echo "Deployment complete!"
echo "API URL: $API_URL"
echo "API Key: $API_KEY"

echo ""
echo "Example usage:"
echo "curl -X POST \"${API_URL}/calculator/add\" \\"
echo "  -H \"x-api-key: ${API_KEY}\" \\"
echo "  -H \"Content-Type: application/json\" \\"
echo "  -d '{\"a\": 5, \"b\": 3}'"
echo ""
echo "curl -X POST \"${API_URL}/calculator/subtract\" \\"
echo "  -H \"x-api-key: ${API_KEY}\" \\"
echo "  -H \"Content-Type: application/json\" \\"
echo "  -d '{\"a\": 5, \"b\": 3}'"

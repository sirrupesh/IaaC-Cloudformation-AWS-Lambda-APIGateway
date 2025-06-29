# Calculator API CloudFormation Project

This project deploys a simple calculator REST API using AWS CloudFormation. The API provides two endpoints:
- `/calculator/add` - Adds two numbers
- `/calculator/subtract` - Subtracts one number from another

## Architecture

The solution consists of:
- API Gateway REST API with API Key authentication
- Two Lambda functions (AddFunction and SubtractFunction)
- Lambda aliases for versioning and deployment management
- S3 bucket for Lambda code storage

![Architecture Diagram](./generated-diagrams/calculator-api-architecture.png.png)

## Prerequisites

- AWS CLI installed and configured
- An AWS account with permissions to create the required resources
- Bash shell environment
- zip utility installed

## Deployment Instructions

### Step 1: Package the Lambda Functions

Run the packaging script to prepare the Lambda code:

```bash
./package.sh
```

This script performs the following actions:
- Creates a unique S3 bucket for Lambda code storage
- Packages each Lambda function into a separate ZIP file
- Uploads the ZIP files to the S3 bucket
- Saves the deployment configuration (bucket name and S3 keys) to a local file

### Step 2: Deploy the CloudFormation Stack

After packaging the Lambda functions, deploy the CloudFormation stack:

```bash
./deploy.sh
```

This script:
- Reads the deployment configuration from the file created in Step 1
- Deploys the CloudFormation stack with the necessary parameters
- Creates all required resources (API Gateway, Lambda functions, IAM roles, etc.)
- Retrieves and displays the API URL and API Key for testing

## Testing the API

You can test the deployed API using the provided test script:

```bash
./test-api.sh
```

Or manually with curl commands:

```bash
# Get the API Key and API URL
API_KEY_ID=$(aws cloudformation describe-stacks --stack-name calculator-api --query "Stacks[0].Outputs[?OutputKey=='ApiKeyId'].OutputValue" --output text)
API_KEY=$(aws apigateway get-api-key --api-key $API_KEY_ID --include-value --query "value" --output text)
API_URL=$(aws cloudformation describe-stacks --stack-name calculator-api --query "Stacks[0].Outputs[?OutputKey=='ApiUrl'].OutputValue" --output text)

# Test the add operation
curl -X POST "${API_URL}/calculator/add" \
  -H "x-api-key: ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{"a": 5, "b": 3}'

# Test the subtract operation
curl -X POST "${API_URL}/calculator/subtract" \
  -H "x-api-key: ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{"a": 5, "b": 3}'
```

## Cleanup

When you're done with the project, you can remove all created resources:

```bash
./cleanup.sh
```

This script:
- Deletes the CloudFormation stack and all associated resources
- Empties the S3 bucket used for Lambda code storage
- Deletes the S3 bucket

## Project Structure

- `template.yaml` - CloudFormation template defining all resources
- `add_function.py` - Lambda function for addition operation
- `subtract_function.py` - Lambda function for subtraction operation
- `package.sh` - Script to package and upload Lambda functions
- `deploy.sh` - Script to deploy the CloudFormation stack
- `test-api.sh` - Script to test the deployed API
- `cleanup.sh` - Script to remove all resources
- `AmazonQ.md` - Detailed architecture documentation

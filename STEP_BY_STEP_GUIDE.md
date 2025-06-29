# Step-by-Step Deployment Guide

This guide provides detailed instructions for deploying the Calculator API using AWS CloudFormation.

## Prerequisites

Before you begin, ensure you have:

1. **AWS CLI installed and configured**:
   ```bash
   # Check if AWS CLI is installed
   aws --version
   
   # Configure AWS CLI with your credentials
   aws configure
   ```

2. **Required permissions**:
   - IAM permissions to create roles and policies
   - Lambda permissions to create functions
   - API Gateway permissions to create APIs
   - S3 permissions to create buckets and upload objects

3. **Zip utility installed**:
   ```bash
   # Check if zip is installed
   zip --version
   ```

## Detailed Deployment Steps

### Step 1: Clone or Download the Project

Ensure you have all the project files in your local directory.

### Step 2: Package the Lambda Functions

1. Make the packaging script executable:
   ```bash
   chmod +x package.sh
   ```

2. Run the packaging script:
   ```bash
   ./package.sh
   ```

3. Verify the output:
   - The script should create a unique S3 bucket
   - It should package and upload the Lambda functions
   - It should create a `deployment-config.env` file with the bucket name and S3 keys

### Step 3: Deploy the CloudFormation Stack

1. Make the deployment script executable:
   ```bash
   chmod +x deploy.sh
   ```

2. Run the deployment script:
   ```bash
   ./deploy.sh
   ```

3. Monitor the deployment:
   - The script will show the CloudFormation stack creation progress
   - Once complete, it will display the API URL and API Key

### Step 4: Test the API

1. Make the test script executable:
   ```bash
   chmod +x test-api.sh
   ```

2. Run the test script:
   ```bash
   ./test-api.sh
   ```

3. Verify the responses:
   - The add operation should return the sum of the two numbers
   - The subtract operation should return the difference

### Step 5: Clean Up Resources (When Done)

1. Make the cleanup script executable:
   ```bash
   chmod +x cleanup.sh
   ```

2. Run the cleanup script:
   ```bash
   ./cleanup.sh
   ```

3. Verify the cleanup:
   - The CloudFormation stack should be deleted
   - The S3 bucket should be emptied and deleted

## Troubleshooting

### Common Issues and Solutions

1. **AWS CLI not configured correctly**:
   - Run `aws configure` to set up your credentials

2. **Permission errors**:
   - Ensure your AWS user has the necessary permissions
   - Check IAM policies and roles

3. **S3 bucket name conflicts**:
   - The script creates a unique bucket name, but if there's a conflict, modify the bucket name in `package.sh`

4. **CloudFormation stack creation fails**:
   - Check the CloudFormation console for error details
   - Common issues include IAM permission problems or S3 access issues

5. **API returns 403 Forbidden**:
   - Ensure you're using the correct API Key
   - Verify the API Key is associated with the usage plan

## Manual Testing

If you want to test the API manually:

```bash
# Get the API Key and URL
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

#!/bin/bash

# Check if deployment-config.env exists
if [ ! -f deployment-config.env ]; then
  echo "Error: deployment-config.env not found. Cannot clean up resources."
  exit 1
fi

# Load deployment configuration
source deployment-config.env

# Delete the CloudFormation stack
echo "Deleting CloudFormation stack..."
aws cloudformation delete-stack --stack-name calculator-api

# Wait for the stack to be deleted
echo "Waiting for stack deletion to complete..."
aws cloudformation wait stack-delete-complete --stack-name calculator-api

# Empty and delete the S3 bucket
echo "Emptying S3 bucket..."
# aws s3 rm s3://$BUCKET_NAME --recursive

echo "Deleting S3 bucket..."
# aws s3api delete-bucket --bucket $BUCKET_NAME

echo "Cleanup complete!"

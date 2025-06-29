#!/bin/bash

# Create a unique S3 bucket name or use an existing one
BUCKET_NAME="calculator-api-lambda-$(date +%s)"
REGION="us-east-1"  # Change this to your preferred region

# Create directories for packaging
mkdir -p build

# Package the add function
echo "Packaging add function..."
zip -j build/add_function.zip add_function.py

# Package the subtract function
echo "Packaging subtract function..."
zip -j build/subtract_function.zip subtract_function.py

# Create the S3 bucket if it doesn't exist
echo "Creating S3 bucket..."
aws s3api create-bucket --bucket $BUCKET_NAME --region $REGION

# Upload the Lambda packages to S3
echo "Uploading Lambda packages to S3..."
aws s3 cp build/add_function.zip s3://$BUCKET_NAME/add_function.zip
aws s3 cp build/subtract_function.zip s3://$BUCKET_NAME/subtract_function.zip

echo "Lambda packages uploaded to s3://$BUCKET_NAME/"
echo "Use the following values for CloudFormation parameters:"
echo "LambdaCodeBucket: $BUCKET_NAME"
echo "AddFunctionS3Key: add_function.zip"
echo "SubtractFunctionS3Key: subtract_function.zip"

# Save these values to a file for later use
echo "BUCKET_NAME=$BUCKET_NAME" > deployment-config.env
echo "ADD_FUNCTION_KEY=add_function.zip" >> deployment-config.env
echo "SUBTRACT_FUNCTION_KEY=subtract_function.zip" >> deployment-config.env

# Calculator API Architecture

This document explains the architecture and design decisions for the Calculator API CloudFormation project.

## Architecture Overview

The Calculator API is built using the following AWS services:

1. **Amazon API Gateway**: Provides the REST API interface with API Key authentication
2. **AWS Lambda**: Hosts the serverless functions that perform the calculations
3. **Lambda Aliases**: Used for versioning and deployment management
4. **Amazon S3**: Stores the Lambda function code packages

![Architecture Diagram](./generated-diagrams/calculator-api-architecture.png.png)

## Design Decisions

### API Gateway

- **REST API**: We chose REST API over HTTP API for better integration with Lambda aliases and API Key support
- **API Key Authentication**: Provides a simple security mechanism to control access to the API
- **Resource Structure**: Organized as `/calculator/add` and `/calculator/subtract` for clarity and future extensibility
- **CORS Support**: Added OPTIONS methods and CORS headers for browser compatibility

### Lambda Functions

- **Separate Functions**: Each operation (add, subtract) has its own Lambda function for better separation of concerns
- **Python Runtime**: Used for simplicity and readability
- **Error Handling**: Includes proper error handling to return appropriate HTTP status codes
- **External Code Files**: Lambda code is stored in separate files and uploaded to S3 rather than embedded in the template

### Lambda Aliases

- **Live Alias**: Each Lambda function has a "live" alias that points to the current production version
- **Versioning**: Enables blue/green deployments and rollbacks if needed
- **API Integration**: API Gateway integrates with the Lambda aliases rather than directly with the functions

### S3 Storage

- **Code Packaging**: Lambda function code is packaged into ZIP files and stored in S3
- **Unique Bucket**: A unique S3 bucket is created for each deployment to avoid naming conflicts
- **Deployment Automation**: The packaging and deployment process is automated with scripts

### CloudFormation

- **Infrastructure as Code**: The entire infrastructure is defined as code for repeatability and consistency
- **Parameterization**: Uses parameters for S3 bucket and key names to separate code from infrastructure
- **Outputs**: Provides the API URL and API Key ID as outputs for easy access
- **IAM Roles**: Creates the necessary IAM roles with least privilege permissions

## Security Considerations

1. **API Key**: All API requests require an API key for authentication
2. **IAM Roles**: Lambda functions use IAM roles with minimal required permissions
3. **Input Validation**: Lambda functions validate input to prevent injection attacks
4. **API Key Security**: The API Key ID (not the actual key) is exposed as a CloudFormation output
5. **CORS Configuration**: Properly configured CORS headers to control cross-origin requests

## Deployment Strategy

The deployment is managed through a two-step process:

1. **Packaging (package.sh)**:
   - Creates an S3 bucket for Lambda code
   - Packages Lambda functions into ZIP files
   - Uploads packages to S3
   - Saves deployment configuration

2. **Deployment (deploy.sh)**:
   - Reads the deployment configuration
   - Deploys the CloudFormation stack with parameters
   - Retrieves and displays the API URL and API Key

## Testing

After deployment, you can test the API using curl commands:

```bash
# Add operation
curl -X POST "${API_URL}/calculator/add" \
  -H "x-api-key: ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{"a": 5, "b": 3}'

# Subtract operation
curl -X POST "${API_URL}/calculator/subtract" \
  -H "x-api-key: ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{"a": 5, "b": 3}'
```

## Future Enhancements

1. Add more mathematical operations (multiply, divide, etc.)
2. Implement request throttling for better resource management
3. Add CloudWatch alarms for monitoring
4. Implement AWS WAF for additional security
5. Add custom domain name with API Gateway domain name
6. Implement CI/CD pipeline for automated deployments

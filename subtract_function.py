import json

def lambda_handler(event, context):
    try:
        # Parse the input from the event body
        body = json.loads(event.get('body', '{}'))
        
        # Extract the numbers to subtract
        a = float(body.get('a', 0))
        b = float(body.get('b', 0))
        
        # Perform the subtraction
        result = a - b
        
        # Return the result
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'POST, OPTIONS',
                'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key'
            },
            'body': json.dumps({
                'result': result,
                'operation': 'subtract',
                'a': a,
                'b': b
            })
        }
    except Exception as e:
        return {
            'statusCode': 400,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'error': str(e)
            })
        }

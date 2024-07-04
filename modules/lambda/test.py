import json
import requests

def handler(event, context):
    # TODO implement
    return {
        'statusCode': 200,
        'body': json.dumps('this is bill nye, please leave')
    }
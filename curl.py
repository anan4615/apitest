import requests
from requests.exceptions import HTTPError

def message_count():
    headers = {
        'content-type': 'application/json',
    }

    response = requests.get('http://atap-prov-dev.int.colorado.edu:15672/api/queues/%2F/auto-course-creation', headers=headers, auth=('test-user', 'test-pass'))
    jsonResponse = response.json()
    print(response.json())
    Messages = jsonResponse["messages"]
    print("Message status:"+" "+ str(Messages))


    if (Messages == 0):
        print("Queue is empty")
        return ("Queue is empty:" +str(Messages))
    else:
        print("Queue is not empty")
        return ("Queue is not empty:" +" "+ str(Messages))
# try:
#     r=message_count()
# except HTTPError as http_err:
#         print(f'HTTP error occurred: {http_err}')
# except Exception as err:
#         print(f'Other error occurred: {err}')

message_count()
import requests
from requests.auth import HTTPBasicAuth
import json

url = "provide atlassian.net url"

API_TOKEN=""

auth = HTTPBasicAuth("", API_TOKEN)

headers = {
  "Accept": "application/json"
}

response = requests.request(
   "GET",
   url,
   headers=headers,
   auth=auth
)

output = json.loads(response.text)

name = output[0]["name"]

print(name)

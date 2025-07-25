import requests
import os
from dotenv import load_dotenv

load_dotenv()

ORG_NAME = os.getenv("gitORG")
REPO_NAME = os.getenv("NAME")
GITHUB_TOKEN = os.getenv("gitPAT")

url = f"https://api.github.com/orgs/{ORG_NAME}/repos"
headers = {
    "Authorization": f"token {GITHUB_TOKEN}",
    "Accept": "application/vnd.github.v3+json",
}
data = {
    "name": REPO_NAME,
    "private": True,
    "description": "My new organization repository",
}

response = requests.post(url, headers=headers, json=data)

if response.status_code == 201:
    print(f"Repository '{REPO_NAME}' created successfully.")
else:
    print(f"Error creating repository: {response.status_code} - {response.text}")

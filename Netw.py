import requests
import random
import string

# Generate a random name between 4-7 characters
def generate_random_name(length=4):
    return ''.join(random.choices(string.ascii_letters, k=length))

# Create a KV namespace
def create_kv_namespace(api_token, account_id, namespace_name):
    url = f"https://api.cloudflare.com/client/v4/accounts/{account_id}/storage/kv/namespaces"
    headers = {
        "Authorization": f"Bearer {api_token}",
        "Content-Type": "application/json"
    }
    data = {
        "title": namespace_name
    }
    response = requests.post(url, headers=headers, json=data)
    return response.json()

# Create a worker
def create_worker(api_token, account_id, worker_name, script):
    url = f"https://api.cloudflare.com/client/v4/accounts/{account_id}/workers/scripts/{worker_name}"
    headers = {
        "Authorization": f"Bearer {api_token}",
        "Content-Type": "application/javascript"
    }
    response = requests.put(url, headers=headers, data=script)
    return response.json()

# Bind KV namespace to worker
def bind_kv_to_worker(api_token, account_id, worker_name, kv_namespace_id):
    url = f"https://api.cloudflare.com/client/v4/accounts/{account_id}/workers/scripts/{worker_name}/bindings"
    headers = {
        "Authorization": f"Bearer {api_token}",
        "Content-Type": "application/json"
    }
    data = {
        "name": "bpb",
        "type": "kv_namespace",
        "namespace_id": kv_namespace_id
    }
    response = requests.post(url, headers=headers, json=data)
    return response.json()

# Main function
def main():
    # Get Cloudflare API details from user input
    api_token = input("Enter your Cloudflare API token: ")
    account_id = input("Enter your Cloudflare account ID: ")
    zone_id = input("Enter your Cloudflare zone ID: ")

    worker_name = generate_random_name(random.randint(4, 7))
    kv_namespace_name = generate_random_name(random.randint(4, 7))

    # Create KV namespace
    kv_response = create_kv_namespace(api_token, account_id, kv_namespace_name)
    kv_namespace_id = kv_response['result']['id']

    # Fetch JavaScript code from the provided link
    js_url = "https://raw.githubusercontent.com/Kolandone/Selector/main/worker.js"
    js_code = requests.get(js_url).text

    # Create worker with the fetched JavaScript code
    worker_response = create_worker(api_token, account_id, worker_name, js_code)

    # Bind KV namespace to worker
    bind_response = bind_kv_to_worker(api_token, account_id, worker_name, kv_namespace_id)

    # Generate visit link
    visit_link = f"https://{worker_name}.{account_id}.workers.dev/panel"

    print(f"Worker created: {worker_name}")
    print(f"KV Namespace created: {kv_namespace_name}")
    print(f"Visit link: {visit_link}")

if __name__ == "__main__":
    main()

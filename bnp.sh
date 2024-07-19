#!/bin/bash

# Ensure necessary tools are installed
install_dependencies() {
    pkg update
    if ! command -v curl &> /dev/null; then
        echo "curl not found. Installing curl..."
        pkg install -y curl
    else
        echo "curl is already installed."
    fi

    if ! command -v jq &> /dev/null; then
        echo "jq not found. Installing jq..."
        pkg install -y jq
    else
        echo "jq is already installed."
    fi
}

# Generate a random name with 4-8 characters (A-Z, a-z)
generate_random_name() {
    local length=$((RANDOM % 5 + 4))  # Random length between 4 and 8
    cat /dev/urandom | tr -dc 'A-Za-z' | fold -w "$length" | head -n 1
}

# Get credentials from user
get_credentials() {
    read -p "Enter your Cloudflare API token: " CF_API_TOKEN
    read -p "Enter your Cloudflare account ID: " CF_ACCOUNT_ID
}

# Create a new Worker
create_worker() {
    local worker_name=$(generate_random_name)
    echo "Creating a new Worker with name: $worker_name"

    # Download the worker script
    curl -s -o worker.js https://raw.githubusercontent.com/Kolandone/Selector/main/worker.js

    # Upload the Worker script
    response=$(curl -s -w "%{http_code}" -o response_body.txt -X PUT "https://api.cloudflare.com/client/v4/accounts/${CF_ACCOUNT_ID}/workers/scripts/${worker_name}" \
         -H "Authorization: Bearer ${CF_API_TOKEN}" \
         -H "Content-Type: application/javascript" \
         --data-binary @worker.js)

    if [ "$response" -ne 200 ]; then
        echo "Failed to create the Worker. HTTP Status Code: $response"
        echo "Response Body: $(cat response_body.txt)"
        echo "Check the content of worker.js and ensure it is a valid Cloudflare Worker script."
        exit 1
    fi

    echo "$worker_name"
}

# Create a KV namespace
create_kv_namespace() {
    local kv_name=$(generate_random_name)
    echo "Creating KV namespace with name: $kv_name"

    response=$(curl -s -w "%{http_code}" -o response_body.txt -X POST "https://api.cloudflare.com/client/v4/accounts/${CF_ACCOUNT_ID}/storage/kv/namespaces" \
                 -H "Authorization: Bearer ${CF_API_TOKEN}" \
                 -H "Content-Type: application/json" \
                 --data "{\"title\":\"${kv_name}\"}")

    kv_id=$(curl -s -X GET "https://api.cloudflare.com/client/v4/accounts/${CF_ACCOUNT_ID}/storage/kv/namespaces" \
                 -H "Authorization: Bearer ${CF_API_TOKEN}" | jq -r --arg kv_name "$kv_name" '.result[] | select(.title == $kv_name) | .id')

    if [ "$response" -ne 200 ] || [ "$kv_id" == "null" ]; then
        echo "Failed to create KV namespace. HTTP Status Code: $response"
        echo "Response Body: $(cat response_body.txt)"
        echo "Check if the API endpoint and data format are correct."
        exit 1
    fi

    echo "$kv_id"
}

# Bind KV namespace to a Worker
bind_kv_namespace() {
    local worker_name=$1
    local kv_id=$2

    echo "Binding KV namespace $kv_id to Worker $worker_name with variable name 'bpb'"

    bindings=$(jq -n \
        --arg kv_id "$kv_id" \
        '{
            "kv_namespaces": [
                {
                    "binding": "bpb",
                    "id": $kv_id
                }
            ]
        }')

    response=$(curl -s -w "%{http_code}" -o response_body.txt -X PUT "https://api.cloudflare.com/client/v4/accounts/${CF_ACCOUNT_ID}/workers/scripts/${worker_name}/bindings" \
         -H "Authorization: Bearer ${CF_API_TOKEN}" \
         -H "Content-Type: application/json" \
         --data "$bindings")

    if [ "$response" -ne 200 ]; then
        echo "Failed to bind KV namespace. HTTP Status Code: $response"
        echo "Response Body: $(cat response_body.txt)"
        echo "Check the API endpoint and ensure the binding data format is correct."
        exit 1
    fi
}

# Main script execution
install_dependencies
get_credentials
worker_name=$(create_worker)
kv_id=$(create_kv_namespace)
bind_kv_namespace "$worker_name" "$kv_id"

worker_url="https://${worker_name}.workers.dev/panel"
echo "Worker $worker_name created and bound to KV namespace with ID $kv_id and variable name 'bpb'."
echo "You can visit your Worker at: $worker_url"

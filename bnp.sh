#!/bin/bash

# Ensure necessary tools are installed

# Function to check and install dependencies
install_dependencies() {
    # Update package list
    pkg update

    # Install curl if not installed
    if ! command -v curl &> /dev/null; then
        echo "curl not found. Installing curl..."
        pkg install -y curl
    else
        echo "curl is already installed."
    fi

    # Install jq if not installed
    if ! command -v jq &> /dev/null; then
        echo "jq not found. Installing jq..."
        pkg install -y jq
    else
        echo "jq is already installed."
    fi
}

# Function to generate a random name
generate_random_name() {
    cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 10 | head -n 1
}

# Function to prompt for API token, account ID, and zone ID
get_credentials() {
    read -p "Enter your Cloudflare API token: " CF_API_TOKEN
    read -p "Enter your Cloudflare account ID: " CF_ACCOUNT_ID
    read -p "Enter your Cloudflare zone ID: " CF_ZONE_ID
}

# Function to create a new Worker with a random name
create_worker() {
    local worker_name=$(generate_random_name)
    echo "Creating a new Worker with name: $worker_name"

    # Create the Worker
    curl -X PUT "https://api.cloudflare.com/client/v4/accounts/${CF_ACCOUNT_ID}/workers/scripts/${worker_name}" \
         -H "Authorization: Bearer ${CF_API_TOKEN}" \
         -H "Content-Type: application/javascript" \
         --data-binary @<(curl -s https://raw.githubusercontent.com/bia-pain-bache/BPB-Worker-Panel/main/_worker.js)

    if [ $? -ne 0 ]; then
        echo "Failed to create the Worker"
        exit 1
    fi

    echo "$worker_name"
}

# Function to create a KV namespace with a random name
create_kv_namespace() {
    local kv_name=$(generate_random_name)
    echo "Creating KV namespace with name: $kv_name"

    kv_id=$(curl -X POST "https://api.cloudflare.com/client/v4/accounts/${CF_ACCOUNT_ID}/storage/kv/namespaces" \
                 -H "Authorization: Bearer ${CF_API_TOKEN}" \
                 -H "Content-Type: application/json" \
                 --data "{\"title\":\"${kv_name}\"}" | jq -r '.result.id')

    if [ $? -ne 0 ] || [ "$kv_id" == "null" ]; then
        echo "Failed to create KV namespace"
        exit 1
    fi

    echo "$kv_id"
}

# Function to bind a KV namespace to a Worker
bind_kv_namespace() {
    local worker_name=$1
    local kv_id=$2

    echo "Binding KV namespace $kv_id to Worker $worker_name with variable name 'bpb'"

    # Create a binding configuration
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

    # Upload the binding configuration
    curl -X PUT "https://api.cloudflare.com/client/v4/accounts/${CF_ACCOUNT_ID}/workers/scripts/${worker_name}/bindings" \
         -H "Authorization: Bearer ${CF_API_TOKEN}" \
         -H "Content-Type: application/json" \
         --data "$bindings"

    if [ $? -ne 0 ]; then
        echo "Failed to bind KV namespace"
        exit 1
    fi
}

# Main script execution
install_dependencies
get_credentials
worker_name=$(create_worker)
kv_id=$(create_kv_namespace)
bind_kv_namespace "$worker_name" "$kv_id"

worker_url="https://${worker_name}.${CF_ZONE_ID}.workers.dev/panel"
echo "Worker $worker_name created and bound to KV namespace with ID $kv_id and variable name 'bpb'."
echo "You can visit your Worker at: $worker_url"

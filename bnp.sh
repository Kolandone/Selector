#!/bin/bash

# Ensure wrangler is authenticated and configured correctly
echo "Installing wrangler..."
npm install -g wrangler

# Authenticate wrangler
echo "Authenticating wrangler..."
wrangler login

# Verify wrangler setup
echo "Verifying wrangler setup..."
wrangler whoami || { echo "Wrangler authentication failed. Please check your credentials."; exit 1; }

# Function to generate a random name
generate_random_name() {
    cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 10 | head -n 1
}

# Function to prompt for API token and account ID
get_credentials() {
    read -p "Enter your Cloudflare API token: " CF_API_TOKEN
    read -p "Enter your Cloudflare account ID: " CF_ACCOUNT_ID
}

# Function to create a new Worker with a random name and custom code
create_worker() {
    local worker_name=$(generate_random_name)
    echo "Creating a new Worker with name: $worker_name"
    mkdir -p "$worker_name"
    cd "$worker_name" || { echo "Failed to change directory to $worker_name"; exit 1; }
    curl -O https://raw.githubusercontent.com/bia-pain-bache/BPB-Worker-Panel/main/_worker.js
    cat <<EOT > wrangler.toml
name = "$worker_name"
type = "javascript"
account_id = "$CF_ACCOUNT_ID"
workers_dev = true
EOT
    CF_API_TOKEN="$CF_API_TOKEN" wrangler publish
    cd ..
    echo "$worker_name"
}

# Function to create a KV namespace with a random name
create_kv_namespace() {
    local kv_name=$(generate_random_name)
    echo "Creating KV namespace with name: $kv_name"
    kv_id=$(CF_API_TOKEN="$CF_API_TOKEN" wrangler kv:namespace create "$kv_name" | grep -oP '(?<=id": ")[^"]+')
    echo "$kv_id"
}

# Function to bind a KV namespace to a Worker
bind_kv_namespace() {
    local worker_name=$1
    local kv_id=$2
    echo "Binding KV namespace $kv_id to Worker $worker_name with variable name 'bpb'"
    cd "$worker_name" || { echo "Failed to change directory to $worker_name"; exit 1; }
    cat <<EOT >> wrangler.toml
[[kv_namespaces]]
binding = "bpb"
id = "$kv_id"
EOT
    CF_API_TOKEN="$CF_API_TOKEN" wrangler publish
    cd ..
}

# Main script execution
get_credentials
worker_name=$(create_worker)
kv_id=$(create_kv_namespace)
bind_kv_namespace "$worker_name" "$kv_id"

worker_url="https://${worker_name}.workers.dev/panel"
echo "Worker $worker_name created and bound to KV namespace with ID $kv_id and variable name 'bpb'."
echo "You can visit your Worker at: $worker_url"

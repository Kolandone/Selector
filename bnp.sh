#!/bin/bash

# Ensure necessary tools are installed
apt-get update && apt-get upgrade
apt install termux-api
# Function to check and install npm
install_npm() {
    if ! command -v npm &> /dev/null; then
        echo "npm not found. Installing npm..."
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            apt install -y nodejs npm
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            brew install node
        else
            echo "Unsupported OS. Please install npm manually from https://nodejs.org/"
            exit 1
        fi
    else
        echo "npm is already installed."
    fi
}

# Function to check and install wrangler
install_wrangler() {
    if ! command -v wrangler &> /dev/null; then
        echo "wrangler not found. Installing wrangler..."
        npm install -g wrangler
    else
        echo "wrangler is already installed."
    fi
}

# Authenticate wrangler
authenticate_wrangler() {
    echo "Authenticating wrangler..."
    wrangler login
    echo "Verifying wrangler setup..."
    if ! wrangler whoami; then
        echo "Wrangler authentication failed. Please check your credentials."
        exit 1
    fi
}

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
install_npm
install_wrangler
authenticate_wrangler
get_credentials
worker_name=$(create_worker)
kv_id=$(create_kv_namespace)
bind_kv_namespace "$worker_name" "$kv_id"

worker_url="https://${worker_name}.workers.dev/panel"
echo "Worker $worker_name created and bound to KV namespace with ID $kv_id and variable name 'bpb'."
echo "You can visit your Worker at: $worker_url"

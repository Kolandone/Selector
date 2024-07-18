#!/bin/bash
clear
# Display the title in multiple colors and big size
echo -e "\e[1;31mY\e[1;32mO\e[1;33mU\e[1;34mT\e[1;35mU\e[1;36mB\e[1;37mE\e[0m : \e[1;31mK\e[1;32mO\e[1;33mL\e[1;34mA\e[1;35mN\e[1;36mD\e[1;37mO\e[1;31mN\e[1;32mE\e[0m"

echo "Please choose an option:"
echo "1. IPv4 scan"
echo "2. IPv6 scan"
echo "3. V2ray and MahsaNG wireguard config"
echo -e "4. Hiddify config, After the first use, you can enter the \e[1;32mKOLAND\e[0m command"
echo "Enter your choice:" 
read -r user_input

measure_latency() {
    local ip_port=$1
    local ip=$(echo $ip_port | cut -d: -f1)
    local port=$(echo $ip_port | cut -d: -f2)
    local ping_output=$(ping -c 4 -W 1 $ip | tail -n 2)
    local latency=$(echo "$ping_output" | grep 'rtt' | awk -F'/' '{print $5}')
    local packet_loss=$(echo "$ping_output" | grep 'loss' | awk -F',' '{print $3}' | awk '{print $1}')
    local jitter=$(echo "$ping_output" | grep 'rtt' | awk -F'/' '{print $7 - $6}')
    if [ -z "$latency" ]; then
        latency="N/A"
        packet_loss="N/A"
        jitter="N/A"
    fi
    if command -v bc &> /dev/null; then
        local score=$(echo "scale=2; $latency + $jitter" | bc)
    else
        local score="N/A"
    fi
    printf "| %-15s | %-10s | %-10s | %-15s | %-10s | %-10s |\n" "$ip" "$port" "$latency" "$packet_loss" "$jitter" "$score"
}

measure_latency6() {
    local ip_port=$1
    local ip=$(echo $ip_port | cut -d: -f1)
    local port=$(echo $ip_port | cut -d: -f2)
    local ping_output=$(ping6 -c 4 -W 1 $ip | tail -n 2)
    local latency=$(echo "$ping_output" | grep 'rtt' | awk -F'/' '{print $5}')
    local packet_loss=$(echo "$ping_output" | grep 'loss' | awk -F',' '{print $3}' | awk '{print $1}')
    local jitter=$(echo "$ping_output" | grep 'rtt' | awk -F'/' '{print $7 - $6}')
    if [ -z "$latency" ]; then
        latency="N/A"
        packet_loss="N/A"
        jitter="N/A"
    fi
    if command -v bc &> /dev/null; then
        local score=$(echo "scale=2; $latency + $jitter" | bc)
    else
        local score="N/A"
    fi
    printf "| %-45s | %-10s | %-10s | %-15s | %-10s | %-10s |\n" "$ip" "$port" "$latency" "$packet_loss" "$jitter" "$score"
}

display_ipv4_table() {
    printf "+-----------------+------------+------------+-----------------+------------+------------+\n"
    printf "| IP              | Port       | Ping(ms)   | Packet Loss(%)  | Jitter(ms) | Score      |\n"
    printf "+-----------------+------------+------------+-----------------+------------+------------+\n"
    echo "$1" | while read -r ip_port; do measure_latency "$ip_port"; done
    printf "+-----------------+------------+------------+-----------------+------------+------------+\n"
}

display_ipv6_table() {
    printf "+-----------------------------------------------+------------+------------+-----------------+------------+------------+\n"
    printf "| IP                                            | Port       | Ping(ms)   | Packet Loss(%)  | Jitter(ms) | Score      |\n"
    printf "+-----------------------------------------------+------------+------------+-----------------+------------+------------+\n"
    echo "$1" | while read -r ip_port; do measure_latency6 "$ip_port"; done
    printf "+-----------------------------------------------+------------+------------+-----------------+------------+------------+\n"
}

if [ "$user_input" -eq 1 ]; then
    echo "Fetching IPv4 addresses from install.sh..."
    ip_list=$(echo "1" | bash <(curl -fsSL https://raw.githubusercontent.com/Ptechgithub/warp/main/endip/install.sh) | grep -oP '(\d{1,3}\.){3}\d{1,3}:\d+')
    clear
    display_ipv4_table "$ip_list"
elif [ "$user_input" -eq 2 ]; then
    echo "Fetching IPv6 addresses from install.sh..."
    ip_list=$(echo "2" | bash <(curl -fsSL https://raw.githubusercontent.com/Ptechgithub/warp/main/endip/install.sh) | grep -oP '(\[?[a-fA-F\d:]+\]?\:\d+)')
    clear
    display_ipv6_table "$ip_list"
elif [ "$user_input" -eq 3 ]; then
    bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/V2/main/koland.sh)
elif [ "$user_input" -eq 4 ]; then
    bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/Hidify/main/install.sh)
    KOLAND
else
    echo "Invalid input. Please enter 1, 2, 3, or 4."
fi

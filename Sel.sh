#!/bin/bash

cyan="\e[1;36m"
green="\e[1;32m"
yellow="\e[1;33m"
purple="\e[1;35m"
red="\e[1;31m"
reset="\e[0m"

loading_animation() {
    local spinstr='|/-\'
    local i=0
    while true; do
        local temp=${spinstr#?}
        printf "${green} [%c] Loading...${reset} \r" "$spinstr"
        spinstr=$temp${spinstr%"$temp"}
        sleep 0.1
        ((i++))
        if [ $i -eq 20 ]; then break; fi
    done
    printf "\r\033[K"
}

save_results() {
    local results="$1"
    local filename="$2"
    echo "$results" > "$filename"
    echo -e "${green}Results saved to $filename${reset}"
}

check_dependencies() {
    echo -e "${green}Checking dependencies...${reset}"
    local deps=("curl" "jq" "wg" "ping" "ping6")
    for dep in "${deps[@]}"; do
        if command -v "$dep" &>/dev/null; then
            echo -e "${green}$dep: Installed${reset}"
        else
            echo -e "${red}$dep: Not installed${reset}"
        fi
    done
}

measure_latency() {
    local ip_port=$1
    local ip=$(echo $ip_port | cut -d: -f1)
    local latency=$(ping -c 1 -W 1 $ip | grep 'time=' | awk -F'time=' '{ print $2 }' | cut -d' ' -f1)
    if [ -z "$latency" ]; then
        latency="N/A"
    fi
    printf "| %-21s | %-10s |\n" "$ip_port" "$latency"
}

measure_latency6() {
    local ip_port=$1
    local ip=$(echo $ip_port | cut -d'[' -f2 | cut -d']' -f1)
    local latency=$(ping6 -c 1 -W 1 $ip | grep 'time=' | awk -F'time=' '{ print $2 }' | cut -d' ' -f1)
    if [ -z "$latency" ]; then
        latency="N/A"
    fi
    printf "| %-45s | %-10s |\n" "$ip_port" "$latency"
}

display_table_ipv4() {
    printf "+-----------------------+------------+\n"
    printf "| IP:Port               | Latency(ms) |\n"
    printf "+-----------------------+------------+\n"
    echo "$1" | head -n 10 | while read -r ip_port; do measure_latency "$ip_port"; done
    printf "+-----------------------+------------+\n"
}

display_table_ipv6() {
    printf "+---------------------------------------------+------------+\n"
    printf "| IP:Port                                     | Latency(ms) |\n"
    printf "+---------------------------------------------+------------+\n"
    echo "$1" | head -n 10 | while read -r ip_port; do measure_latency6 "$ip_port"; done
    printf "+---------------------------------------------+------------+\n"
}

cloner() {
    if ! command -v wg &>/dev/null; then
        if [ -d "$PREFIX" ] && [ "$(uname -o)" = "Android" ]; then
            echo "Installing wireguard-tools"
            pkg install wireguard-tools -y
            pkg install jq -y
        elif [ -x "$(command -v apt)" ]; then
            echo "Installing wireguard-tools on Debian/Ubuntu"
            sudo apt update -y && sudo apt install wireguard-tools -y
        elif [ -x "$(command -v yum)" ]; then
            echo "Installing wireguard-tools on CentOS/RHEL"
            sudo yum install epel-release -y && sudo yum install kmod-wireguard wireguard-tools -y
        elif [ -x "$(command -v dnf)" ]; then
            echo "Installing wireguard-tools on Fedora"
            sudo dnf install wireguard-tools -y
        elif [ -x "$(command -v zypper)" ]; then
            echo "Installing wireguard-tools on openSUSE"
            sudo zypper install wireguard-tools -y
        fi
    fi

    licenses=(
        "0L156IFo-Xlou7509-cL0kj975"
        "1E987bRY-KI8167Rp-2cO3I5a0"
        "450sxY1P-0927yEPv-538cGDa0"
        "82gHq31I-785W3PSO-1rW35X9v"
        "BQ91v37L-s296aVH3-5p34vXS6"
        "8NP103zQ-u2T68YS3-b3Cy25H9"
        "6M10oEq7-HA0h5y92-F42KMv61"
        "Pi0n45K6-24ON7A1C-7Q18My2n"
        "q36pSa91-240vtF1s-F25r10gZ"
        "H9y510oc-PR53o01f-cW176f0y"
        "Y4v03C5u-Ad81i3z5-PQ30z45f"
        "8V2hX14D-D0SR78w3-2ule45m3"
        "7V9p34gb-9hlI5Y64-C35dO6l2"
        "MAa9251S-M19y53Hb-05cJ2hS4"
        "R7k0j3p4-5B14RK6p-C8F6vw72"
        "X16yb7g2-1P3fH56y-x8L7e1D0"
        "5hc0L42Z-f15su76j-r0N8ia43"
        "8wnc27d1-C5F3d2y9-45eKs3F9"
        "05skL7r1-d683ZSB0-7RrT964j"
        "iTP2I901-821KdD5h-2840MpQv"
        "14b68TNu-v801R2Mi-690t7vYu"
        "QPIE0458-1VDX92W5-70e2iNA3"
        "53RN8G7d-24J59kYR-08b4v9RU"
        "G438E2Ve-uH4sE653-Kn53fJ76"
        "21Ig0LE8-47emp59P-N190Vf5z"
    )

    echo -e "${cyan}######################${reset}"
    echo -en "${green}Enter a license (${yellow}Press Enter to use a random license, may not work${green}): ${reset}"
    read -r input_license

    if [ -z "$input_license" ]; then
        license=$(shuf -n 1 -e "${licenses[@]}")
    else
        license="$input_license"
    fi
    echo -e "${cyan}######################${reset}"
    echo -e "${purple}🔥 Warp License Cloner 🔥${reset}"
    echo -e "${green}Starting...${reset}"
    echo -e "${purple}-------------------------------------${reset}"

    if command -v wg &>/dev/null; then
        private_key=$(wg genkey)
        public_key=$(wg pubkey <<<"$private_key")
    else
        wg_api=$(curl -m5 -sSL https://wg-key.forvps.gq/)
        private_key=$(awk 'NR==2 {print $2}' <<<"$wg_api")
        public_key=$(awk 'NR==1 {print $2}' <<<"$wg_api")
    fi
    install_id=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 22)
    fcm_token="${install_id}:APA91b$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 134)"
    rand=$(tr -dc '0-9' </dev/urandom | head -c 3)

    response=$(curl --request POST "https://api.cloudflareclient.com/v0a${rand}/reg" \
        --silent \
        --location \
        --tlsv1.3 \
        --header 'User-Agent: okhttp/3.12.1' \
        --header "CF-Client-Version: a-6.33-${rand}" \
        --header 'Content-Type: application/json' \
        --data '{
            "key": "'"${public_key}"'",
            "install_id": "'"${install_id}"'",
            "fcm_token": "'"${fcm_token}"'",
            "tos": "'"$(date +"%Y-%m-%dT%H:%M:%S.000Z")"'",
            "model": "PC",
            "serial_number": "'"${install_id}"'",
            "locale": "en_US"
        }')

    echo "$response" | jq . >warp-config.json
    id=$(jq -r '.id' <warp-config.json)
    token=$(jq -r '.token' <warp-config.json)

    response=$(curl --request PUT "https://api.cloudflareclient.com/v0a${rand}/reg/${id}/account" \
        --silent \
        --location \
        --header 'User-Agent: okhttp/3.12.1' \
        --header "CF-Client-Version: a-6.33-${rand}" \
        --header 'Content-Type: application/json' \
        --header "Authorization: Bearer ${token}" \
        --data '{
            "license": "'"$license"'"
        }')

    patch_one_response=$(curl -X PATCH "https://api.cloudflareclient.com/v0a${rand}/reg/${id}/account" \
        --silent \
        --location \
        --header 'User-Agent: okhttp/3.12.1' \
        --header "CF-Client-Version: a-6.33-${rand}" \
        --header 'Content-Type: application/json' \
        --header "Authorization: Bearer ${token}" \
        --data '{"active": true}')

    get_response=$(curl -X GET "https://api.cloudflareclient.com/v0a${rand}/reg/${id}" \
        --silent \
        --header "Authorization: Bearer ${token}" \
        --header "Accept: application/json" \
        --header "Accept-Encoding: gzip" \
        --header "Cf-Client-Version: a-6.3-${rand}" \
        --header "User-Agent: okhttp/3.12.1" \
        --output - | gunzip -c | jq .)

    id=$(echo "$get_response" | jq -r '.id')
    balance=$(echo "$get_response" | jq -r '.account.quota')
    quota=$((balance / 1000000000))

    license=$(jq -r '.account.license' <warp-config.json)

    response=$(curl --request PUT "https://api.cloudflareclient.com/v0a${rand}/reg/${id}/account" \
        --silent \
        --location \
        --header 'User-Agent: okhttp/3.12.1' \
        --header "CF-Client-Version: a-6.33-${rand}" \
        --header 'Content-Type: application/json' \
        --header "Authorization: Bearer ${token}" \
        --data '{
            "license": "'"$license"'"
        }')

    patch_two_response=$(curl -X PATCH "https://api.cloudflareclient.com/v0a${rand}/reg/${id}/account" \
        --silent \
        --location \
        --header 'User-Agent: okhttp/3.12.1' \
        --header "CF-Client-Version: a-6.33-${rand}" \
        --header 'Content-Type: application/json' \
        --header "Authorization: Bearer ${token}" \
        --data '{"active": true}' | jq . >/dev/null 2>&1)

    if [ "$(echo "$patch_two_response" | jq '.result')" != "null" ]; then
        license=$(jq -r '.account.license' <warp-config.json)
        echo -e "${green}$license ${reset}| ${cyan}$quota${reset}"
        echo -e "${purple}-------------------------------------${reset}"
        echo "$license | $quota" >>output.txt
    fi

    response=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE "https://api.cloudflareclient.com/v0a${rand}/reg/${id}" \
        --header "Authorization: Bearer ${token}" \
        --header "Accept: application/json" \
        --header "Accept-Encoding: gzip" \
        --header "Cf-Client-Version: a-6.3-${rand}" \
        --header "User-Agent: okhttp/3.12.1")

    if [ "$response" -ne 204 ]; then
        echo "Error: HTTP status code $response"
    fi
    rm warp-config.json >/dev/null 2>&1
    echo -e "${green}Warp License Cloning completed!${reset}"
}

main_menu() {
    while true; do
        clear
        if command -v figlet &>/dev/null; then
            figlet -f slant "KOLAND"
        fi
        echo -e "${cyan}*****************************************${reset}"
        echo -e "${cyan}*${reset} ${red}Y${green}O${yellow}U${purple}T${cyan}U${green}B${white}E${reset} : ${purple}KOLANDONE${reset}         ${cyan}"
        echo -e "${cyan}*${reset} ${red}T${green}E${yellow}L${purple}E${cyan}G${green}R${white}A${red}M${reset} : ${purple}KOLANDJS${reset}         ${cyan}"
        echo -e "${cyan}*${reset} ${red}G${green}I${yellow}T${purple}H${cyan}U${green}B${reset} : ${purple}https://github.com/Kolandone${reset} ${cyan}"
        echo -e "${cyan}*****************************************${reset}"
        echo -e "${cyan}* ${green}Date:${reset} $(date '+%Y-%m-%d %H:%M:%S') ${cyan}*${reset}"
        echo ""

        echo -e "${cyan}+----+---------------------------------------------+${reset}"
        echo -e "${green}| No | Option                                      |${reset}"
        echo -e "${cyan}+----+---------------------------------------------+${reset}"
        printf "${cyan}| ${yellow}%-2s ${cyan}| ${yellow}%-43s ${cyan}|\n" "1" "IPv4 scan"
        printf "${cyan}| ${yellow}%-2s ${cyan}| ${yellow}%-43s ${cyan}|\n" "2" "IPv6 scan"
        printf "${cyan}| ${yellow}%-2s ${cyan}| ${yellow}%-43s ${cyan}|\n" "3" "V2ray and MahsaNG wireguard config"
        printf "${cyan}| ${yellow}%-2s ${cyan}| ${yellow}%-43s ${cyan}|\n" "4" "Hiddify config for 1.4.0 - 1.9.0 versions"
        printf "${cyan}| ${yellow}%-2s ${cyan}| ${yellow}%-43s ${cyan}|\n" "5" "Warp License Cloner"
        printf "${cyan}| ${yellow}%-2s ${cyan}| ${yellow}%-43s ${cyan}|\n" "6" "Hiddify config for 2.0 version or higher"
        printf "${cyan}| ${yellow}%-2s ${cyan}| ${yellow}%-43s ${cyan}|\n" "7" "Install Worker Creator"
        printf "${cyan}| ${yellow}%-2s ${cyan}| ${yellow}%-43s ${cyan}|\n" "8" "Run Worker Creator (install it first)"
        printf "${cyan}| ${yellow}%-2s ${cyan}| ${yellow}%-43s ${cyan}|\n" "9" "Free subscription link (Soroush Mirzaei)"
        printf "${cyan}| ${yellow}%-2s ${cyan}| ${yellow}%-43s ${cyan}|\n" "10" "Wireguard config for Hiddify and v2ray"
        printf "${cyan}| ${yellow}%-2s ${cyan}| ${yellow}%-43s ${cyan}|\n" "11" "CLEAN IP scanner"
        printf "${cyan}| ${yellow}%-2s ${cyan}| ${yellow}%-43s ${cyan}|\n" "12" "Fastly CLEAN IP scanner"
        printf "${cyan}| ${yellow}%-2s ${cyan}| ${yellow}%-43s ${cyan}|\n" "13" "Gcore CLEAN IP scanner"
        printf "${cyan}| ${yellow}%-2s ${cyan}| ${yellow}%-43s ${cyan}|\n" "14" "Telegram Proxy"
        printf "${cyan}| ${yellow}%-2s ${cyan}| ${yellow}%-43s ${cyan}|\n" "15" "SingBox installer (only for serv00)"
        printf "${cyan}| ${yellow}%-2s ${cyan}| ${yellow}%-43s ${cyan}|\n" "16" "Check Dependencies"
        printf "${cyan}| ${yellow}%-2s ${cyan}| ${yellow}%-43s ${cyan}|\n" "17" "About"
        printf "${cyan}| ${yellow}%-2s ${cyan}| ${yellow}%-43s ${cyan}|\n" "18" "Exit"
        printf "${cyan}| ${yellow}%-2s ${cyan}| ${yellow}%-43s ${cyan}|\n" "99" "Install Selector"
        echo -e "${cyan}+----+---------------------------------------------+${reset}"
        echo -en "${green}Enter your choice: ${reset}"
        read -r user_input

        case $user_input in
            1)
                echo "Fetching IPv4 addresses from install.sh..."
                loading_animation
                ip_list=$(echo "1" | bash <(curl -fsSL https://raw.githubusercontent.com/Ptechgithub/warp/main/endip/install.sh) 2>/dev/null | grep -oP '(\d{1,3}\.){3}\d{1,3}:\d+')
                if [ -z "$ip_list" ]; then
                    echo -e "${red}Failed to fetch IPv4 addresses. Check your internet connection.${reset}"
                else
                    clear
                    echo "Top 10 IPv4 addresses with their latencies:"
                    display_table_ipv4 "$ip_list"
                    save_results "$ip_list" "ipv4_scan_$(date '+%Y%m%d_%H%M%S').txt"
                    echo -e "${green}IPv4 scan completed successfully!${reset}"
                fi
                echo -e "\n${yellow}Press Enter to return to the menu...${reset}"
                read
                ;;
            2)
                echo "Fetching IPv6 addresses from install.sh..."
                loading_animation
                ip_list=$(echo "2" | bash <(curl -fsSL https://raw.githubusercontent.com/Ptechgithub/warp/main/endip/install.sh) 2>/dev/null | grep -oP '(\[?[a-fA-F\d:]+\]?\:\d+)')
                if [ -z "$ip_list" ]; then
                    echo -e "${red}Failed to fetch IPv6 addresses. Check your internet connection.${reset}"
                else
                    clear
                    echo "Top 10 IPv6 addresses with their latencies:"
                    display_table_ipv6 "$ip_list"
                    save_results "$ip_list" "ipv6_scan_$(date '+%Y%m%d_%H%M%S').txt"
                    echo -e "${green}IPv6 scan completed successfully!${reset}"
                fi
                echo -e "\n${yellow}Press Enter to return to the menu...${reset}"
                read
                ;;
            3)
                bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/V2/main/koland.sh)
                echo -e "${green}V2ray and MahsaNG wireguard config completed!${reset}"
                echo -e "\n${yellow}Press Enter to return to the menu...${reset}"
                read
                ;;
            4)
                bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/Hidify/main/install.sh)
                echo -e "${green}Hiddify config for 1.4.0 - 1.9.0 versions completed!${reset}"
                echo -e "\n${yellow}Press Enter to return to the menu...${reset}"
                read
                ;;
            5)
                cloner
                echo -e "\n${yellow}Press Enter to return to the menu...${reset}"
                read
                ;;
            6)
                bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/Hidify/main/inst.sh)
                echo -e "${green}Hiddify config for 2.0 version or higher completed!${reset}"
                echo -e "\n${yellow}Press Enter to return to the menu...${reset}"
                read
                ;;
            7)
                bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/workercreator/main/install.sh)
                echo -e "${green}Worker Creator installed successfully!${reset}"
                echo -e "\n${yellow}Press Enter to return to the menu...${reset}"
                read
                ;;
            8)
                bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/workercreator/main/run.sh)
                echo -e "${green}Worker Creator run successfully!${reset}"
                echo -e "\n${yellow}Press Enter to return to the menu...${reset}"
                read
                ;;
            9)
                bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/quick-sub/main/run.sh)
                echo -e "${green}Free subscription link retrieved successfully!${reset}"
                echo -e "\n${yellow}Press Enter to return to the menu...${reset}"
                read
                ;;
            10)
                bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/wireguard-v2hiddify/main/install.sh)
                echo -e "${green}Wireguard config for Hiddify and v2ray completed!${reset}"
                echo -e "\n${yellow}Press Enter to return to the menu...${reset}"
                read
                ;;
            11)
                bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/cfipscanner/main/ipscan.sh)
                echo -e "${green}CLEAN IP scanner completed!${reset}"
                echo -e "\n${yellow}Press Enter to return to the menu...${reset}"
                read
                ;;
            12)
                bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/fastlyipscan/refs/heads/main/ipscan.sh)
                echo -e "${green}Fastly CLEAN IP scanner completed!${reset}"
                echo -e "\n${yellow}Press Enter to return to the menu...${reset}"
                read
                ;;
            13)
                bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/gcorescanner/refs/heads/main/gcore.sh)
                echo -e "${green}Gcore CLEAN IP scanner completed!${reset}"
                echo -e "\n${yellow}Press Enter to return to the menu...${reset}"
                read
                ;;
            14)
                bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/quick-sub/refs/heads/main/proxy.sh)
                echo -e "${green}Telegram Proxy setup completed!${reset}"
                echo -e "\n${yellow}Press Enter to return to the menu...${reset}"
                read
                ;;
            15)
                bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/serv00/main/koland-serv00.sh)
                echo -e "${green}SingBox installer for serv00 completed!${reset}"
                echo -e "\n${yellow}Press Enter to return to the menu...${reset}"
                read
                ;;
            16)
                clear
                check_dependencies
                echo -e "\n${yellow}Press Enter to return to the menu...${reset}"
                read
                ;;
            17)
                clear
                echo -e "${purple}=== About KOLAN Script ===${reset}"
                echo -e "${green}Version:${reset} 2.1.0"
                echo -e "${green}Author:${reset} Koland"
                echo -e "${green}Description:${reset} A powerful tool for scanning IPs, managing VPN configs, and more!"
                echo -e "${green}GitHub:${reset} https://github.com/Kolandone"
                echo -e "\n${yellow}Press Enter to return to the menu...${reset}"
                read
                ;;
            18)
                echo -e "${green}Goodbye! Thanks for using KOLAND script.${reset}"
                exit 0
                ;;
            99)
                bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/Selector/main/install.sh)
                echo -e "${green}After this, you can run the Selector with ${cyan}kl ${green}command${reset}"
                echo -e "\n${yellow}Press Enter to return to the menu...${reset}"
                read
                ;;
            *)
                echo -e "${red}Invalid input. Please enter a number between 1 and 18, or 99.${reset}"
                echo -e "\n${yellow}Press Enter to return to the menu...${reset}"
                read
                ;;
        esac
    done
}


main_menu

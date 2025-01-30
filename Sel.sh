#!/bin/bash
clear



echo -e "\e[1;35m*****************************************"
echo -e "\e[1;35m*\e[0m \e[1;31mY\e[1;32mO\e[1;33mU\e[1;34mT\e[1;35mU\e[1;36mB\e[1;37mE\e[0m : \e[4;34mKOLANDONE\e[0m         \e[1;35m"
echo -e "\e[1;35m*\e[0m \e[1;31mT\e[1;32mE\e[1;33mL\e[1;34mE\e[1;35mG\e[1;36mR\e[1;37mA\e[1;31mM\e[0m : \e[4;34mKOLANDJS\e[0m         \e[1;35m"
echo -e "\e[1;35m*\e[0m \e[1;31mG\e[1;32mI\e[1;33mT\e[1;34mH\e[1;35mU\e[1;36mB\e[0m : \e[4;34mhttps://github.com/Kolandone\e[0m \e[1;35m"
echo -e "\e[1;35m*****************************************"
echo ""

echo -e "\e[1;36m*****************************************"
echo -e "\e[1;32mPlease choose an option:(Type 99 to install selector)\e[0m"
echo -e "\e[1;36m1. \e[1;33mIPv4 scan\e[0m"
echo -e "\e[1;36m2. \e[1;33mIPv6 scan\e[0m"
echo -e "\e[1;36m3. \e[1;33mV2ray and MahsaNG wireguard config\e[0m"
echo -e "\e[1;36m4. \e[1;33mHiddify config for 1.4.0 - 1.9.0 versions\e[0m"
echo -e "\e[1;36m5. \e[1;33mWarp License Cloner\e[0m"
echo -e "\e[1;36m6. \e[1;33mHiddify config for 2.0 version or higher\e[0m"
echo -e "\e[1;36m7. \e[1;33mInstall Worker Creator\e[0m"
echo -e "\e[1;36m8. \e[1;33mRun Worker Creator (install it first)\e[0m"
echo -e "\e[1;36m9. \e[1;33m Free subscription link(Soroush Mirzaei)\e[0m"
echo -e "\e[1;36m10. \e[1;33mwireguard config for Hiddify and v2ray\e[0m"
echo -e "\e[1;36m11. \e[1;33mCLEAN IP scanner\e[0m"
echo -e "\e[1;36m12. \e[1;33mfastly CLEAN IP scanner\e[0m"
echo -e "\e[1;36m13. \e[1;33mgcore CLEAN IP scanner\e[0m"
echo -e "\e[1;36m14. \e[1;33mTelegram Proxy\e[0m"
echo -e "\e[1;36m15. \e[1;33mSingBox installer(only for serv00)\e[0m"
echo -e "\e[1;36m*****************************************"
echo -en "\e[1;32mEnter your choice:\e[0m"
read -r user_input


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

    echo -e "${cyan}######################${rest}"
    echo -en "${green}Enter a license (${yellow}Press Enter to use a random license, may not work${green}): ${rest}"
    read -r input_license

    if [ -z "$input_license" ]; then
        # Choose a random license from the list
        license=$(shuf -n 1 -e "${licenses[@]}")
    else
        license="$input_license"
    fi
    echo -e "${cyan}######################${rest}"
    echo -e "${purple} Warp License cloner ${rest}"
    echo -e "${green}Starting...${rest}"
    echo -e "${purple}-------------------------------------${rest}"
    while true; do
        # Requirements
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

        # Register
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
        # ___________________________________________
        # Change License
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

        # ___________________________________________
        # Patch Account
        patch_one_response=$(curl -X PATCH "https://api.cloudflareclient.com/v0a${rand}/reg/${id}/account" \
            --silent \
            --location \
            --header 'User-Agent: okhttp/3.12.1' \
            --header "CF-Client-Version: a-6.33-${rand}" \
            --header 'Content-Type: application/json' \
            --header "Authorization: Bearer ${token}" \
            --data '{"active": true}')

        # ___________________________________________
        # Get Data
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

        # ___________________________________________
        # Change License Again
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

        # ___________________________________________
        # Patch Account Again
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
            echo -e "${green}$license ${rest}| ${cyan}$quota${rest}"
            echo -e "${purple}-------------------------------------${rest}"
            echo "$license | $quota" >>output.txt
        fi

        # ___________________________________________
        # Delete Account
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
        sleep 2
    done
}


# Execute the chosen option
if [ "$user_input" -eq 1 ]; then
    echo "Fetching IPv4 addresses from install.sh..."
    ip_list=$(echo "1" | bash <(curl -fsSL https://raw.githubusercontent.com/Ptechgithub/warp/main/endip/install.sh) | grep -oP '(\d{1,3}\.){3}\d{1,3}:\d+')
    clear
    echo "Top 10 IPv4 addresses with their latencies:"
    display_table_ipv4 "$ip_list"
elif [ "$user_input" -eq 2 ]; then
    echo "Fetching IPv6 addresses from install.sh..."
    ip_list=$(echo "2" | bash <(curl -fsSL https://raw.githubusercontent.com/Ptechgithub/warp/main/endip/install.sh) | grep -oP '(\[?[a-fA-F\d:]+\]?\:\d+)')
    clear
    echo "Top 10 IPv6 addresses with their latencies:"
    display_table_ipv6 "$ip_list"
elif [ "$user_input" -eq 3 ]; then
    bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/V2/main/koland.sh)
elif [ "$user_input" -eq 4 ]; then
    bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/Hidify/main/install.sh)
    KOLAND
elif [ "$user_input" -eq 5 ]; then
    cloner
elif [ "$user_input" -eq 6 ]; then
    bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/Hidify/main/inst.sh)
    KOL
elif [ "$user_input" -eq 7 ]; then
    bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/workercreator/main/install.sh)
elif [ "$user_input" -eq 8 ]; then
    bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/workercreator/main/run.sh)
elif [ "$user_input" -eq 9 ]; then
    bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/quick-sub/main/run.sh)
elif [ "$user_input" -eq 10 ]; then
    bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/wireguard-v2hiddify/main/install.sh)
elif [ "$user_input" -eq 11 ]; then
    bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/cfipscanner/main/ipscan.sh)
elif [ "$user_input" -eq 12 ]; then
    bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/fastlyipscan/refs/heads/main/ipscan.sh)
elif [ "$user_input" -eq 13 ]; then
    bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/gcorescanner/refs/heads/main/gcore.sh)
elif [ "$user_input" -eq 14 ]; then
    bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/quick-sub/refs/heads/main/proxy.sh)
elif [ "$user_input" -eq 15 ]; then
    bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/serv00/main/koland-serv00.sh)
elif [ "$user_input" -eq 99 ]; then
    bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/Selector/main/install.sh)
    echo -e "\e[1;32mAfter this, you can run the Selector with \e[1;36mkl \e[1;32mcommand\e[0m"
    else 
    echo "Invalid input. Please enter between 1 and 15"
fi

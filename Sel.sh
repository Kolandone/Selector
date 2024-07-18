#!/bin/bash
clear

# Display the title in multiple colors and big size
echo -e "\e[1;31mY\e[1;32mO\e[1;33mU\e[1;34mT\e[1;35mU\e[1;36mB\e[1;37mE\e[0m : \e[1;31mK\e[1;32mO\e[1;33mL\e[1;34mA\e[1;35mN\e[1;36mD\e[1;37mO\e[1;31mN\e[1;32mE\e[0m"

echo "Please choose an option:"
echo "1. V2ray and MahsaNG wireguard config"
echo -e "2. Hiddify config, After the first use, you can enter the \e[1;32mKOLAND\e[0m command"
echo "3. Generate 10 IP addresses with low latency"
echo "Enter your choice:" 
read -r user_input

# Function to generate 10 IP addresses with low latency
endipv4() {
    n=0
    iplist=10
    while true; do
        temp[$n]=$(echo 162.159.192.$(($RANDOM % 256)))
        n=$(($n + 1))
        if [ $n -ge $iplist ]; then
            break
        fi
        temp[$n]=$(echo 162.159.193.$(($RANDOM % 256)))
        n=$(($n + 1))
        if [ $n -ge $iplist ]; then
            break
        fi
        temp[$n]=$(echo 162.159.195.$(($RANDOM % 256)))
        n=$(($n + 1))
        if [ $n -ge $iplist ]; then
            break
        fi
        temp[$n]=$(echo 188.114.96.$(($RANDOM % 256)))
        n=$(($n + 1))
        if [ $n -ge $iplist ]; then
            break
        fi
        temp[$n]=$(echo 188.114.97.$(($RANDOM % 256)))
        n=$(($n + 1))
        if [ $n -ge $iplist ]; then
            break
        fi
        temp[$n]=$(echo 188.114.98.$(($RANDOM % 256)))
        n=$(($n + 1))
        if [ $n -ge $iplist ]; then
            break
        fi
        temp[$n]=$(echo 188.114.99.$(($RANDOM % 256)))
        n=$(($n + 1))
        if [ $n -ge $iplist ]; then
            break
        fi
    done
    while true; do
        if [ $(echo "${temp[@]}" | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
            break
        else
            temp[$n]=$(echo 162.159.192.$(($RANDOM % 256)))
            n=$(($n + 1))
        fi
        if [ $(echo "${temp[@]}" | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
            break
        else
            temp[$n]=$(echo 162.159.193.$(($RANDOM % 256)))
            n=$(($n + 1))
        fi
        if [ $(echo "${temp[@]}" | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
            break
        else
            temp[$n]=$(echo 162.159.195.$(($RANDOM % 256)))
            n=$(($n + 1))
        fi
        if [ $(echo "${temp[@]}" | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
            break
        else
            temp[$n]=$(echo 188.114.96.$(($RANDOM % 256)))
            n=$(($n + 1))
        fi
        if [ $(echo "${temp[@]}" | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
            break
        else
            temp[$n]=$(echo 188.114.97.$(($RANDOM % 256)))
            n=$(($n + 1))
        fi
        if [ $(echo "${temp[@]}" | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
            break
        else
            temp[$n]=$(echo 188.114.98.$(($RANDOM % 256)))
            n=$(($n + 1))
        fi
        if [ $(echo "${temp[@]}" | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
            break
        else
            temp[$n]=$(echo 188.114.99.$(($RANDOM % 256)))
            n=$(($n + 1))
        fi
    done
    echo "Generated IP addresses:"
    echo "${temp[@]}" | sed -e 's/ /\n/g' | sort -u | head -n 10
}

if [ "$user_input" -eq 1 ]; then
    bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/V2/main/koland.sh)
elif [ "$user_input" -eq 2 ]; then
    bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/Hidify/main/install.sh)
    KOLAND
elif [ "$user_input" -eq 3 ]; then
    endipv4
else
    echo "Invalid input. Please enter 1, 2, or 3."
fi

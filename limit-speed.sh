#!/bin/bash

# // Root Checking
if [ "${EUID}" -ne 0 ]; then
		echo -e "${EROR} Please Run This Script As Root User !"
		exit 1
fi

# // Export Color & Information
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export LIGHT='\033[0;37m'
export NC='\033[0m'

# // Export Banner Status Information
export EROR="[${RED} ERROR ${NC}]"
export INFO="[${YELLOW} INFO ${NC}]"
export OKEY="[${GREEN} OKEY ${NC}]"





# // Exporting IP Address
export IP=$( curl -s https://ipinfo.io/ip/ )

# // Validate Result ( 1 )
touch
clear
StatInfo="${GREEN}[ON]${NC}"
StatError="${RED}[OFF]${NC}"
cek=$(cat /home/limit)
NIC=$(ip -o $ANU -4 route show to default | awk '{print $5}');
function start () {
echo -e " Limit Speed All Service"
read -p " Set maximum download rate (in Kbps): " down
read -p " Set maximum upload rate (in Kbps): " up
if [[ -z "$down" ]] && [[ -z "$up" ]]; then
echo > /dev/null 2>&1
else
echo "Start Configuration"
sleep 0.5
wondershaper -a $NIC -d $down -u $up > /dev/null 2>&1
systemctl enable --now wondershaper.service
echo "start" > /home/limit
echo "Done"
fi
}
function stop () {
wondershaper -ca $NIC
systemctl stop wondershaper.service
echo "Stop Configuration"
sleep 0.5
echo > /home/limit
echo "Done"
}
if [[ "$cek" = "start" ]]; then
sts="${StatInfo}"
else
sts="${StatError}"
fi
clear
echo -e "${GREEN}┌─────────────────────────────────────────┐${NC}"
echo -e "${YELLOW}              ⇱ Limit Speed ⇲             ${NC}"
echo -e "${GREEN}└─────────────────────────────────────────┘${NC}"

echo -e "  Status $sts"
echo -e "  1. Start Limit"
echo -e "  2. Stop Limit"
echo -e "  Press CTRL+C to return"
read -rp " Please Enter The Correct Number : " -e num
if [[ "$num" = "1" ]]; then
start
elif [[ "$num" = "2" ]]; then
stop
else
clear
echo " You Entered The Wrong Number"
menu
fi

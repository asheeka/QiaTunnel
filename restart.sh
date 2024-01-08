# // Root Checking
if [ "${EUID}" -ne 0 ]; then
		echo -e "${HERROR} Please Run This Script As Root User !"
		exit 1
fi

# // Color DEFINITION
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export LIGHT='\033[0;37m'
export NC='\033[0m'

# // Header Color DEFINITON
export HERROR="[${RED} ERROR ${NC}]"
export HINFO="[${YELLOW} INFO ${NC}]"
export HOK="[${GREEN} OK ${NC}]"

# // Exporting IP Address
export IP=$( curl -s https://ipinfo.io/ip/ )

clear
echo -e ""
echo -e "┌──────────────────────────────────────┐" | lolcat
echo -e "|            RESTART SERVICE           |"
echo -e "└──────────────────────────────────────┘" | lolcat
echo -e ""
echo -e "    [${CYAN}1${NC}] Restart All Services"
echo -e "    [${CYAN}2${NC}] Restart OpenSSH"
echo -e "    [${CYAN}3${NC}] Restart Dropbear"
echo -e "    [${CYAN}4${NC}] Restart Stunnel5"
echo -e "    [${CYAN}5${NC}] Restart Nginx"
echo -e "    [${CYAN}6${NC}] Restart Badvpn"
echo -e "    [${CYAN}x${NC}] Menu"
echo -e ""
read -p "    Select From Options [1-6 or x] :  " Restart
echo -e ""
echo -e "└──────────────────────────────────────┘" | lolcat
sleep 1
clear
case $Restart in
                1)
                clear
                #systemctl restart ws-dropbear.service >/dev/null 2>&1
                systemctl restart ws-stunnel.service >/dev/null 2>&1
                #systemctl restart xray.service >/dev/null 2>&1
                /etc/init.d/ssh restart
                /etc/init.d/dropbear restart
                /etc/init.d/stunnel5 restart
                /etc/init.d/fail2ban restart
                /etc/init.d/cron restart
                /etc/init.d/nginx restart
                screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 1000
                screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 1000
                screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 1000
                systemctl restart rc-local.service
                echo -e ""
                echo -e "======================================"
                echo -e ""
                echo -e "          ${GREEN}Service/s Restarted         ${NC}"
                echo -e ""
                echo -e "======================================"
                ;;
                2)
                clear
                /etc/init.d/ssh restart
                echo -e ""
                echo -e "======================================"
                echo -e ""
                echo -e "         ${GREEN}SSH Service Restarted        ${NC}"
                echo -e ""
                echo -e "======================================"
                ;;
                3)
                clear
                /etc/init.d/dropbear restart
                echo -e ""
                echo -e "======================================"
                echo -e ""
                echo -e "       ${GREEN}Dropbear Service Restarted     ${NC}"
                echo -e ""
                echo -e "======================================"
                ;;
                4)
                clear
                /etc/init.d/stunnel5 restart
                echo -e ""
                echo -e "======================================"
                echo -e ""
                echo -e "        ${GREEN}Stunnel5 Service Restarted    ${NC}"
                echo -e ""
                echo -e "======================================"
                ;;
                5)
                clear
                /etc/init.d/nginx restart
                echo -e ""
                echo -e "======================================"
                echo -e ""
                echo -e "         ${GREEN}Nginx Service Restarted      ${NC}"
                echo -e ""
                echo -e "======================================"
                ;;
                6)
                clear
                screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
                screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
                screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500
                systemctl restart rc-local.service >/dev/null 2>&1
                echo -e ""
                echo -e "======================================"
                echo -e ""
                echo -e "    ${GREEN}Badvpn  Badvpn Service Restarted  ${NC}"
                echo -e ""
                echo -e "======================================"
                ;;
                x)
                clear
                menu
                ;;
        esac
read -n 1 -s -r -p " Press any key to back on menu"

menu

# // Root Checking
if [ "${EUID}" -ne 0 ]; then
		echo -e "${EROR} Please Run This Script As Root User !"
		exit 1
fi

# // Color DEFINITION
RED = "\e[31m"
export GREEN = "\e[32m"
export YELLOW = "\e[33m"
BLUE = "\e[34m"
PURPLE = "\e[35m"
export CYAN = "\e[36m"
LIGRAY = "\e[37m"
export NC = "\e[0m"

# // Header Color DEFINITON
HERROR="[${RED} ERROR ${NC}]"
export HINFO="[${YELLOW} INFO ${NC}]"
HOK="[${GREEN} OK ${NC}]"

# // Get IP Address
IP=$( curl -s https://ipinfo.io/ip/ )

# // Get Network Interface
NETWORK_IFACE="$(ip route show to default | awk '{print $5}')"

echo "Checking VPS"
clear
if [ ! -e /usr/bin/reboot ]; then
	echo '#!/bin/bash' > /usr/bin/reboot
	echo 'tanggal=$(date +"%m-%d-%Y")' >> /usr/bin/reboot
	echo 'waktu=$(date +"%T")' >> /usr/bin/reboot
	echo 'echo "Server successfully rebooted on the date of $tanggal hit $waktu." >> /root/log-reboot.txt' >> /usr/bin/reboot
	echo '/sbin/shutdown -r now' >> /usr/bin/reboot
	chmod +x /usr/bin/reboot
fi

echo -e ""
echo -e "┌──────────────────────────────────────┐" | lolcat
echo -e "|             AUTO REBOOT              |"| lolcat
echo -e "└──────────────────────────────────────┘" | lolcat
echo -e ""
echo -e "    [ ${CYAN}1${NC} ]  Auto Reboot 30 Minutes"
echo -e "    [ ${CYAN}2${NC} ]  Auto Reboot 1 Hours"
echo -e "    [ ${CYAN}3${NC} ]  Auto Reboot 12 Hours"
echo -e "    [ ${CYAN}4${NC} ]  Auto Reboot 24 Hours"
echo -e "    [ ${CYAN}5${NC} ]  Auto Reboot 1 Weeks"
echo -e "    [ ${CYAN}6${NC} ]  Auto Reboot 1 Month"
echo -e "    [ ${CYAN}7${NC} ]  Turn Off Auto Reboot"
echo -e "    [ ${CYAN}X${NC} ]  Back to Menu"
echo -e "───────────────────────────────────────" | lolcat
echo -e ""
read -p "    Please Input Number  [1-7 or X] :  "  autoreboot
echo -e ""
case $autoreboot in
1)
echo "*/30 * * * * root /usr/bin/reboot" > /etc/cron.d/auto_reboot && chmod +x /etc/cron.d/auto_reboot
echo "" > /root/log-reboot.txt
echo -e ""
echo -e "───────────────────────────────────────" | lolcat
echo -e "${HINFO}      AutoReboot : On ${NC}"
echo -e "${HINFO}      AutoReboot Every : 30 Minutes ${NC}"
echo -e "───────────────────────────────────────" | lolcat
service cron reload >/dev/null 2>&1
service cron restart >/dev/null 2>&1
echo ""
read -n 1 -s -r -p "Press any key to back on menu reboot"
autoreboot
;;
2)
echo "0 * * * * root /usr/bin/reboot" > /etc/cron.d/auto_reboot && chmod +x /etc/cron.d/auto_reboot
echo "" > /root/log-reboot.txt
echo -e ""
echo -e "───────────────────────────────────────" | lolcat
echo -e "${HINFO}      AutoReboot : On ${NC}"
echo -e "${HINFO}      AutoReboot Every : 1 Hour ${NC}"
echo -e "───────────────────────────────────────" | lolcat
service cron reload >/dev/null 2>&1
service cron restart >/dev/null 2>&1
echo ""
read -n 1 -s -r -p "Press any key to back on menu reboot"
autoreboot
;;
3)
echo "0 */12 * * * root /usr/bin/reboot" > /etc/cron.d/auto_reboot && chmod +x /etc/cron.d/auto_reboot
echo "" > /root/log-reboot.txt
echo -e ""
echo -e "───────────────────────────────────────" | lolcat
echo -e "${HINFO}      AutoReboot : On ${NC}"
echo -e "${HINFO}      AutoReboot Every : 12 Hours ${NC}"
echo -e "───────────────────────────────────────" | lolcat
service cron reload >/dev/null 2>&1
service cron restart >/dev/null 2>&1
echo ""
read -n 1 -s -r -p "Press any key to back on menu reboot"
autoreboot
;;
4)
echo "0 0 * * * root /usr/bin/reboot" > /etc/cron.d/auto_reboot && chmod +x /etc/cron.d/auto_reboot
echo "" > /root/log-reboot.txt
echo -e ""
echo -e "───────────────────────────────────────" | lolcat
echo -e "${HINFO}      AutoReboot : On ${NC}"
echo -e "${HINFO}      AutoReboot Every : 24 Hours ${NC}"
echo -e "───────────────────────────────────────" | lolcat
service cron reload >/dev/null 2>&1
service cron restart >/dev/null 2>&1
echo ""
read -n 1 -s -r -p "Press any key to back on menu reboot"
autoreboot
;;
5)
echo "0 0 */7 * * root /usr/bin/reboot" > /etc/cron.d/auto_reboot && chmod +x /etc/cron.d/auto_reboot
echo "" > /root/log-reboot.txt
echo -e ""
echo -e "───────────────────────────────────────" | lolcat
echo -e "${HINFO}      AutoReboot : On ${NC}"
echo -e "${HINFO}      AutoReboot Every : 1 Week ${NC}"
echo -e "───────────────────────────────────────" | lolcat
service cron reload >/dev/null 2>&1
service cron restart >/dev/null 2>&1
echo ""
read -n 1 -s -r -p "Press any key to back on menu reboot"
autoreboot
;;
6)
echo "0 0 1 * * root /usr/bin/reboot" > /etc/cron.d/auto_reboot && chmod +x /etc/cron.d/auto_reboot
echo "" > /root/log-reboot.txt
echo -e ""
echo -e "───────────────────────────────────────" | lolcat
echo -e "${HINFO}      AutoReboot : On ${NC}"
echo -e "${HINFO}      AutoReboot Every : 1 Month ${NC}"
echo -e "───────────────────────────────────────" | lolcat
service cron reload >/dev/null 2>&1
service cron restart >/dev/null 2>&1
echo ""
read -n 1 -s -r -p "Press any key to back on menu reboot"
autoreboot
;;
7)
rm -fr /etc/cron.d/auto_reboot
echo "" > /root/log-reboot.txt
echo -e ""
echo -e "───────────────────────────────────────" | lolcat
echo -e "${HINFO}      AutoReboot : Off ${NC}"
echo -e "───────────────────────────────────────" | lolcat
service cron reload >/dev/null 2>&1
service cron restart >/dev/null 2>&1
echo ""
read -n 1 -s -r -p "Press any key to back on menu reboot"
autoreboot
;;
x)
menu
;;
*)
echo "Please enter an correct number"
;;
esac
read -n 1 -s -r -p "Press any key to back on menu"
menu

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
echo -e "|             AUTO REBOOT              |"
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
X)
menu
;;
*)
echo "Please enter an correct number"
;;
esac
read -n 1 -s -r -p "Press any key to back on menu reboot"
autoreboot

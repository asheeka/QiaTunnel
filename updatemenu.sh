dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
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

echo -e "${GREEN}Deleting Old Menu ${NC}"
rm -fr /usr/bin/autoreboot
echo -e "${HOK} Delete Auto Reboot"
rm -fr /usr/bin/clearlog
echo -e "${HOK} Delete Clear Log"
rm -fr /usr/bin/dns
echo -e "${HOK} Delete DNS"
rm -fr /usr/bin/limit-speed
echo -e "${HOK} Delete Limit Speed"
rm -fr /usr/bin/menu
echo -e "${HOK} Delete Main Menu"
rm -fr /usr/bin/menu-ssh
echo -e "${HOK} Delete SSH"
rm -fr /usr/bin/netf
echo -e "${HOK} Delete NetFlix Check"
rm -fr /usr/bin/cek-ram
rm -fr /usr/bin/restart
echo -e "${HOK} Delete Restart"
rm -fr /usr/bin/running
echo -e "${HOK} Delete Running"
rm -fr /usr/bin/cek-speed
echo -e "${HOK} Delete Speedtest"
rm -fr /usr/bin/tendang
echo -e "${HOK} Delete AutoKill"
rm -fr /usr/bin/usernew
echo -e "${HOK} Delete UserNew"
rm -fr /usr/bin/wbm
echo -e "${HOK} Delete Webmin"
sleep 2

# // Download Data
echo -e "${GREEN}Download Data${NC}"
wget -q -O /usr/bin/autoreboot "https://raw.githubusercontent.com/asheeka/QiaTunnel/main/autoreboot.sh"
wget -q -O /usr/bin/clearlog "https://raw.githubusercontent.com/asheeka/QiaTunnel/main/clearlog.sh"
wget -q -O /usr/bin/dns "https://raw.githubusercontent.com/asheeka/QiaTunnel/main/dns.sh"
wget -q -O /usr/bin/limit-speed "https://raw.githubusercontent.com/asheeka/QiaTunnel/main/limit-speed.sh"
wget -q -O /usr/bin/menu "https://raw.githubusercontent.com/asheeka/QiaTunnel/main/menu4.sh"
wget -q -O /usr/bin/menu-ssh "https://raw.githubusercontent.com/asheeka/QiaTunnel/main/menu-ssh.sh"
wget -q -O /usr/bin/netf "https://raw.githubusercontent.com/asheeka/QiaTunnel/main/netf.sh"
wget -q -O /usr/bin/cek-ram "https://raw.githubusercontent.com/asheeka/QiaTunnel/main/ram.sh"
wget -q -O /usr/bin/restart "https://raw.githubusercontent.com/asheeka/QiaTunnel/main/restart.sh"
wget -q -O /usr/bin/running "https://raw.githubusercontent.com/asheeka/QiaTunnel/main/running.sh"
wget -q -O /usr/bin/cek-speed "https://raw.githubusercontent.com/asheeka/QiaTunnel/main/speedtest_cli.py"
wget -q -O /usr/bin/tendang "https://raw.githubusercontent.com/asheeka/QiaTunnel/main/tendang.sh"
wget -q -O /usr/bin/usernew "https://raw.githubusercontent.com/asheeka/QiaTunnel/main/usernew.sh"
wget -q -O /usr/bin/wbm "https://raw.githubusercontent.com/asheeka/QiaTunnel/main/webmin.sh"
echo -e "${HOK} Download data finished"
sleep 2

chmod +x /usr/bin/autoreboot
chmod +x /usr/bin/clearlog
chmod +x /usr/bin/dns
chmod +x /usr/bin/limit-speed
chmod +x /usr/bin/menu
chmod +x /usr/bin/menu-ssh
chmod +x /usr/bin/netf
chmod +x /usr/bin/cek-ram
chmod +x /usr/bin/restart
chmod +x /usr/bin/running
chmod +x /usr/bin/cek-speed
chmod +x /usr/bin/tendang
chmod +x /usr/bin/usernew
chmod +x /usr/bin/wbm
echo -e "${HINFO}Update Finish..${NC}"
sleep 2
read -p "$( echo -e "Press ${YELLOW}[ ${NC}${GREEN}Enter${NC} ${CYAN}]${NC} For Reboot") "
reboot
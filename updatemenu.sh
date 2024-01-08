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

rm -fr /usr/bin/autoreboot
rm -fr /usr/bin/clearlog
rm -fr /usr/bin/dns
rm -fr /usr/bin/limit-speed
rm -fr /usr/bin/menu
rm -fr /usr/bin/menu-ssh
rm -fr /usr/bin/netf
rm -fr /usr/bin/cek-ram
rm -fr /usr/bin/restart
rm -fr /usr/bin/running
rm -fr /usr/bin/cek-speed
rm -fr /usr/bin/tendang
rm -fr /usr/bin/usernew
rm -fr /usr/bin/wbm

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
echo -e "${GREEN}Update Finish..${NC}"
sleep 1
read -p "$( echo -e "Press ${orange}[ ${NC}${green}Enter${NC} ${CYAN}]${NC} For Reboot") "
reboot
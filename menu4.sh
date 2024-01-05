# // Root Checking
if [ "${EUID}" -ne 0 ]; then
		echo -e "${EROR} Please Run This Script As Root User !"
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

# // Clear
clear

cek=$(service ssh status | grep active | cut -d ' ' -f5)
if [ "$cek" = "active" ]; then
	stat=-f5
else
	stat=-f7
fi
ssh=$(service ssh status | grep active | cut -d ' ' $stat)
if [ "$ssh" = "active" ]; then
	ressh="${GREEN}ON${NC}"
else
	ressh="${RED}OFF${NC}"
fi
sshstunel=$(service stunnel5 status | grep active | cut -d ' ' $stat)
if [ "$sshstunel" = "active" ]; then
	resst="${GREEN}ON${NC}"
else
	resst="${RED}OFF${NC}"
fi
sshws=$(service ws-stunnel status | grep active | cut -d ' ' $stat)
if [ "$sshws" = "active" ]; then
	ressshws="${GREEN}ON${NC}"
else
	ressshws="${RED}OFF${NC}"
fi
ngx=$(service nginx status | grep active | cut -d ' ' $stat)
if [ "$ngx" = "active" ]; then
	resngx="${GREEN}ON${NC}"
else
	resngx="${RED}OFF${NC}"
fi
dbr=$(service dropbear status | grep active | cut -d ' ' $stat)
if [ "$dbr" = "active" ]; then
	resdbr="${GREEN}ON${NC}"
else
	resdbr="${RED}OFF${NC}"
fi

function addhost(){
	clear
	echo -e "${GREEN}┌─────────────────────────────────────────┐${NC}"
	read -rp "Domain/Host: " -e host
	echo ""
	if [ -z $host ]; then
		echo "????"
		echo -e "${GREEN}└─────────────────────────────────────────┘${NC}"
		read -n 1 -s -r -p "Press any key to back on menu"
		#setting-menu
		menu
	else
		rm -fr /root/domain
		echo "IP=$host" > /var/lib/scrz-prem/ipvps.conf
		echo $host > /root/domain
		echo -e "${GREEN}└─────────────────────────────────────────┘${NC}"
		echo "Dont forget to renew gen-ssl"
		echo ""
		read -n 1 -s -r -p "Press any key to back on menu"
		menu
	fi
}
function genssl(){
	clear
	systemctl stop nginx

	domain=$(cat /var/lib/scrz-prem/ipvps.conf | cut -d'=' -f2)
	Cek=$(lsof -i:80 | cut -d' ' -f1 | awk 'NR==2 {print $1}')
	if [[ ! -z "$Cek" ]]; then
		sleep 1
		echo -e "${HERROR} Detected port 80 used by $Cek " 
		systemctl stop $Cek
		sleep 2
		echo -e "${HINFO} Processing to stop $Cek " 
		sleep 1
	fi
	echo -e "${INFO} Starting renew gen-ssl... " 
	sleep 2
	/root/.acme.sh/acme.sh --upgrade
	/root/.acme.sh/acme.sh --upgrade --auto-upgrade
	/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
	/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
	~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc
	echo -e "${HINFO} Renew gen-ssl done... " 
	sleep 2
	echo -e "${HINFO} Starting service $Cek " 
	sleep 2
	echo $domain > /root/domain
	systemctl start nginx
	#systemctl start xray
	echo -e "${HINFO} All finished... " 
	sleep 0.5
	echo ""
	read -n 1 -s -r -p " Press any key to back on menu"
	menu
}
export sem=$( curl -s https://raw.githubusercontent.com/asheeka/QiaTunnel/main/test/versions)
export pak=$( cat /home/.ver)
IPVPS=$(curl -s ipinfo.io/ip )
ISPVPS=$( curl -s ipinfo.io/org | awk '{print $1 " " $2 " " $3}')
ram_used=$(free -m | grep Mem: | awk '{print $3}')
total_ram=$(free -m | grep Mem: | awk '{print $2}')
ram_usage=$(echo "scale=2; ($ram_used / $total_ram) * 100" | bc | cut -d. -f1)
# OS Uptime
#uptime="$(uptime -p | cut -d " " -f 2-10)"
# TOTAL ACC XRAYS WS & XTLS
ssh="$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)"
# Getting CPU Information
cpu_usage1="$(ps aux | awk 'BEGIN {sum=0} {sum+=$3}; END {print sum}')"
cpu_usage="$((${cpu_usage1/\.*/} / ${corediilik:-1}))"
cpu_usage+="%"
#cname=$(awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo)
cores=$(awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo)
freq=$(awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo)
clear
echo -e "${YELLOW} ┌──────────────────────────────────────────────┐${NC}"
echo -e "${YELLOW} │               ${NC}Server Information             ${YELLOW}│${NC}"
echo -e "${YELLOW} ├──────────────────────────────────────────────┤${NC}"
echo -e "${YELLOW} │  ${CYAN}OS Linux     :  ${NC}"$(hostnamectl | grep "Operating System" | cut -d ' ' -f5-)  
echo -e "${YELLOW} │  ${CYAN}CPU Info     :  ${NC}$cores Core @ $freq MHz (${cpu_usage})"
echo -e "${YELLOW} │  ${CYAN}Total RAM    :  ${NC}${ram_used}MB / ${total_ram}MB (${ram_usage}%)" 
echo -e "${YELLOW} │  ${CYAN}Domain       :  ${NC}$(cat /root/domain)" 
echo -e "${YELLOW} │  ${CYAN}IP           :  ${NC}$IPVPS"                  
echo -e "${YELLOW} │  ${CYAN}ISP          :  ${NC}$ISPVPS"  
echo -e "${YELLOW} └──────────────────────────────────────────────┘${NC}"
echo -e "${CYAN}  SSH ${NC}: $ressh"" ${CYAN} NGINX ${NC}: $resngx"" ${CYAN}  XRAY ${NC}: $resv2r"" ${CYAN} TROJAN ${NC}: $resv2r"
echo -e "${CYAN}  DROPBEAR ${NC}: $resdbr" "${CYAN} SSH-WS ${NC}: $ressshws" "${CYAN}Stunnel ${NC}: $sshstunel"
echo -e "${YELLOW} ┌──────────────────────────────────────────────┐${NC}"
echo -e "     ${CYAN}[${NC}01${CYAN}] ${NC}SSHWS       ${NC}[ ${YELLOW}${ssh}${CYAN} ] ${NC}" 
echo -e "" 
echo -e "     ${CYAN}[${NC}02${CYAN}] ${NC}AUTO REBOOT         ${CYAN}[${NC}10${CYAN}] ${NC}SPEED TEST "    
echo -e "     ${CYAN}[${NC}03${CYAN}] ${NC}REBOOT              ${CYAN}[${NC}11${CYAN}] ${NC}LIMIT SPEED "    
echo -e "     ${CYAN}[${NC}04${CYAN}] ${NC}RESTART             ${CYAN}[${NC}12${CYAN}] ${NC}WEBMIN "    
echo -e "     ${CYAN}[${NC}05${CYAN}] ${NC}UPDATE MENU         ${CYAN}[${NC}13${CYAN}] ${NC}INFO SCRIPT "    
echo -e "     ${CYAN}[${NC}06${CYAN}] ${NC}ADD HOST/DOMAIN     ${CYAN}[${NC}14${CYAN}] ${NC}CLEAR LOG "
echo -e "     ${CYAN}[${NC}07${CYAN}] ${NC}RENEW CERT          ${CYAN}[${NC}15${CYAN}] ${NC}UPDATE DNS " 
echo -e "     ${CYAN}[${NC}08${CYAN}] ${NC}EDIT BANNER         ${CYAN}[${NC}16${CYAN}] ${NC}NETFLIX CHECK "       
echo -e "     ${CYAN}[${NC}09${CYAN}] ${NC}RUNNING STATUS      ${CYAN}[${NC}17${CYAN}] ${NC}TENDANG " 
echo -e " ${YELLOW}┌──────────────────────────────────────────────┐${NC}"
echo -e " ${YELLOW}│   Version      ${NC} : $sem Last Update            ${YELLOW}│${NC}"
echo -e " ${YELLOW}└──────────────────────────────────────────────┘${NC}"
echo
read -p " Select menu : " opt
echo -e ""
case $opt in
1) clear ; menu-ssh ;;
2) clear ; autoreboot ;;
3) clear ; reboot ;;
4) clear ; restart ;;
5) clear ; updatemenu;;
6) clear ; addhost ;;
7) clear ; genssl ;;
8) clear ; nano /etc/issue.net ;;
9) clear ; running ;;
10) clear ; cek-speed ;;
11) clear ; limit-speed ;;
12) clear ; wbm ;;
13) clear ; cat /root/log-install.txt ;;
14) clear ; clearlog ;;
15) clear ; dns ;;
16) clear ; netf ;;
17) clear ; tendang ;;
0) clear ; menu ;;
x) exit ;;
*) echo -e "" ; echo "Press any key to back exit" ; sleep 1 ; exit ;;
esac

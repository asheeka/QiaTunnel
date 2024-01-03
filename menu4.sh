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
export PENDING="[${YELLOW} PENDING ${NC}]"
export SEND="[${YELLOW} SEND ${NC}]"
export RECEIVE="[${YELLOW} RECEIVE ${NC}]"

# // Export Align
export BOLD="\e[1m"
export WARNING="${RED}\e[5m"
export UNDERLINE="\e[4m"

# // Exporting URL Host
export Server_URL="raw.githubusercontent.com/asheeka/QiaTunnel/main/test"
export Server1_URL="raw.githubusercontent.com/asheeka/QiaTunnel/main/limit"
export Server_Port="443"
export Server_IP="underfined"
export Script_Mode="Stable"
export Auther=".geovpn"

# // Exporting IP Address
export IP=$( curl -s https://ipinfo.io/ip/ )

# // Exporting Network Interface
export NETWORK_IFACE="$(ip route show to default | awk '{print $5}')"

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
	echo -e "$[GREEN]┌─────────────────────────────────────────┐${NC}"
	read -rp "Domain/Host: " -e host
	echo ""
	if [ -z $host ]; then
		echo "????"
		echo -e "$[GREEN]└─────────────────────────────────────────┘${NC}"
		read -n 1 -s -r -p "Press any key to back on menu"
		#setting-menu
		menu
	else
		rm -fr /root/domain
		echo "IP=$host" > /var/lib/scrz-prem/ipvps.conf
		echo $host > /root/domain
		echo -e "$[GREEN]└─────────────────────────────────────────┘${NC}"
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
		echo -e "${EROR} Detected port 80 used by $Cek " 
		systemctl stop $Cek
		sleep 2
		echo -e "${INFO} Processing to stop $Cek " 
		sleep 1
	fi
	echo -e "${INFO} Starting renew gen-ssl... " 
	sleep 2
	/root/.acme.sh/acme.sh --upgrade
	/root/.acme.sh/acme.sh --upgrade --auto-upgrade
	/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
	/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-2048
	~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc
	echo -e "${INFO} Renew gen-ssl done... " 
	sleep 2
	echo -e "${INFO} Starting service $Cek " 
	sleep 2
	echo $domain > /root/domain
	systemctl start nginx
	#systemctl start xray
	echo -e "${INFO} All finished... " 
	sleep 0.5
	echo ""
	read -n 1 -s -r -p " Press any key to back on menu"
	menu
}
export sem=$( curl -s https://raw.githubusercontent.com/asheeka/QiaTunnel/main/test/versions)
export pak=$( cat /home/.ver)
IPVPS=$(curl -s ipinfo.io/ip )
IPVPS=$(curl -sS ipv4.icanhazip.com)
ISPVPS=$( curl -s ipinfo.io/org | awk '{print $1 " " $2 " " $3}')
#daily_usage=$(vnstat -d --oneline | awk -F\; '{print $6}' | sed 's/ //')
monthly_usage=$(vnstat -m --oneline | awk -F\; '{print $11}' | sed 's/ //')
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
echo -e "${Yellow} ┌──────────────────────────────────────────────┐${NC}"
echo -e "${Yellow} │               ${NC}Server Information             ${Yellow}│${NC}"
echo -e "${Yellow} ├──────────────────────────────────────────────┤${NC}"
echo -e "${Yellow} │  ${Cyan}OS Linux     :  ${NC}"$(hostnamectl | grep "Operating System" | cut -d ' ' -f5-)  
echo -e "${Yellow} │  ${Cyan}CPU Info     :  ${NC}$cores Core @ $freq MHz (${cpu_usage})"
echo -e "${Yellow} │  ${Cyan}Total RAM    :  ${NC}${ram_used}MB / ${total_ram}MB (${ram_usage}%)" 
echo -e "${Yellow} │  ${Cyan}Domain       :  ${NC}$(cat /root/domain)" 
echo -e "${Yellow} │  ${Cyan}IP-VPS       :  ${NC}$IPVPS"                  
echo -e "${Yellow} │  ${Cyan}ISP-VPS      :  ${NC}$ISPVPS"  
#echo -e "${BIYellow} │  ${BICyan}Daily Bandwidth :  ${BIWhite}$daily_usage ${NC}"
echo -e "${Yellow} │  ${Cyan}Bandwidth    :  ${NC}$monthly_usage"
echo -e "${Yellow} └──────────────────────────────────────────────┘${NC}"
echo -e "${Cyan}  SSH ${NC}: $ressh"" ${Cyan} NGINX ${NC}: $resngx"" ${Cyan}  XRAY ${NC}: $resv2r"" ${Cyan} TROJAN ${NC}: $resv2r"
echo -e "${Cyan}  DROPBEAR ${NC}: $resdbr" "${Cyan} SSH-WS ${NC}: $ressshws" "${Cyan}Stunnel ${NC}: $sshstunel"
echo -e "${Cyan} ┌──────────────────────────────────────────────┐${NC}"
echo -e "     ${Cyan}[${NC}01${Cyan}] SSHWS       ${NC}[ ${Yellow}${ssh}${Cyan} ] ${NC}" 
echo -e "" 
echo -e "     ${Cyan}[${NC}06${BICyan}] EXP FILES ${BICyan}${BIYellow}${BICyan}       ${BICyan}[${BIWhite}20${BICyan}] INFO SCRIPT ${BICyan}${BIYellow}${BICyan}${NC}"    
echo -e "     ${Cyan}[${NC}07${BICyan}] AUTO REBOOT ${BICyan}${BIYellow}${BICyan}     ${BICyan}[${BIWhite}21${BICyan}] CLEAR LOG ${BICyan}${BIYellow}${BICyan}${NC}"    
echo -e "     ${Cyan}[${NC}08${BICyan}] REBOOT ${BICyan}${BIYellow}${BICyan}          ${BICyan}[${BIWhite}22${BICyan}] TASK MANAGER ${BICyan}${BIYellow}${BICyan}${NC}"    
echo -e "     ${Cyan}[${NC}09${BICyan}] RESTART ${BICyan}${BIYellow}${BICyan}         ${BICyan}[${BIWhite}23${BICyan}] DNS CHANGER ${BICyan}${BIYellow}${BICyan}${NC}"    
echo -e "     ${Cyan}[${NC}10${BICyan}] UPDATE MENU ${BICyan}${BIYellow}${BICyan}     ${BICyan}[${BIWhite}24${BICyan}] NETFLIX CHECKER ${BICyan}${BIYellow}${BICyan}${NC}"
echo -e "     ${BICyan}[${BIWhite}11${BICyan}] ADD HOST/DOMAIN ${BICyan}${BIYellow}${BICyan} ${BICyan}[${BIWhite}25${BICyan}] TENDANG ${BICyan}${BIYellow}${BICyan}${NC}" 
echo -e "     ${BICyan}[${BIWhite}12${BICyan}] RENEW CERT ${BICyan}${BIYellow}${BICyan}      ${BICyan}[${BIWhite}26${BICyan}] XRAY-CORE MENU ${BICyan}${BIYellow}${BICyan}${NC}"       
echo -e "     ${BICyan}[${BIWhite}13${BICyan}] EDIT BANNER ${BICyan}${BIYellow}${BICyan}     ${BICyan}[${BIWhite}27${BICyan}] INSTALL BBRPLUS ${BICyan}${BIYellow}${BICyan}${NC}" 
echo -e "     ${BICyan}[${BIWhite}14${BICyan}] RUNNING STATUS ${BICyan}${BIYellow}${BICyan}  ${BICyan}[${BIWhite}28${BICyan}] SWAPRAM MENU ${BICyan}${BIYellow}${BICyan}${NC}" 
echo -e "     ${BICyan}[${BIWhite}15${BICyan}] USER BANDWIDTH ${BICyan}${BIYellow}${BICyan}  ${BICyan}[${BIWhite}29${BICyan}] BACKUP ${BICyan}${BIYellow}${BICyan}${NC}" 
echo -e "     ${BICyan}[${BIWhite}16${BICyan}] SPEEDTEST ${BICyan}${BIYellow}${BICyan}       ${BICyan}[${BIWhite}30${BICyan}] RESTORE ${BICyan}${BIYellow}${BICyan}${NC}"
echo -e "     ${BICyan}[${BIWhite}17${BICyan}] CHECK BANDWIDTH ${BICyan}${BIYellow}${BICyan} ${BICyan}[${BIWhite}x ${BICyan}] EXIT ${BICyan}${BIYellow}${BICyan}${NC}"
echo -e "     ${BICyan}[${BIWhite}18${BICyan}] LIMIT SPEED ${BICyan}${BIYellow}${BICyan}${NC}"
echo -e "     ${BICyan}[${BIWhite}19${BICyan}] WEBMIN ${BICyan}${BIYellow}${BICyan}${NC}"
echo -e " ${BICyan}┌──────────────────────────────────────────────┐${NC}"
echo -e " ${BICyan}│   Version      ${NC} : $sem Last Update            ${BICyan}│${NC}"
echo -e " ${BICyan}└──────────────────────────────────────────────┘${NC}"
echo
read -p " Select menu : " opt
echo -e ""
case $opt in
1) clear ; menu-ssh ;;
2) clear ; menu-vmess ;;
3) clear ; menu-vless ;;
4) clear ; menu-trojan ;;
5) clear ; menu-ss ;;
6) clear ; xp ;;
7) clear ; autoreboot ;;
8) clear ; reboot ;;
9) clear ; restart ;;
10) clear ; updatemenu;;
11) clear ; addhost ;;
12) clear ; genssl ;;
13) clear ; nano /etc/issue.net ;;
14) clear ; running ;;
15) clear ; cek-trafik ;;
16) clear ; cek-speed ;;
17) clear ; cek-bandwidth ;;
18) clear ; limit-speed ;;
19) clear ; wbm ;;
20) clear ; cat /root/log-install.txt ;;
21) clear ; clearlog ;;
22) clear ; gotop ;;
23) clear ; dns ;;
24) clear ; netf ;;
25) clear ; tendang ;;
26) clear ; wget -q -O /usr/bin/xraychanger "https://raw.githubusercontent.com/NevermoreSSH/Xcore-custompath/main/xraychanger.sh" && chmod +x /usr/bin/xraychanger && xraychanger ;;
27) clear ; bbr ;;
28) clear ; wget -q -O /usr/bin/swapram "https://raw.githubusercontent.com/NevermoreSSH/swapram/main/swapram.sh" && chmod +x /usr/bin/swapram && swapram ;;
29) clear ; backup ;;
30) clear ; restore ;;

0) clear ; menu ;;
x) exit ;;
*) echo -e "" ; echo "Press any key to back exit" ; sleep 1 ; exit ;;
esac

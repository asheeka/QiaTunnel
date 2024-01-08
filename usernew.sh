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
export HERROR="[${RED} ERROR ${NC}]"
export HINFO="[${YELLOW} INFO ${NC}]"
export HOK="[${GREEN} OKEY ${NC}]"

# // Root Checking
if [ "${EUID}" -ne 0 ]; then
		echo -e "${HERROR} Please Run This Script As Root User !"
		exit 1
fi

# // Get VPS IP Address
export IP=$( curl -s https://ipinfo.io/ip/ )

clear
domen=`cat /root/domain`
domain=`cat /root/domain`
portsshws=`cat /root/log-install.txt | grep -w "SSH Websocket" | cut -d: -f2 | awk '{print $1}'`
wsssl=`cat /root/log-install.txt | grep -w "SSH SSL Websocket" | cut -d: -f2 | awk '{print $1}'`

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}            SSH Account            ${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
read -p "Username : " Login
read -p "Password : " Pass
read -p "Expired (hari): " masaaktif

opensh=`cat /root/log-install.txt | grep -w "OpenSSH" | cut -f2 -d: | awk '{print $1}'`
db=`cat /root/log-install.txt | grep -w "Dropbear" | cut -f2 -d: | awk '{print $1,$2}'`
ssl="$(cat /root/log-install.txt | grep -w "Stunnel5" | cut -d: -f2)"
sleep 1
clear
useradd -e `date -d "$masaaktif days" +"%Y-%m-%d"` -s /bin/false -M $Login
exp="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null
PID=`ps -ef |grep -v grep | grep sshws |awk '{print $2}'`

cat > /home/vps/public_html/ssh-$Login.txt <<-END

====================================================================
        SSH Account       
====================================================================
Username : $Login
Password : $Pass
Expired On : $exp
====================================================================
IP Address : $IP
Host : $domen
OpenSSH : $opensh
Dropbear : $db
SSH-WS : $portsshws
SSH-SSL-WS : $wsssl
SSL/TLS : $ssl
UDPGW : 7100-7300
====================================================================
Payload WSS: GET wss://BUG.COM/ HTTP/1.1[crlf]Host: $domain[crlf]Upgrade: websocket[crlf][crlf] 
====================================================================

END

if [[ ! -z "${PID}" ]]; then
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | tee -a /etc/log-create-user.log
echo -e "${GREEN}            SSH Account            ${NC}" | tee -a /etc/log-create-user.log
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | tee -a /etc/log-create-user.log
echo -e "Username : $Login" | tee -a /etc/log-create-user.log
echo -e "Password : $Pass" | tee -a /etc/log-create-user.log
echo -e "Expired On : $exp" | tee -a /etc/log-create-user.log
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | tee -a /etc/log-create-user.log
echo -e "IP Address : $IP" | tee -a /etc/log-create-user.log
echo -e "Host : $domen" | tee -a /etc/log-create-user.log
echo -e "OpenSSH : $opensh" | tee -a /etc/log-create-user.log
echo -e "Dropbear : $db" | tee -a /etc/log-create-user.log
echo -e "SSH-WS : $portsshws" | tee -a /etc/log-create-user.log
echo -e "SSH-SSL-WS : $wsssl" | tee -a /etc/log-create-user.log
echo -e "SSL/TLS : $ssl" | tee -a /etc/log-create-user.log
echo -e "UDPGW : 7100-7300" | tee -a /etc/log-create-user.log
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | tee -a /etc/log-create-user.log
echo -e "Link SSH Config : http://${domain}:81/ssh-$Login.txt" | tee -a /etc/log-create-user.log
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | tee -a /etc/log-create-user.log
echo -e "Payload WS" | tee -a /etc/log-create-user.log
echo -e "
GET / [protocol][crlf]Host: [host][crlf]Connection: Keep-Alive[crlf]Connection: Upgrade[crlf]Upgrade: websocket[crlf][crlf]
" | tee -a /etc/log-create-user.log
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | tee -a /etc/log-create-user.log
echo -e "
GET wss://bug.com/ [protocol][crlf]Host: [host][crlf]Connection: Keep-Alive[crlf]Connection: Upgrade[crlf]Upgrade: websocket[crlf][crlf]
" | tee -a /etc/log-create-user.log
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | tee -a /etc/log-create-user.log
echo -e "
GET / [protocol][crlf]Host: $domen[crlf]Connection: Keep-Alive[crlf]Connection: Upgrade[crlf]Upgrade: websocket[crlf][crlf]
" | tee -a /etc/log-create-user.log
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | tee -a /etc/log-create-user.log
echo -e "
GET wss://bug.com/ [protocol][crlf]Host: $domen[crlf]Connection: Keep-Alive[crlf]Connection: Upgrade[crlf]Upgrade: websocket[crlf][crlf]
" | tee -a /etc/log-create-user.log
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | tee -a /etc/log-create-user.log

else

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | tee -a /etc/log-create-user.log
echo -e "${GREEN}            SSH Account            ${NC}" | tee -a /etc/log-create-user.log
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | tee -a /etc/log-create-user.log
echo -e "Username : $Login" | tee -a /etc/log-create-user.log
echo -e "Password : $Pass" | tee -a /etc/log-create-user.log
echo -e "Expired On : $exp" | tee -a /etc/log-create-user.log
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | tee -a /etc/log-create-user.log
echo -e "IP Address : $IP" | tee -a /etc/log-create-user.log
echo -e "Host : $domen" | tee -a /etc/log-create-user.log
echo -e "OpenSSH : $opensh" | tee -a /etc/log-create-user.log
echo -e "Dropbear : $db" | tee -a /etc/log-create-user.log
echo -e "SSH-WS : $portsshws" | tee -a /etc/log-create-user.log
echo -e "SSH-SSL-WS : $wsssl" | tee -a /etc/log-create-user.log
echo -e "SSL/TLS : $ssl" | tee -a /etc/log-create-user.log
echo -e "UDPGW : 7100-7300" | tee -a /etc/log-create-user.log
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | tee -a /etc/log-create-user.log
echo -e "Link SSH Config : http://${domain}:81/ssh-$Login.txt" | tee -a /etc/log-create-user.log
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | tee -a /etc/log-create-user.log
echo -e "Payload WS" | tee -a /etc/log-create-user.log
echo -e "
GET / [protocol][crlf]Host: [host][crlf]Connection: Keep-Alive[crlf]Connection: Upgrade[crlf]Upgrade: websocket[crlf][crlf]
" | tee -a /etc/log-create-user.log
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | tee -a /etc/log-create-user.log
echo -e "
GET wss://bug.com/ [protocol][crlf]Host: [host][crlf]Connection: Keep-Alive[crlf]Connection: Upgrade[crlf]Upgrade: websocket[crlf][crlf]
" | tee -a /etc/log-create-user.log
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | tee -a /etc/log-create-user.log
echo -e "
GET / [protocol][crlf]Host: $domen[crlf]Connection: Keep-Alive[crlf]Connection: Upgrade[crlf]Upgrade: websocket[crlf][crlf]
" | tee -a /etc/log-create-user.log
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | tee -a /etc/log-create-user.log
echo -e "
GET wss://bug.com/ [protocol][crlf]Host: $domen[crlf]Connection: Keep-Alive[crlf]Connection: Upgrade[crlf]Upgrade: websocket[crlf][crlf]
" | tee -a /etc/log-create-user.log
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | tee -a /etc/log-create-user.log
fi
echo "" | tee -a /etc/log-create-user.log
read -n 1 -s -r -p "Press any key to back on menu"
menu

#!/bin/bash

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

clear
echo -e "${GREEN}┌─────────────────────────────────────────┐${NC}"
echo -e "${YELLOW}               ⇱ DNS CHANGER ⇲            ${NC}"
echo -e "${GREEN}└─────────────────────────────────────────┘${NC}"

dnsfile="/root/dns"
if test -f "$dnsfile"; then
udns=$(cat /root/dns)
echo -e ""
echo -e "   Active DNS : ${CYAN}$udns${NC}"
fi
echo -e "
 [\033[1;36m 1 \033[0m]  Temporary DNS
 [\033[1;36m 2 \033[0m]  Permanent DNS
 [\033[1;36m 3 \033[0m]  Reset DNS To Default
 [\033[1;36m 4 \033[0m]  Update resolv.conf Latest
 [\033[1;36m 5 \033[0m]  Back To Main Menu"
echo ""
echo -e "\033[1;37mPress [ Ctrl+C ] • To-Exit-Script${NC}"
echo ""
read -p "Select From Options [ 1 - 5 ] :  " dns
echo -e ""
case $dns in
1)
	clear
	echo -e "\033[1;37mTemporary DNS - Back To Default DNS After Rebooting VPS\033[0m"
	echo ""
	read -p "Please Insert DNS : " dns1
	if [ -z $dns1 ]; then
		echo ""
		echo "Please Insert DNS !"
		sleep 1
		clear
		dns
	fi
	rm /etc/resolv.conf
	touch /etc/resolv.conf
	echo "$dns1" > /root/dns
	echo "nameserver $dns1" >> /etc/resolv.conf
	systemctl restart resolvconf.service
	echo ""
	echo -e "\e[032;1mDNS $dns1 sucessfully insert in VPS\e[0m"
	echo ""
	cat /etc/resolv.conf
	sleep 1
	clear
	dns
	;;
2)
	clear
	echo ""
	read -p "Please Insert DNS : " dns2
	if [ -z $dns2 ]; then
	echo ""
	echo "Please Insert DNS !"
	sleep 1
	clear
	dns
	fi
	rm /etc/resolv.conf
	rm /etc/resolvconf/resolv.conf.d/head
	touch /etc/resolv.conf
	touch /etc/resolvconf/resolv.conf.d/head
	echo "$dns2" > /root/dns
	echo "nameserver $dns2" >> /etc/resolv.conf
	echo "nameserver $dns2" >> /etc/resolvconf/resolv.conf.d/head
	systemctl restart resolvconf.service
	echo ""
	echo -e "\e[032;1mDNS $dns2 sucessfully insert in VPS\e[0m"
	echo ""
	cat /etc/resolvconf/resolv.conf.d/head
	sleep 1
	clear
	dns
	;;
3)
	clear
	echo ""
	read -p "Reset To Default DNS [Y/N]: " -e answer
	if [ "$answer" = 'y' ] || [ "$answer" = 'Y' ]; then
	rm /root/dns
	echo ""
	echo -e "${INFO} Delete Resolv.conf DNS"
	echo "nameserver 8.8.8.8" > /etc/resolv.conf
	sleep 1
	echo -e "${INFO} Delete Resolv.conf.d/head DNS"
	echo "nameserver 8.8.8.8" > /etc/resolvconf/resolv.conf.d/head
	sleep 1
	else if [ "$answer" = 'n' ] || [ "$answer" = 'N' ]; then
	echo -e ""
	echo -e "${INFO} Operation Cancelled By User"
	sleep 1
	fi
	fi
	clear
	dns
	;;
4)
	clear
	apt install resolvconf
	echo -e "\e[032;1mresolve.conf sucessfully updated\e[0m"
	resolvectl status | grep "DNS Server" -A2
	sleep 1
	clear
	dns
	;;
5)
	clear
	menu
	;;
	*)
	echo "Please enter an correct number"
	clear
	dns
	;;
esac
#!/bin/bash
# // Root Checking
if [ "${EUID}" -ne 0 ]; then
	echo -e "${HERROR} Please Run This Script As Root User !"
	exit 1
fi

# // Color DEFINITION
export RED='\e[0;31m'
export GREEN='\e[0;32m'
export YELLOW='\e[0;33m'
export BLUE='\e[0;34m'
export PURPLE='\e[0;35m'
export CYAN='\e[0;36m'
export LIGHT='\e[0;37m'
export NC='\e[0m'

# // Header Color DEFINITON
export HERROR="[${RED} ERROR ${NC}]"
export HINFO="[${YELLOW} INFO ${NC}]"
export HOK="[${GREEN} OK ${NC}]"

# // Exporting Script Version
export VERSION="1.1"

# // Exporint IP AddressInformation
export IP=$(curl -s https://ipinfo.io/ip)

# // Set Time To Jakarta / GMT  7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# // cek old script
if [[ -r /etc/xray/domain ]]; then
	echo -e "${HINFO} Having Script Detected !"
	echo -e "${HINFO} If You Replacing Script, All Client Data On This VPS Will Be Cleanup !"
	read -p " Are You Sure Wanna Replace Script ? (Y/N) " ReplaceScript
	if [[ $ReplaceScript == "Y" ]]; then
		clear
		echo -e "${HINFO} Starting Replacing Script !"
	elif [[ $ReplaceScript == "y" ]]; then
		clear
		echo -e "${HINFO} Starting Replacing Script !"
		rm -rf /var/lib/scrz-prem
	elif [[ $ReplaceScript == "N" ]]; then
		echo -e "${HINFO} Action Canceled !"
		exit 1
	elif [[ $ReplaceScript == "n" ]]; then
		echo -e "${HINFO} Action Canceled !"
		exit 1
	else
		echo -e "${HERROR} Your Input Is Wrong !"
		exit 1
	fi
	clear
fi

echo -e "${HINFO} Starting Installation............"
# // Go To Root Directory
cd /root/
# // Remove
apt-get remove --purge nginx* -y
apt-get remove --purge nginx-common* -y
apt-get remove --purge nginx-full* -y
apt-get remove --purge dropbear* -y
apt-get remove --purge stunnel4* -y
apt-get remove --purge apache2* -y
apt-get remove --purge ufw* -y
apt-get remove --purge firewalld* -y
apt-get remove --purge exim4* -y
apt autoremove -y

echo -e "${HINFO} Update and upgrade first"
sleep 1
apt update -y
apt upgrade -y
apt dist-upgrade -y

echo -e "${HINFO} Install Requirement Tools"
sleep 1
apt-get --reinstall --fix-missing install -y sudo apt-transport-https autoconf automake bc build-essential bzip2 coreutils curl dirmngr dos2unix dpkg dropbear g gcc git gnupg gnupg1 gzip htop iftop iptables iptables-persistent jq libreadline-dev libssl-dev libxml-parser-perl lsof m4 make nano neofetch net-tools nmap perl psmisc python2 rsyslog ruby screen sed socat tmux unzip vim wget wondershaper zip zlib1g-dev
apt-get --reinstall --fix-missing install -y libxml-parser-perl screenfetch openssl easy-rsa fail2ban libsqlite3-dev cron bash-completion ntpdate xz-utils dnsutils lsb-release chrony gem install lolcat

clear

echo -e "${HINFO} Remove adn Make some folder"
sleep 1

# // Folder Sistem Yang Tidak Boleh Di Hapus
mkdir -p /usr/bin
# // Remove File & Directory
rm -fr /usr/local/bin/stunnel
rm -fr /usr/local/bin/stunnel5
rm -fr /etc/nginx
rm -fr /var/lib/scrz-prem/

# // Making Directory
mkdir -p /etc/nginx
mkdir -p /etc/xray
mkdir -p /var/lib/scrz-prem/

# // String / Request Data
mkdir -p /var/lib/scrz-prem >/dev/null 2>&1
host=$(hostname)
echo "IP=$host" >>/var/lib/scrz-prem/ipvps.conf
echo $host >/root/domain
sleep 2

echo "┌─────────────────────────────────────────┐"
echo "                INSTALL DOMAIN             "
echo "└─────────────────────────────────────────┘"
sleep 1
wget https://raw.githubusercontent.com/asheeka/QiaTunnel/main/cf.sh && chmod x cf.sh && ./cf.sh

#install ssh-vpn
echo "┌─────────────────────────────────────────┐"
echo "             Install SSH / WS            "
echo "└─────────────────────────────────────────┘"
sleep 1

wget -q https://raw.githubusercontent.com/asheeka/QiaTunnel/main/ssh-vpn.sh && chmod x ssh-vpn.sh && ./ssh-vpn.sh
wget -q https://raw.githubusercontent.com/asheeka/QiaTunnel/main/ins-xray.sh && chmod x ins-xray.sh && ./ins-xray.sh

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
wget -q -O /usr/bin/updatemenu "https://raw.githubusercontent.com/asheeka/QiaTunnel/main/updatemenu.sh"

chmod x /usr/bin/autoreboot
chmod x /usr/bin/clearlog
chmod x /usr/bin/dns
chmod x /usr/bin/limit-speed
chmod x /usr/bin/menu
chmod x /usr/bin/menu-ssh
chmod x /usr/bin/netf
chmod x /usr/bin/cek-ram
chmod x /usr/bin/restart
chmod x /usr/bin/running
chmod x /usr/bin/cek-speed
chmod x /usr/bin/tendang
chmod x /usr/bin/usernew
chmod x /usr/bin/wbm
chmod x /usr/bin/updatemenu

# > Setup Crontab
echo "0 5 * * * root clear-log && reboot" >>/etc/crontab
echo "0 0 * * * root delete" >>/etc/crontab
cd

cat >/etc/cron.d/xp_otm <<-END
	SHELL=/bin/sh
	PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
	2 0 * * * root /usr/bin/xp
END

cat >/etc/cron.d/cl_otm <<-END
	SHELL=/bin/sh
	PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
	2 1 * * * root /usr/bin/clearlog
END

cat >/home/re_otm <<-END
	7
END

service cron restart >/dev/null 2>&1
service cron reload >/dev/null 2>&1

clear
cat >/root/.profile <<END
# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n || true
clear
menu
END

chmod 644 /root/.profile

if [ -f "/root/log-install.txt" ]; then
	rm -fr /root/log-install.txt
fi
if [ -f "/etc/afak.conf" ]; then
	rm -fr /etc/afak.conf
fi
if [ ! -f "/etc/log-create-user.log" ]; then
	echo "Log All Account " >/etc/log-create-user.log
fi
history -c
aureb=$(cat /home/re_otm)
b=11
if [ $aureb -gt $b ]; then
	gg="PM"
else
	gg="AM"
fi
echo -e "[ ${green}Please Wait Update DB ${NC} ]"
git clone https://github.com/asheeka/limit.git /root/limit/ &>/dev/null
babu=$(cat /etc/.geovpn/license.key)
echo -e "$babu $IP" >>/root/limit/limit.txt
cd /root/limit
git config --global user.email "foreverwelearn@gmail.com" &>/dev/null
git config --global user.name "asheeka" &>/dev/null
rm -fr .git &>/dev/null
git init &>/dev/null
git add . &>/dev/null
git commit -m m &>/dev/null
git branch -M main &>/dev/null
git remote add origin https://github.com/asheeka/QiaTunnel/limit
git push -f https://github.com/asheeka/limit.git &>/dev/null
cd
echo "1.1" >>/home/.ver
rm -fr /root/limit
curl -s https://ipinfo.io/ip >/etc/myipvps
echo ""
echo "=======================-[ ${GREEN}TUNNELING${NC} ]-======================"
echo ""
echo "------------------------------------------------------------"
echo ""
echo "   >>> Service & Port" | tee -a log-install.txt
echo "   - OpenSSH                 : 22" | tee -a log-install.txt
echo "   - SSH Websocket           : 80" | tee -a log-install.txt
echo "   - SSH SSL Websocket       : 443" | tee -a log-install.txt
echo "   - Stunnel5                : 447, 777" | tee -a log-install.txt
echo "   - Dropbear                : 109, 143" | tee -a log-install.txt
echo "   - Badvpn                  : 7100-7300" | tee -a log-install.txt
echo "" | tee -a log-install.txt
echo "   >>> Server Information & Other Features" | tee -a log-install.txt
echo "   - Timezone                : Asia/Jakarta (GMT  7)" | tee -a log-install.txt
echo "   - Fail2Ban                : [ON]" | tee -a log-install.txt
echo "   - Dflate                  : [ON]" | tee -a log-install.txt
echo "   - IPtables                : [ON]" | tee -a log-install.txt
echo "   - Auto-Reboot             : [ON]" | tee -a log-install.txt
echo "   - IPv6                    : [OFF]" | tee -a log-install.txt
echo "   - Autoreboot Off          : $aureb:00 $gg GMT   7" | tee -a log-install.txt
echo "   - Autobackup Data" | tee -a log-install.txt
echo "   - AutoKill Multi Login User" | tee -a log-install.txt
echo "   - Auto Delete Expired Account" | tee -a log-install.txt
echo "   - Fully automatic script" | tee -a log-install.txt
echo "   - VPS settings" | tee -a log-install.txt
echo "   - Admin Control" | tee -a log-install.txt
echo "   - Change port" | tee -a log-install.txt
echo ""
echo "------------------------------------------------------------"
echo ""
echo "=======================-[ ${GREEN}TUNNELING${NC} ]-======================"
echo -e ""
echo ""
echo "" | tee -a log-install.txt
rm -fr /root/ssh-vpn.sh
rm -fr /root/setup.sh
#rm -fr /root/domain
history -c
read -p "$(echo -e "Press ${PURPLE}[ ${NC}${GREEN}Enter${NC} ${CYAN}]${NC} For Reboot") "
reboot

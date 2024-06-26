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

# // Root Checking
if [ "${EUID}" -ne 0 ]; then
		echo -e "${HERROR} Please Run This Script As Root User !"
		exit 1
fi

# // Exporting IP Address
export IP=$(curl -s https://ipinfo.io/ip)

clear
Green_font_prefix="\033[32m"
Red_font_prefix="\033[31m"
Green_background_prefix="\033[42;37m"
Red_background_prefix="\033[41;37m"
Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[Installed]${Font_color_suffix}"
Error="${Red_font_prefix}[Not Installed]${Font_color_suffix}"
cek=$(netstat -ntlp | grep 10000 | awk '{print $7}' | cut -d'/' -f2)

function install () {
	IP=$(curl -s https://ipinfo.io/ip/);
	echo " Menambahkan Repositori Webmin"
	sh -c 'echo "deb http://download.webmin.com/download/repository sarge contrib" > /etc/apt/sources.list.d/webmin.list'
		
	#apt install gnupg gnupg1 gnupg2 -y
	wget http://www.webmin.com/jcameron-key.asc
	apt-key add jcameron-key.asc
	
	echo " Mulai Install Webmin"
	clear
	sleep 0.5
	apt update > /dev/null 2>&1
	apt install webmin -y
	
	sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
	#/etc/init.d/webmin restart
	systemctl restart webmin
	rm -f /root/jcameron-key.asc
	clear
	echo ""
	echo " Berhasil Install Webmin"
	echo " $IP:10000"
	read -n 1 -s -r -p "Press any key to back on menu"
	wbm
}

function restart () {
	echo " Mulai Webmin"
	sleep 0.5
	echo " Mulai Restart Webmin"
	service webmin restart > /dev/null 2>&1
	clear
	echo ""
	echo " Berhasil Restart Webmin"
	read -n 1 -s -r -p "Press any key to back on menu"
	wbm
}

function uninstall () {
	echo " Menghapus Repositori Webmin"
	rm -f /etc/apt/sources.list.d/webmin.list
	apt update > /dev/null 2>&1
	echo " Mulai Uninstall Webmin"
	clear
	sleep 0.5
	apt autoremove --purge webmin -y > /dev/null 2>&1
	clear
	echo ""
	echo " Berhasil Uninstall Webmin"
	read -n 1 -s -r -p "Press any key to back on menu"
	wbm
}

if [[ "$cek" = "perl" ]]; then
	sts="${Info}"
	else
	sts="${Error}"
fi

clear
echo -e " ==============================" | lolcat
echo -e "           Webmin Menu         "
echo -e " ==============================" | lolcat
echo -e " Status $sts"
echo -e "  1. Install Webmin"
echo -e "  2. Restart Webmin"
echo -e "  3. Uninstall Webmin"
echo -e "  4. Menu"
echo -e " "
read -rp " Please Enter The Correct Number : " -e num

if [[ "$num" = "1" ]]; then
	install
elif [[ "$num" = "2" ]]; then
	restart
elif [[ "$num" = "3" ]]; then
	uninstall
elif [[ "$num" = "4" ]]; then
	clear
	menu
else
	clear
	echo "Masukkan Angka Yang Ada!"
	menu
fi

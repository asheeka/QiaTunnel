#!/bin/bash
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

# // Exporting IP Address
export IP=$(curl -s https://ipinfo.io/ip/)

clear
source /var/lib/scrz-prem/ipvps.conf
if [[ "$IP" = "" ]]; then
	domain=$(cat /etc/xray/domain)
else
	domain=$IP
fi

echo -e "${HINFO} Checking... "
sleep 1
echo -e "${HINFO} Setting ntpdate"
sleep 1
domain=$(cat /root/domain)
apt install iptables iptables-persistent -y
apt install curl socat xz-utils wget apt-transport-https gnupg gnupg2 gnupg1 dnsutils lsb-release -y
apt install socat cron bash-completion ntpdate -y
#ntpdate pool.ntp.org
ntpdate -u pool.ntp.org
apt -y install chrony
timedatectl set-ntp true
#systemctl enable chronyd && systemctl restart chronyd
systemctl enable chrony && systemctl restart chrony
timedatectl set-timezone Asia/Jakarta

apt install curl pwgen openssl netcat cron -y

# Make Folder & Log XRay & Log Trojan
rm -fr /var/log/xray
#rm -fr /var/log/trojan
rm -fr /home/vps/public_html
mkdir -p /var/log/xray
mkdir -p /home/vps/public_html
chown www-data.www-data /var/log/xray
chown www-data.www-data /etc/xray
chmod +x /var/log/xray
touch /var/log/xray/access.log
touch /var/log/xray/error.log
touch /var/log/xray/access2.log
touch /var/log/xray/error2.log
# Make Log Autokill & Log Autoreboot
rm -fr /root/log-limit.txt
rm -fr /root/log-reboot.txt
touch /root/log-limit.txt
touch /root/log-reboot.txt
touch /home/limit
echo "" > /root/log-limit.txt
echo "" > /root/log-reboot.txt

# Install Wondershaper
cd /root/
apt install wondershaper -y
git clone https://github.com/magnific0/wondershaper.git >/dev/null 2>&1
cd wondershaper
make install
cd
rm -fr /root/wondershaper
echo > /home/limit

# nginx for debian & ubuntu
install_ssl(){
    if [ -f "/usr/bin/apt-get" ];then
            isDebian=`cat /etc/issue|grep Debian`
            if [ "$isDebian" != "" ];then
                    apt-get install -y nginx certbot
                    apt install -y nginx certbot
                    sleep 3s
            else
                    apt-get install -y nginx certbot
                    apt install -y nginx certbot
                    sleep 3s
            fi
    else
        yum install -y nginx certbot
        sleep 3s
    fi

    systemctl stop nginx.service

    if [ -f "/usr/bin/apt-get" ];then
            isDebian=`cat /etc/issue|grep Debian`
            if [ "$isDebian" != "" ];then
                    echo "A" | certbot certonly --renew-by-default --register-unsafely-without-email --standalone -d $domain
                    sleep 3s
            else
                    echo "A" | certbot certonly --renew-by-default --register-unsafely-without-email --standalone -d $domain
                    sleep 3s
            fi
    else
        echo "Y" | certbot certonly --renew-by-default --register-unsafely-without-email --standalone -d $domain
        sleep 3s
    fi
}

# install nginx
apt install -y nginx
cd
rm -fr /etc/nginx/sites-enabled/default
rm -fr /etc/nginx/sites-available/default
wget -q -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/asheeka/QiaTunnel/main/nginx.conf" 
mkdir -p /home/vps/public_html
wget -q -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/asheeka/QiaTunnel/main/vps.conf"

# / / Make Main Directory
mkdir -p /usr/bin/xray
mkdir -p /etc/xray
mkdir -p /usr/local/etc/xray

# // Making Certificate
clear
echo -e "${HINFO} Starting renew cert... " 
sleep 2
echo -e "${HOK} Starting Generating Certificate"
##Generate acme certificate
curl https://get.acme.sh | sh
alias acme.sh=~/.acme.sh/acme.sh
/root/.acme.sh/acme.sh --upgrade --auto-upgrade
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
/root/.acme.sh/acme.sh --issue -d "${domain}" --standalone --keylength ec-256
/root/.acme.sh/acme.sh --install-cert -d "${domain}" --ecc \
--fullchain-file /etc/xray/xray.crt \
--key-file /etc/xray/xray.key
chown -R nobody:nogroup /etc/xray
chmod 644 /etc/xray/xray.crt
chmod 644 /etc/xray/xray.key
echo -e "${OKEY} Your Domain : $domain"

# nginx renew ssl
echo -n '#!/bin/bash
/etc/init.d/nginx stop
"/root/.acme.sh"/acme.sh --cron --home "/root/.acme.sh" &> /root/renew_ssl.log
/etc/init.d/nginx start
' > /usr/local/bin/ssl_renew.sh
chmod +x /usr/local/bin/ssl_renew.sh
if ! grep -q 'ssl_renew.sh' /var/spool/cron/crontabs/root;then (crontab -l;echo "15 03 */3 * * /usr/local/bin/ssl_renew.sh") | crontab;fi

# nginx xray.conf
rm -fr /etc/nginx/conf.d/xray.conf
cat >/etc/nginx/conf.d/xray.conf <<EOF
    server {
             listen 80;
             listen [::]:80;
             listen 443 ssl http2 reuseport;
             listen [::]:443 http2 reuseport;	
             server_name 127.0.0.1 localhost;
             ssl_certificate /etc/xray/xray.crt;
             ssl_certificate_key /etc/xray/xray.key;
             ssl_ciphers EECDH+CHACHA20:EECDH+CHACHA20-draft:EECDH+ECDSA+AES128:EECDH+aRSA+AES128:RSA+AES128:EECDH+ECDSA+AES256:EECDH+aRSA+AES256:RSA+AES256:EECDH+ECDSA+3DES:EECDH+aRSA+3DES:RSA+3DES:!MD5;
             ssl_protocols TLSv1.1 TLSv1.2 TLSv1.3;
             root /home/vps/public_html;
        }
EOF
sed -i '$ ilocation /' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://127.0.0.1:700'';' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade \$http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

openssl rand -base64 16 > /etc/xray/passwd

echo -e "${HOK} Enable & Start & Restart & Nginx"
systemctl daemon-reload >/dev/null 2>&1
systemctl enable nginx >/dev/null 2>&1
systemctl start nginx >/dev/null 2>&1
systemctl restart nginx >/dev/null 2>&1
# Restart All Service
echo -e "$yell[SERVICE]$NC Restart All Service"
sleep 1
chown -R www-data:www-data /home/vps/public_html
# Enable & Restart & Xray & Trojan & Nginx
sleep 1
echo -e "${HINFO} Restart & Xray & Nginx"
systemctl daemon-reload >/dev/null 2>&1
systemctl restart nginx >/dev/null 2>&1
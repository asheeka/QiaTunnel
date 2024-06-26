#!/bin/bash
# // Root Checking
if [ ${EUID} -ne 0 ]; then
	echo -e "${HERROR} Please Run This Script As Root User !"
	exit 1
fi
 
clear

IP=$(curl -s ipinfo.io/ip )

clear

DOMAIN=onedata.my.id

echo -e "${HINFO} Give name for your sub domain"
echo -e "${HINFO} Your sub domain will added to (your-sub-domain).onedata.my.id"
read -r -p " Please enter your sub domain : " -e subdomen
#sub=$(</dev/urandom tr -dc a-z0-9 | head -c6)
#sub=$(premium)
SUB_DOMAIN=${subdomen}.${DOMAIN}
CF_ID=foreverwelearn@gmail.com
CF_KEY=1296c6be4d1fd676728ff11f720c3fb31b939
set -euo pipefail
echo "Updating DNS for ${SUB_DOMAIN}..."
ZONE=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${DOMAIN}&status=active" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

RECORD=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records?name=${SUB_DOMAIN}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

if [[ "${#RECORD}" -le 10 ]]; then
     RECORD=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${SUB_DOMAIN}'","content":"'${IP}'","ttl":120,"proxied":false}' | jq -r .result.id)
fi

RESULT=$(curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records/${RECORD}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${SUB_DOMAIN}'","content":"'${IP}'","ttl":120,"proxied":false}')
     
echo "Host : $SUB_DOMAIN"
echo $SUB_DOMAIN > /root/domain
echo "IP=$SUB_DOMAIN" > /var/lib/scrz-prem/ipvps.conf

sleep 1

echo -e "${HINFO} Domain added succesfully.."

sleep 5

#cp -r /root/domain /etc/xray/domain

rm -f /root/cf.sh

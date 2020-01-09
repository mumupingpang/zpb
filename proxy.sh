#bash <(curl -S https://raw.githubusercontent.com/mumupingpang/confz/master/z.sh)
#freenom website
echo "config nginx and letsencrypt"
apt-get install nginx -y
mkdir /usr/share/nginx/html/.well-known
sed -i "60cserver {listen 80;server_name www.upc123.tk; root /usr/share/nginx/html;location ~ /.well-known {allow all;}}" /etc/nginx/nginx.conf
sed -i "61c#include /etc/nginx/conf.d/*.conf;" /etc/nginx/nginx.conf
sed -i "62c#include /etc/nginx/sites-enabled/*;" /etc/nginx/nginx.conf
nginx -t
nginx -s reload
git clone https://github.com/letsencrypt/letsencrypt
letsencrypt/letsencrypt-auto certonly --webroot -w /usr/share/nginx/html -d www.upc123.tk -m 17863936775@163.com
letsencrypt/letsencrypt-auto certificates --cert-name www.upc123.tk
sed -i "60cserver {listen 80;listen 443 ssl;ssl_certificate /etc/letsencrypt/live/www.upc123.tk/fullchain.pem;ssl_certificate_key /etc/letsencrypt/live/www.upc123.tk/privkey.pem;server_name www.upc123.tk; root /usr/share/nginx/html;location ~ /.well-known {allow all;}}" /etc/nginx/nginx.conf
nginx -t
nginx -s reload
echo "config nginx and letsencrypt done"

echo "config squid3"
apt-get install squid3 -y
sed -i "1599chttp_port 127.0.0.1:3128" /etc/squid/squid.conf
service squid restart
echo "config squid3 done"

echo "config stunnel4"
apt-get install stunnel4 -y
sed -i "6cENABLED=1" /etc/default/stunnel4
rm -rf /etc/stunnel/stunnel.conf
echo "client = no" >> /etc/stunnel/stunnel.conf
echo "[squid]" >> /etc/stunnel/stunnel.conf
echo "accept = 4128" >> /etc/stunnel/stunnel.conf
echo "connect = 127.0.0.1:3128" >> /etc/stunnel/stunnel.conf
echo "cert = /etc/stunnel/stunnel.pem" >> /etc/stunnel/stunnel.conf
cat /etc/letsencrypt/live/www.upc123.tk/privkey.pem /etc/letsencrypt/live/www.upc123.tk/cert.pem >> /etc/stunnel/stunnel.pem
service stunnel4 restart
echo "config stunnel4 done"

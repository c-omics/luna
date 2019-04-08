#!/bin/bash

[ -f /root/.ssh/id_rsa ] || ssh-keygen -t rsa -f /root/.ssh/id_rsa -N ''
mkdir -p /tftpboot
sed -e 's/^\(\W\+disable\W\+\=\W\)yes/\1no/g' -i  /etc/xinetd.d/tftp 
sed -e 's|^\(\W\+server_args\W\+\=\W-s\W\)/var/lib/tftpboot|\1/tftpboot|g' -i /etc/xinetd.d/tftp
cp /usr/share/ipxe/undionly.kpxe /tftpboot/luna_undionly.kpxe
cp /usr/share/luna/nginx-luna.conf /etc/nginx/conf.d/luna.conf
echo 'include "/etc/named.luna.zones";' >> /etc/named.conf
touch /etc/named.luna.zones

echo "starting nginx..."
nginx &> /dev/null &

#echo "starting mongod..."
#mongod &> /dev/null &

echo "starting named..."
/usr/sbin/named -u named -c /etc/named.conf &

#echo "starting xinetd..."
#xinetd &> /dev/null &

/usr/local/bin/user_entrypoint.sh "$@"

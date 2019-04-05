

run mongo:

```
docker run --name luna-mongo -d mongo
```

run luna:

```
docker run -it  --name luna --link luna-mongo  bigr.bios.cf.ac.uk:4567/comics/luna bash
```

Once inside the luna container, create a new CentOS image:

```
export OSIMAGE_PATH=/opt/luna/os/compute
mkdir -p ${OSIMAGE_PATH}/var/lib/rpm
rpm --root ${OSIMAGE_PATH} --initdb
yum -y install yum-utils
yum --releasever=/ --installroot=${OSIMAGE_PATH} install -y centos-release
yum --installroot=${OSIMAGE_PATH} -y groupinstall Base
yum --installroot=${OSIMAGE_PATH} -y install kernel
yum --installroot=${OSIMAGE_PATH} -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum --installroot=${OSIMAGE_PATH} -y install /luna/rpm/RPMS/x86_64/luna-client*.rpm
```

Set up sshd, paswordless access and password for the root user in osimage

```
mkdir -p ${OSIMAGE_PATH}/root/.ssh
chmod 700 ${OSIMAGE_PATH}/root/.ssh
ssh-keygen -f ${OSIMAGE_PATH}/etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa
echo "root:`openssl passwd -1`" | chpasswd -e -R ${OSIMAGE_PATH}
cat /root/.ssh/id_rsa.pub >> ${OSIMAGE_PATH}/root/.ssh/authorized_keys
chmod 600 ${OSIMAGE_PATH}/root/.ssh/authorized_keys
```

Now configure a new cluster

```
luna cluster init --frontend_address 10.30.255.254
.
.
.
.
```

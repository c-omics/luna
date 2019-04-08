create a network

```
docker network create luna-network
```


run mongo:

```
docker run -d --network luna-network --name luna-mongo comics/centos-mongodb mongod
docker exec -it luna-mongo mongo
>use admin
db.createUser(
  {
    user: "luna",
    pwd: "luna",
    roles: [ { role: "userAdminAnyDatabase", db: "admin" }, "readWriteAnyDatabase" ]
  }
) 
```

run luna:

```
docker run -it  --name luna --network luna-network  comics/luna bash
## at some point we will need bind to host ports to allow PXE booting
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
ssh-keygen -f ${OSIMAGE_PATH}/root/.ssh/id_rsa -N '' -t rsa
echo "root:`openssl passwd -1`" | chpasswd -e -R ${OSIMAGE_PATH}
cat  ${OSIMAGE_PATH}/root/.ssh/id_rsa.pub >> ${OSIMAGE_PATH}/root/.ssh/authorized_keys
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

...more to follow:
  (named is not yet dealt with)



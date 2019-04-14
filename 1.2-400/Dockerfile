FROM comics/centos:latest
MAINTAINER Ian Merrick <MerrickI@Cardiff.ac.uk>

##############################################################
# Software:             luna
# Software Version:     2.5.1
# Software Website:     https://github.com/clustervision/luna
# Description:          delivers full images of operating systems 
##############################################################

ENV  APP_NAME=luna
ENV  VERSION=v1.2-400

## luna
RUN  yum install -y \ 
       boost-devel \
       gcc-c++ \
       make \
       python-devel \
       python-docutils \
       rb_libtorrent-devel \
       redhat-rpm-config \
       rpm-build \
       selinux-policy-devel \
       wget && \
     yum clean all && \
     rm -rf /var/cache/yum 
RUN  git clone https://github.com/clustervision/luna && \
     cd luna && \
     git checkout tags/$VERSION && \
     make rpm && \
     wget https://www.nsc.liu.se/~kent/python-hostlist/python-hostlist-1.17.tar.gz && \
     rpmbuild -ta python-hostlist-1.17.tar.gz && \
     yum -y install /root/rpmbuild/RPMS/noarch/python-hostlist-1.17-1.noarch.rpm && \
     rm -rf /root/rpmbuild && \
     yum install -y rpm/RPMS/x86_64/luna-[0-9]*rpm 
COPY luna.conf /etc/luna.conf    

## named
RUN  yum install -y \
       bind \
       bind-chroot \
       bind-utils && \
     yum clean all && \
     rm -rf /var/cache/yum
COPY named.conf /etc/named.conf

COPY start.sh /usr/local/bin/start.sh
ENTRYPOINT ["/usr/local/bin/start.sh"]


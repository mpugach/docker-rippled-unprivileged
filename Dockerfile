FROM ubuntu:16.04

LABEL maintainer="Maksym Pugach <pugach.m@gmail.com>"

ENV GOSU_VERSION=1.10 \
    RIPPLE_DATA=/data \
    PATH=$PATH:/opt/ripple/bin

RUN useradd -r ripple \
 && apt-get update \
 && apt-get install -y bash yum-utils alien \
 && gpg --keyserver pgp.mit.edu --recv-keys "B42F6819007F00F88E364FD4036A9C25BF357DD4" \
 || gpg --keyserver keyserver.pgp.com --recv-keys "B42F6819007F00F88E364FD4036A9C25BF357DD4" \
 || gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "B42F6819007F00F88E364FD4036A9C25BF357DD4" \
 || gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "B42F6819007F00F88E364FD4036A9C25BF357DD4" \
 && rpm -Uvh https://mirrors.ripple.com/ripple-repo-el7.rpm \
 && yumdownloader --enablerepo=ripple-stable --releasever=el7 rippled \
 && rpm --import https://mirrors.ripple.com/rpm/RPM-GPG-KEY-ripple-release \
 && rpm -K rippled*.rpm \
 && alien -i --scripts rippled*.rpm \
 && rm rippled*.rpm \
 && curl -o /usr/local/bin/gosu -fSL https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture) \
 && curl -o /usr/local/bin/gosu.asc -fSL https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture).asc \
 && gpg --verify /usr/local/bin/gosu.asc \
 && rm /usr/local/bin/gosu.asc \
 && apt-get purge yum-utils alien -y \
 && apt-get autoremove -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
 && chmod +x /usr/local/bin/gosu

COPY rippled.cfg /opt/ripple/etc/rippled.cfg
COPY docker-entrypoint.sh /entrypoint.sh

RUN chmod u+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["rippled"]

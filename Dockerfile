FROM alpine:3.8

ARG NETATALK_VERSION=3.1.11

RUN apk add --no-cache --update tzdata avahi cracklib db libldap krb5-libs libgcrypt \
 && apk add --no-cache --update --virtual .build-dep \
      wget \
      make \
      g++ \
      db-dev \
      cracklib-dev \
      avahi-dev \
      krb5-dev \
      openldap-dev \
      libgcrypt-dev \
 && cd /tmp \
 && wget -O netatalk-${NETATALK_VERSION}.tar.gz https://sourceforge.net/projects/netatalk/files/netatalk/${NETATALK_VERSION}/netatalk-${NETATALK_VERSION}.tar.gz/download \
 && tar xf netatalk-${NETATALK_VERSION}.tar.gz \
 && cd netatalk-${NETATALK_VERSION} \
 && ./configure --prefix=/usr \
      --sysconfdir=/etc/netatalk \
      --build=x86_64-alpine-linux-musl \
      --host=x86_64-alpine-linux-musl \
      --with-shadow \
      --without-pam \
      --enable-fhs \
      --enable-timelord \
      --enable-overwrite \
      --with-pkgconfdir=/etc/netatalk \
      --enable-krb4-uam \
      --enable-krbV-uam \
      --with-cnid-dbd-txn \
      --with-libgcrypt-dir \
      --with-cracklib=/var/cache/cracklib/cracklib_dict \
      --disable-srvloc \
      --enable-zeroconf \
      --enable-ddp \
      --with-ssl-dir \
      --enable-pgp-uam \
      --with-ldap \
 && make \
 && make install-strip \
 && rm -rf /tmp/* \
 && apk del .build-dep

ADD entrypoint.sh /entrypoint.sh
ADD afp.conf /etc/afp.conf

EXPOSE 548

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "/sbin/netatalk", "-d", "-F", "/etc/afp.conf" ]
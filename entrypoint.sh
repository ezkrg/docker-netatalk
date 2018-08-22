#!/bin/sh

getent passwd ${USER} 2>&1 1>/dev/null

if [ $? -ne 0 ]; then
    getent group ${GROUP} 2>&1 1>/dev/null

    if [ $? -ne 0 ]; then
        addgroup -g ${GID} ${GROUP}
    fi

    adduser -H -D -G ${GROUP} -u ${UID} ${USER}
fi

echo "${USER}:${PASSWORD}" | chpasswd

chown ${USER}:${GROUP} /timemachine

exec $@
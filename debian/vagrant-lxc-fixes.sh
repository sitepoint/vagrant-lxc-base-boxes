#!/bin/bash
set -e

source common/ui.sh
source common/utils.sh

utils.lxc.start

declare -r systemd_fix='[Unit]\nConditionVirtualization=!container'

# Fixes some networking issues
# See https://github.com/fgrehm/vagrant-lxc/issues/91 for more info
if ! $(utils.lxc.attach grep -q 'ip6-allhosts' /etc/hosts)
then
    log "Adding ipv6 allhosts entry to container's /etc/hosts"
    echo -e 'ff02::3\t\tip6-allhosts' |
        lxc-attach -n "${CONTAINER}" -- /bin/sh -c 'tee -a /etc/hosts' \
            >/dev/null
fi

if [ ${DISTRIBUTION} = 'debian' ]
then
    # Ensure locales are properly set, based on http://askubuntu.com/a/238063
    LANG=${LANG:-en_US.UTF-8}
    utils.lxc.attach sed -i "s/^# ${LANG}/${LANG}/" /etc/locale.gen

    # Fixes some networking issues
    # See https://github.com/fgrehm/vagrant-lxc/issues/91 for more info
    utils.lxc.attach sed -i -e \
        "s/\(127.0.0.1\s\+localhost\)/\1\n127.0.1.1\t${CONTAINER}\n/g" \
        /etc/hosts

    # Ensures that `/tmp` does not get cleared on halt
    # See https://github.com/fgrehm/vagrant-lxc/issues/68 for more info
    utils.lxc.attach /usr/sbin/update-rc.d -f checkroot-bootclean.sh remove
    utils.lxc.attach /usr/sbin/update-rc.d -f mountall-bootclean.sh remove
    utils.lxc.attach /usr/sbin/update-rc.d -f mountnfs-bootclean.sh remove

    # It is unclear if this is still required.
    #
    # Reconfigure the LXC
    utils.lxc.attach /bin/cp -a \
        /lib/systemd/system/getty@.service \
        /etc/systemd/system/getty@.service
    # Comment out ConditionPathExists
    utils.lxc.attach sed -i -e 's/\(ConditionPathExists=\)/# \n# \1/' \
        /etc/systemd/system/getty@.service

    # Mask udev.service and systemd-udevd.service:
    utils.lxc.attach /bin/systemctl mask udev.service systemd-udevd.service
elif [ ${DISTRIBUTION} = 'ubuntu' ]
then
    # Disable dev-hugepages.mount
    utils.lxc.attach mkdir -m 0755 /etc/systemd/system/dev-hugepages.mount.d/
    utils.lxc.attach /bin/sh -c \
        "echo -e '${systemd_fix}' | tee /etc/systemd/system/dev-hugepages.mount.d/fix.conf" \
        >/dev/null
fi

# Disable systemd-journald-audit.socket
utils.lxc.attach mkdir -m 0755 /etc/systemd/system/systemd-journald-audit.socket.d/
utils.lxc.attach /bin/sh -c \
    "echo -e '${systemd_fix}' | tee /etc/systemd/system/systemd-journald-audit.socket.d/fix.conf" \
    >/dev/null

utils.lxc.attach /usr/sbin/locale-gen ${LANG}
utils.lxc.attach update-locale LANG=${LANG}

# Fix to allow bindfs
utils.lxc.attach ln -sf /bin/true /sbin/modprobe
utils.lxc.attach mknod -m 666 /dev/fuse c 10 229

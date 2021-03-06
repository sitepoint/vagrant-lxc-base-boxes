#!/bin/bash
set -e

source common/ui.sh
source common/utils.sh

info 'Installing extra packages and upgrading'

debug 'Bringing container up'
utils.lxc.start

# Sleep for a bit so that the container can get an IP
SECS=15
log "Sleeping for $SECS seconds..."
sleep $SECS

PACKAGES=(man-db openssh-server bash-completion ca-certificates sudo)
DELPACKAGES=(nfs-kernel-server rpcbind nfs-common)

log "Installing additional packages: ${ADDPACKAGES}"
PACKAGES+=" ${ADDPACKAGES}"

if [ $DISTRIBUTION = 'ubuntu' ]
then
    PACKAGES+=' software-properties-common'
elif [ $DISTRIBUTION = 'debian' ] && [ $RELEASE = 'jessie' ]
then
    PACKAGES+=' python-software-properties'
fi
utils.lxc.attach apt-get update
utils.lxc.attach apt-get install ${PACKAGES[*]} -y --force-yes
utils.lxc.attach apt-get upgrade -y --force-yes

log "Purging unwanted packages: ${DELPACKGES}"
for package in ${DELPACKAGES} ${REMPACKAGES}
do
    if utils.lxc.pkginstalled "${package}"
    then
        utils.lxc.attach apt-get --purge remove "${package}"
    fi
done

utils.lxc.attach apt-get --purge autoremove

#!/bin/bash

utils.lxc.attach() {
    cmd="$@"
    log "Running [${cmd}] inside '${CONTAINER}' container..."
    (lxc-attach -n ${CONTAINER} -- $cmd) &>> ${LOG}
}

utils.lxc.pkginstalled() {
    lxc-create -n ${CONTAINER} -- dpkg-query -W ${1} 1>/dev/null 2>&1
}

utils.lxc.start() {
    lxc-start -d -n ${CONTAINER} &>> ${LOG} || true
}

utils.lxc.stop() {
    lxc-stop -n ${CONTAINER} &>> ${LOG} || true
}

utils.lxc.destroy() {
    lxc-destroy -n ${CONTAINER} &>> ${LOG}
}

utils.lxc.create() {
    lxc-create -n ${CONTAINER} "$@" &>> ${LOG}
}

# Function to find .dk file in parent tree
function __findDotDk {
    local WD="$1"
    local PARENTD="$(dirname $WD)"
    if test -e "${WD}/.dk"; then
        echo "${WD}/.dk"
    elif test "${PARENTD}" != "/"; then
        echo $(__findDotDk "${PARENTD}")
    fi
}

# Function to wrap into a Docker environment
function __wrapToDocker {
    # Load .dk
    local DKPATH=$(__findDotDk $PWD)
    if test -n "${DKPATH}"; then
        eval "$(cat "${DKPATH}")"
    fi

    # Some default values
    DKIMG="${DKIMG:-ubuntu:latest}"
    DKCMD="${DKCMD:-/bin/bash}"
    DKUSER="${DKUSER:-$(whoami)}"
    DKDIR="${DKDIR:-${PWD}}"

    # Prepare user settings
    if uname -a | grep -q Microsoft; then
        # WSL: prepare tmp files a bit differently
        local TMPPASSWD=/c/tmp/passwd
        local TMPGROUP=/c/tmp/group
        mkdir -p /c/tmp
        cp /etc/group "$TMPGROUP"
    else
        local TMPPASSWD=/tmp/passwd.tmp
        local TMPGROUP=/etc/group
    fi
    cp /etc/passwd "$TMPPASSWD"
    sed -i $TMPPASSWD -e "s|^`whoami`:|${DKUSER}:|"

    # Step into docker
    docker run --rm -ti \
        --user `id -u`:`id -g` \
        -v "${HOME}":"${HOME}" \
        -v $TMPPASSWD:/etc/passwd:ro \
        -v $TMPGROUP:/etc/group:ro \
        -v /etc/timezone:/etc/timezone:ro \
        -v /etc/localtime:/etc/localtime:ro \
        -e DKIMG=${DKIMG} \
        --network host \
        -w ${DKDIR} \
        --entrypoint ${DKCMD} \
        ${DKARGS} \
        ${DKIMG} \
        "$@"
}

# Install alias
alias dk=__wrapToDocker

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
    DKUSER="${DKUSER:-$(id -un)}"
    DKDIR="${DKDIR:-${PWD}}"

    # Prepare user settings
    if uname -a | grep -q Microsoft; then
        # WSL: prepare tmp files a bit differently
        local TMPPASSWD=/c/tmp/passwd
        local TMPGROUP=/c/tmp/group
        mkdir -p /c/tmp
    else
        local TMPPASSWD=/tmp/`id -u`.passwd.tmp
        local TMPGROUP=/tmp/`id -u`.group.tmp
    fi
    cp /etc/passwd "$TMPPASSWD"
    cp /etc/group "$TMPGROUP"
    if grep -qE "^`id -un`:" $TMPPASSWD; then
        # Just rename user to required one
        sed -i $TMPPASSWD -e "s|^`id -un`:|${DKUSER}:|"
    else
        # Add entry (user probably exists in NIS only)
        echo "${DKUSER}:x:`id -u`:`id -g`:${DKUSER},,,:${HOME}:/bin/bash" >> $TMPPASSWD
    fi
    if grep -qvE "^`id -gn`:" $TMPGROUP; then
        # Add entry (group probably exists in NIS only)
        echo "`id -gn`:x:`id -g`:" >> $TMPGROUP
    fi

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

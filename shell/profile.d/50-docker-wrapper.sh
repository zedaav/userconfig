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
    if test "${EXEC_ENV}" == "wsl"; then
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
    SHADOWBIND=""
    if grep -qE "^`id -un`:" $TMPPASSWD; then
        if test "`id -un`" != "${DKUSER}"; then
            # Just rename user to required one
            sed -i $TMPPASSWD -e "s|^`id -un`:|${DKUSER}:|"
        elif test "${EXEC_ENV}" != "wsl"; then
            # We can bind the shadow file to get the password working in docker
            # We can do it only in this case since /etc/shadow is only readable (and copy-able) by root
            # This means:
            # - on Linux: we can't copy to a temp loc + rename the user
            # - on WSL: we can't copy + bind it from Windows FS PoV
            SHADOWBIND="-v /etc/shadow:/etc/shadow:ro"
        fi
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
        ${SHADOWBIND} \
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

# Install alias (only if docker is installed)
if __has docker; then
    alias dk=__wrapToDocker
fi

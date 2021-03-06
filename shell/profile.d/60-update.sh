# Something to verify if userconfig repo is up to date

# Refresh function
function __checkUserConfigUpdates {
    # Need to fetch?
    local LAST="${HOME}/.cache/userconfig.fetch"
    local LASTDATE=0
    if test -e "${LAST}"; then
        LASTDATE="$(date -r ${LAST} +%s)"
    fi
    if test ! -e "${LAST}" -o "`date +%s`" -gt "$(( ${LASTDATE} + (12*60*60) ))"; then
        __fetchGitMaster "${USER_CONFIG_ROOT}"
        mkdir -p "${HOME}/.cache"
        touch "${LAST}"
    fi

    # Verify if we're late on master
    local DELTA_COMMITS="$(__getCommitsDelta "${USER_CONFIG_ROOT}")"
    if test -n "${DELTA_COMMITS}" && test "${DELTA_COMMITS}" -gt 0 && test -t 0; then
        # Config is late: warning message (only if we're in a terminal)
        echo -e "${STL_BLD}${STL_YLW}!!! userconfig has been updated; please pull !!!${STL_RST}"
    fi
}

# Ready to go ;)
__checkUserConfigUpdates

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
    if test "$(cd "${USER_CONFIG_ROOT}" && git rev-list --right-only --count master...origin/master 2> /dev/null)" -gt 0; then
        # Config is late: warning message
        echo -e "${BLD}${YLW}!!! userconfig has been updated; please pull !!!${RST}"
    fi
}

# Ready to go ;)
__checkUserConfigUpdates

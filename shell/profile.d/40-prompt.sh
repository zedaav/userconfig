# Custom path with hour and last command result
function __updateMyPrompt {
    # First of all, remember last RC
    local LASTRC=$?

    # Handle last exec duration
    local TMDSP=""
    if test -n "$LAST_EXEC_TIME_STR"; then
        TMDSP="${YLW}[${LAST_EXEC_TIME_STR}]"
    fi

    # Check execution environment
    local XENV=""
    local TENV=""
    if test -n "${EXEX_ENV}"; then
        XENV="[${EXEX_ENV}] "

        # Maybe DKIMG is set?
        if test "${EXEX_ENV}" == "dk" -a -n "${DKIMG}"; then
            # Add it to terminal window title
            TENV="(${DKIMG}) "
        fi
    fi
    
    # Python virtual env?
    local VENV=""
    if test -n "${VIRTUAL_ENV}"; then
        VENV="${YLW}($(basename ${VIRTUAL_ENV}))${RST} "
    fi

    # Git branch
    __updateGitInfo
    local GDSP=""
    if test -n "${GIT_BRANCH}"; then
        GDSP="${VLT}${RVS}▌${RSTRVS}${WHT}${BGVLT}${GIT_BRANCH}${BGRST}${VLT}${RVS}▐${RSTRVS}"
    fi

    # Last RC is non-0?
    local RCDSP=""
    if test "${LASTRC}" != 0; then
        RCDSP="${RED}[${LASTRC}]"
    fi

    # Finally set PS1
    export PS1="\[\e]0;${XENV}${TENV}\u@\h: \w\a\]${XENV}${VENV}${BLD}${GRN}\u@\h${WHT}:${BLU}\w${RST}${GDSP}${TMDSP}${RCDSP}${RST}\$ "
}

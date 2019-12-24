# Custom path with hour and last command result
function __updateMyPrompt {
    # First of all, remember last RC
    local LASTRC=$?

    # Colors and styles
    local RST="\[\e[0m\]"   # Reset
    local BLD="\[\e[1m\]"   # Bold
    local GRN="\[\e[32m\]"  # Green
    local WHT="\[\e[97m\]"  # White
    local BLU="\[\e[34m\]"  # Blue
    local YLW="\[\e[93m\]"  # Yellow
    local RED="\[\e[91m\]"  # Red
    
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

    # Last RC is non-0?
    local RCDSP=""
    if test "${LASTRC}" != 0; then
        RCDSP="${RED}[${LASTRC}]"
    fi

    # Finally set PS1
    export PS1="\[\e]0;${XENV}${TENV}\u@\h: \w\a\]${XENV}${VENV}${BLD}${GRN}\u@\h${WHT}:${BLU}\w${RST}${TMDSP}${RCDSP}${RST}\$ "
}

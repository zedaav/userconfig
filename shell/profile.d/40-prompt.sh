# Custom path with hour and last command result
function __updateMyPrompt {
    # First of all, remember last RC
    local LASTRC=$?

    # Colors
    local RST="\[${STL_RST}\]"    # Reset
    local RVS="\[\e[7m\]"         # Reverse
    local RSTRVS="\[\e[27m\]"     # Reset Reverse
    local BLD="\[${STL_BLD}\]"    # Bold
    local GRN="\[\e[32m\]"        # Green
    local WHT="\[\e[97m\]"        # White
    local BLU="\[\e[34m\]"        # Blue
    local YLW="\[${STL_YLW}\]"    # Yellow
    local RED="\[\e[91m\]"        # Red
    local VLT="\[\e[38;5;55m\]"   # Violet
    local BGVLT="\[\e[48;5;55m\]" # Background Violet
    local BGRST="\[\e[49m\]"      # Background default

    # Handle last exec duration
    local TMDSP=""
    if test -n "$LAST_EXEC_TIME_STR"; then
        TMDSP="${YLW}[${LAST_EXEC_TIME_STR}]"
    fi

    # Check execution environment
    local XENV=""
    local TENV=""
    if test -n "${EXEC_ENV}"; then
        XENV="[${EXEC_ENV}] "

        # Maybe DKIMG is set?
        if test "${EXEC_ENV}" == "dk" -a -n "${DKIMG}"; then
            # Add it to terminal window title
            TENV="(${DKIMG}) "
        fi
    fi
    
    # Python virtual env?
    local VENV=""
    if test -n "${VIRTUAL_ENV}"; then
        local VENV_NAME="${VIRTUAL_ENV_PROMPT:-($(basename ${VIRTUAL_ENV}))}"
        VENV="${YLW}${VENV_NAME}${RST} "
    fi

    # Git branch
    __updateGitInfo
    local GDSP=""
    if test -n "${GIT_BRANCH}"; then
        GDSP="${VLT}${RVS}▌${RSTRVS}${WHT}${BGVLT}${GIT_BRANCH}${BGRST}${VLT}${RVS}▐${RSTRVS}"
    fi

    # Docker context
    __updatedockerContext
    local DKCTX=""
    if test -n "${DK_CONTEXT}"; then
        DKCTX="${RED}{${DK_CONTEXT}}${RST}"
    fi

    # Last RC is non-0?
    local RCDSP=""
    if test "${LASTRC}" != 0; then
        RCDSP="${RED}[${LASTRC}]"
    fi

    # Finally set PS1
    export PS1="\[\e]0;${XENV}${TENV}\u@\h: \w\a\]${XENV}${VENV}${BLD}${GRN}\u@\h${WHT}:${BLU}\w${RST}${GDSP}${DKCTX}${TMDSP}${RCDSP}${RST}\$ "
}

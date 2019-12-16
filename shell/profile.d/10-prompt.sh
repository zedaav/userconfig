# Custom path with hour and last command result
function __updateMyPrompt {
    # Colors and styles
    local RST="\[\e[0m\]"   # Reset
    local BLD="\[\e[1m\]"   # Bold
    local GRN="\[\e[32m\]"  # Green
    local WHT="\[\e[97m\]"  # White
    local BLU="\[\e[34m\]"  # Blue
    local YLW="\[\e[93m\]"  # Yellow
    local RED="\[\e[91m\]"  # Red
    
    # Check execution environment
    local XENV=""
    local TENV=""
    if test -e /.dockerenv; then
        # we're running in a Docker container
        XENV="[dk] "

        # Maybe DKIMG is set?
        if test -n "${DKIMG}"; then
            TENV="(${DKIMG}) "
        fi
    elif uname -a | grep -q Microsoft; then
        # we're running in a WSL terminal
        XENV="[wsl] "
    fi
    PS1="\[\e]0;${XENV}${TENV}\u@\h: \w\a\]${BLD}${XENV}${GRN}\u@\h${WHT}:${BLU}\w${RST} ${YLW}\A ${RED}[\$?]${RST} \$ "
}

PROMPT_COMMAND=__updateMyPrompt

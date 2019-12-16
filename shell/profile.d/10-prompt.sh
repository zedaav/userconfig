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
    PS1="\[\e]0;\u@\h: \w\a\]${BLD}${GRN}\u@\h${WHT}:${BLU}\w${RST} ${YLW}\A ${RED}[\$?]${RST} \$ "
}

PROMPT_COMMAND=__updateMyPrompt

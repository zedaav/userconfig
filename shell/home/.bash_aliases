# Some aliases definition

# Git review
alias gr="git review -r master"

# WSL only aliases
if uname -a | grep -q Microsoft; then
    alias docker="docker.exe"
fi

# Custom path with hour and last command result
# See http://bashrcgenerator.com/ for update
export PS1="\[$(tput bold)\]\[\033[38;5;10m\]\u@\h\[\033[38;5;15m\]:\[\033[01;34m\]\w\[$(tput sgr0)\] \[\033[38;5;11m\]\A \[\033[38;5;9m\][\$?]\[\033[38;5;15m\] \\$\[$(tput sgr0)\] "

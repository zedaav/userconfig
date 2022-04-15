# Some aliases definition

# Git review
alias gr="git review -r master"

# Git commit (amend)
alias ga='git commit --amend --date="$(LANG=LC_ALL date)"'

# Load virtual env
alias venv="test -d venv && source venv/bin/activate"

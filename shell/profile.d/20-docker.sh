# Some Docker specificities (i.e. we're running in a Docker container)
if test -e /.dockerenv; then
    # Update prompt
    PS1="[docker] $PS1"
fi

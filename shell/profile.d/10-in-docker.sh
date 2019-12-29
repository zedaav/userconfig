# Some Docker specificities (i.e. we're running in a Docker container)
if test -e /.dockerenv; then
    # Just set it in env
    export EXEC_ENV="dk"
fi

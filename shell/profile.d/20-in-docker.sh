# Some Docker specificities (i.e. we're running in a Docker container)
if test -e /.dockerenv; then
    # Nothing to do at the moment
    true
fi

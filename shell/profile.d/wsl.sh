# Some WSL specificities
if uname -a | grep -q Microsoft; then
    # Is Docker installed
    if which docker > /dev/null; then
        # Set Docker host to force client using Windows Docker server
        export DOCKER_HOST=tcp://localhost:2375
    fi
fi

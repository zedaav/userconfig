# Some WSL specificities (i.e. we're running in a WSL terminal)
if uname -a | grep -q Microsoft; then
    # Just set it in env
    export EXEC_ENV="wsl"

    # Is Docker installed?
    if __has docker; then
        # Set Docker host to force client using Windows Docker server
        export DOCKER_HOST=tcp://localhost:2375
    fi
fi

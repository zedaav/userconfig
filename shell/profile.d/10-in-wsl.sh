# Some WSL specificities (i.e. we're running in a WSL terminal)
if uname -a | grep -q Microsoft; then
    # Is Docker installed?
    if which docker > /dev/null; then
        # Just set it in env
        export EXEX_ENV="wsl"

        # Set Docker host to force client using Windows Docker server
        export DOCKER_HOST=tcp://localhost:2375
    fi
fi

# Current Docker context (only if docker is installed)
if __has docker; then
    # Get Docker context
    function __updatedockerContext {
        DK_CONTEXT="$(echo $DOCKER_HOST | sed -e "s@tcp://@@g")"
    }
else
    # Stubs
    function __updatedockerContext {
        DK_CONTEXT=""
    }
fi
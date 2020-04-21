# Current Docker context (only if docker is installed)
if __has docker; then
    # Get Docker context
    function __updatedockerContext {
        DK_CONTEXT="$(docker context ls | grep ' \*' | cut -d ' ' -f 1)"
        if test "${DK_CONTEXT}" == "default"; then
            # In default context, nothing to display
            DK_CONTEXT=""
        fi
    }
else
    # Stubs
    function __updatedockerContext {
        DK_CONTEXT=""
    }
fi
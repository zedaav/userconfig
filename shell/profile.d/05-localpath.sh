# Local user path may be contributed through .profile
# The problem is that .profile is sourced only one time (on login)
# ... and software may be installed in the meantime
# So let's configure user path again here, for that kind of case

# Update PATH smartly (avoid duplicates)
function __updateUserPath {
    local PATH_TO_CONTRIB="$1"
    if echo $PATH | tr ':' '\n' | grep -q "^$PATH_TO_CONTRIB$"; then
        # Path already in the list; nothing to do
        true
    else
        PATH="$PATH_TO_CONTRIB:$PATH"
    fi
}

# Set PATH so it always includes user's private bin folders
__updateUserPath "$HOME/bin"
__updateUserPath "$HOME/.local/bin"

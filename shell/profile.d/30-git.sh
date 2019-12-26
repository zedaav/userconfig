# Utility functions for git

# Refresh git information
function __updateGitInfo {
    GIT_BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || true)"
}

# Fetch from origin
function __fetchGitMaster {
    local REPO="$1"
    (cd "$REPO" && git fetch origin master > /dev/null 2>&1 || true)
}

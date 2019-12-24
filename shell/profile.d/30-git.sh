# Utility functions for git

# Refresh git information
function __updateGitInfo {
    GIT_BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || true)"
}

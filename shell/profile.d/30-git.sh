# Utility functions for git

# Only if git is installed...
if __has git; then

    # Refresh git information
    function __updateGitInfo {
        GIT_BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || true)"
    }

    # Fetch from origin
    function __fetchGitMaster {
        local REPO="$1"
        git "--git-dir=$REPO/.git" fetch origin master > /dev/null 2>&1 || true
    }

    # Get commits delta (for master)
    function __getCommitsDelta {
        local REPO="$1"
        git "--git-dir=$REPO/.git" rev-list --right-only --count master...origin/master 2>/dev/null || true
    }

else

    # Stubs
    function __updateGitInfo {
        GIT_BRANCH=""
    }
    function __fetchGitMaster {
        true
    }
    function __getCommitsDelta {
        echo "0"
    }

fi

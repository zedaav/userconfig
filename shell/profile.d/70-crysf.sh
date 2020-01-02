# Alias and load function for cryfs

function __setupCryFS {
    # Load cryfs only if basedir is set
    if test -n "${CRYFS_BASE}"; then
        cryfs "${CRYFS_BASE}" "${HOME}/Documents"
    else
        echo "CRYFS_BASE is not set"
        return 1
    fi
}

# Setup alias only if cryfs is installed
if __has cryfs; then
    alias cry=__setupCryFS
    alias uncry="fusermount -u "${HOME}/Documents""
fi

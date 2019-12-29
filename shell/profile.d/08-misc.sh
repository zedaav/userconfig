# Miscellaneous functions

# Simpler syntax to check install
function __has {
    local CMD="$1"
    local RC=0
    which $CMD > /dev/null || RC=$?
    return $RC
}

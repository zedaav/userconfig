# Utility functions to deal with time reckonings

# Function for duration pretty printing
function __prettyPrintDuration {
    local DURATION="$1"
    local DAYS=$(( $DURATION / (60*60*24) ))
    local HOURS=$(( $DURATION / (60*60) ))
    local MINS=$(( $DURATION / 60 ))
    local SECS=$(( $DURATION % 60 ))

    # Print results
    if test $DAYS -gt 0; then
        echo -n "${DAYS}d"
    fi
    if test $HOURS -gt 0; then
        echo -n "${HOURS}h"
    fi
    if test $MINS -gt 0; then
        echo -n "${MINS}m"
    fi
    if test $SECS -gt 0; then
        echo -n "${SECS}s"
    fi
}

# To be invoked just before displaying prompt
function __refreshLastCmdDuration {
    # Update current timestamp
    local CURRENT_TIME=$(date +%s)

    # Reckon duration only if we get a start time
    if test -n "${EXEC_START_TIME}"; then
        declare -il DURATION
        DURATION=$(( ${CURRENT_TIME} - ${EXEC_START_TIME} ))
        
        # Update global env
        LAST_EXEC_TIME=${DURATION}
        LAST_EXEC_TIME_STR="$(__prettyPrintDuration $LAST_EXEC_TIME)"
    fi
}

# To be hooked for execution before every command
function __rememberExecStart {
    # Handle completion and prompt hooks
    if test -n "$COMP_LINE" -o "$BASH_COMMAND" == "$PROMPT_COMMAND"; then
        # Start time is set?
        if test -n "$EXEC_START_TIME"; then
            # We're just before displaying the prompt: reckon duration
            __refreshLastCmdDuration
            unset EXEC_START_TIME
        fi
        return
    fi

    # Remember current time if we're about to run a command
    if test -n "$BASH_COMMAND"; then
        EXEC_START_TIME=$(date +%s)
    fi
}

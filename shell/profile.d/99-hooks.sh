# Setup hooks for prompt and pre-command functions

# Hook function to reckon PS1 every time
PROMPT_COMMAND=__updateMyPrompt

# To be hooked before each command execution
trap __rememberExecStart DEBUG

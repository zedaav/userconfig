# Just reuse skel one and always force color prompt
force_color_prompt=yes
source /etc/skel/.bashrc

# Root path for user config
USER_CONFIG_ROOT="$(dirname "$(dirname "$(dirname "$(readlink -f "$BASH_SOURCE")")")")"

# Load other files
for i in $USER_CONFIG_ROOT/shell/profile.d/*.sh; do
    source $i
done

# Load local files
if test -d "$HOME/.local/profile.d"; then
    for i in $HOME/.local/profile.d/*.sh; do
        source $i
    done
fi

# Are we loaded through .profile?
if test -z "$__profile_loaded" -a -f "$HOME/.profile"; then
    # No; only go through it
    source "$HOME/.profile"
else
    # Just reuse skel one and always force color prompt
    force_color_prompt=yes
    source /etc/skel/.bashrc
fi

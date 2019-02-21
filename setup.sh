#!/bin/bash
set -e

# Get root folder from current script
ROOTSCRIPT="$(readlink -f "$0")"
ROOTDIR="$(dirname "$ROOTSCRIPT")"
SHELLSCRIPTS="${ROOTDIR}/shell"

# Shell: loop on provided files
for SCRIPT_FILE in $(cd ${SHELLSCRIPTS}; find -type f | sed -e 's|./||g'); do
    # Backup files if they exist
    if test -f "${HOME}/${SCRIPT_FILE}" -a ! -L "${HOME}/${SCRIPT_FILE}"; then
        echo "Backuping ${HOME}/${SCRIPT_FILE} to ${HOME}/${SCRIPT_FILE}.save"
        mv "${HOME}/${SCRIPT_FILE}" "${HOME}/${SCRIPT_FILE}.save"
    fi

    # Then link the ones from this repo
    rm -f "${HOME}/${SCRIPT_FILE}"
    echo "Linking ${SHELLSCRIPTS}/${SCRIPT_FILE}"
    ln -nfsr "${SHELLSCRIPTS}/${SCRIPT_FILE}" "${HOME}/${SCRIPT_FILE}"
done

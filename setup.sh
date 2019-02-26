#!/bin/bash
set -e

# Get root folder from current script
ROOTSCRIPT="$(readlink -f "$0")"
ROOTDIR="$(dirname "$ROOTSCRIPT")"

# Update settings function
function __updateSettings {
    # Settings folder to browse
    local SETTINGS_FOLDER="$1"
    shift

    # Target folder to update
    local TARGET_FOLDER="$1"
    shift

    # Perform settings links only if target folder exists
    if test -d "${TARGET_FOLDER}"; then
        # Loop on provided files
        for SETTINGS_FILE in $(cd ${SETTINGS_FOLDER}; find -type f | sed -e 's|./||g'); do
            # Backup files if they exist
            if test -f "${TARGET_FOLDER}/${SETTINGS_FILE}" -a ! -L "${TARGET_FOLDER}/${SETTINGS_FILE}"; then
                echo "Backuping ${TARGET_FOLDER}/${SETTINGS_FILE} to ${TARGET_FOLDER}/${SETTINGS_FILE}.save"
                mv "${TARGET_FOLDER}/${SETTINGS_FILE}" "${TARGET_FOLDER}/${SETTINGS_FILE}.save"
            fi

            # Then link the ones from this repo
            rm -f "${TARGET_FOLDER}/${SETTINGS_FILE}"
            echo "Linking ${SETTINGS_FOLDER}/${SETTINGS_FILE} in ${TARGET_FOLDER}"
            ln -nfsr "${SETTINGS_FOLDER}/${SETTINGS_FILE}" "${TARGET_FOLDER}/${SETTINGS_FILE}"
        done
    fi
}

# Shell profiles
__updateSettings "${ROOTDIR}/shell/home" "${HOME}"

# VS Code settings
__updateSettings "${ROOTDIR}/vscode" "${HOME}/.config/Code/User"

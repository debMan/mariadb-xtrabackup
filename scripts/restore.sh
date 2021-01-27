#!/usr/bin/env bash

parent_dir="${PWD}/backups/${RESTORE_DIR}"

if [ -z "${RESTORE_DIR}" ]; then
    echo "please specify RESTORE_DIR"
else
    echo "start extract"
    /app/extract_xtrabackup.sh  "${parent_dir}"/*.xbstream

    echo "start prepare"
    /app/prepare_xtrabackup.sh
fi

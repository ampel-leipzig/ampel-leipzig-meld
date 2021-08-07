#!/bin/bash

BIND_PATH="/etc/passwd,/etc/group,/var/run"

# on HPC?
MODULEPATH=/usr/share/Modules/init/bash
if [ -f "${MODULEPATH}" ] ; then
    SINGULARITYVER=3.4.2
    . "${MODULEPATH}"
    module load singularity/${SINGULARITYVER} slurm
    SINGULARITYPATH=/opt/singularity-${SINGULARITYVER}/bin/singularity
    BIND_PATH="${BIND_PATH},/etc/slurm"
else # local
    BIND_PATH="${BIND_PATH},${SSH_AUTH_SOCK}"
    SINGULARITYPATH=/usr/bin/singularity
fi

SINGULARITYENV_LOCPATH=/lib/locale/2.31/ \
    SINGULARITYENV_RETICULATE_PYTHON=/bin/python3.8 \
    SINGULARITYENV_PYCOX_DATA_DIR=${TMPDIR:-/tmp} \
    SINGULARITYENV_TAR_MAKE_REPORTER="timestamp" \
    SINGULARITYENV_TZ="UTC" \
    SINGULARITY_BIND="${BIND_PATH}" \
    ${SINGULARITYPATH} run container/ampel-leipzig-meld.squashfs "${@}"
exit 0

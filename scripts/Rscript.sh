#!/bin/bash

BIND_PATH="/etc/passwd,/etc/group,/var/run"

# on HPC?
MODULESPATH="/usr/share/[Mm]odules/init/bash"
if [ -f ${MODULESPATH} ] ; then
    . ${MODULESPATH}
    SINGULARITYVER=3.4.2
    module load singularity/${SINGULARITYVER}
    SINGULARITYPATH=/opt/singularity-${SINGULARITYVER}/bin/singularity
    BIND_PATH="${BIND_PATH},/etc/slurm/slurm.conf"
    TMPDIR=~/tmp
else # local
    BIND_PATH="${BIND_PATH},${SSH_AUTH_SOCK}"
    SINGULARITYPATH=/usr/bin/singularity
fi

SINGULARITYENV_LOCPATH=/lib/locale/2.31/ \
    SINGULARITYENV_RETICULATE_PYTHON=/bin/python3.8 \
    SINGULARITYENV_PYCOX_DATA_DIR=${TMPDIR:-/tmp} \
    SINGULARITY_TMPDIR=${TMPDIR:-/tmp} \
    SINGULARITYENV_TMPDIR=${TMPDIR:-/tmp} \
    SINGULARITYENV_TAR_MAKE_REPORTER="timestamp" \
    SINGULARITYENV_TZ="UTC" \
    SINGULARITY_BIND="${BIND_PATH}" \
    ${SINGULARITYPATH} run container/ampel-leipzig-meld.squashfs \
    "--vanilla ${@}"
exit 0

#!/bin/bash

BIND_PATH="/etc/passwd,/etc/group,/var/run"

# on HPC?
MODULESPATH="/usr/share/[Mm]odules/init/bash"
if [ -f ${MODULESPATH} ] ; then
    . ${MODULESPATH}
    SINGULARITYVER=3.8.2
    if [ ! -d "/opt/singularity-${SINGULARITYVER}" ] ; then
        SINGULARITYVER=3.4.2
    fi
    SINGULARITYPATH=/opt/singularity-${SINGULARITYVER}/bin/singularity
    module load singularity/${SINGULARITYVER}
    SINGULARITYPATH=/opt/singularity-${SINGULARITYVER}/bin/singularity
    BIND_PATH="${BIND_PATH},/var/run/slurm/conf/slurm.conf:/etc/slurm/slurm.conf"
    TMPDIR=~/tmp
else # local
    BIND_PATH="${BIND_PATH},${SSH_AUTH_SOCK}"
    SINGULARITYPATH=/usr/bin/singularity
fi

SINGULARITY_TMPDIR=${TMPDIR:-/tmp}
    SINGULARITY_BIND="${BIND_PATH}" \
    ${SINGULARITYPATH} run container/ampel-leipzig-meld.squashfs \
    "--no-save --no-restore --no-site-file --no-init-file ${@}"
    # don't use --vanilla to read .Renviron to set TMP and PYTHONDIR which
    # is not possible via SINGULARITY_TMPDIR/SINGULARITYENV_*
    # in the current singularity 3.8.2 on the HPC
    #"--vanilla ${@}"
exit 0

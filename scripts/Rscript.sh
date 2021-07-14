#!/bin/bash

# should run on a HPC

. /usr/share/Modules/init/bash
module load singularity slurm

BIND_PATH="/etc/group,/etc/passwd,/etc/slurm,/var/run"

SINGULARITYENV_LOCPATH=/lib/locale/2.31/ \
    SINGULARITYENV_TAR_MAKE_REPORTER="timestamp" \
    SINGULARITYENV_TZ="UTC" \
    SINGULARITY_BIND="${BIND_PATH}" \
    singularity run container/ampel-leipzig-meld.squashfs "$@"

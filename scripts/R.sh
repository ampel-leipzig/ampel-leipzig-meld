#!/bin/bash

# The cli package has an internal function cli:::win10_build
# that uses utils::sessionInfo()$running, which returns osVersion.
# osVersion is NULL in the container and `tar_make` will throw an error
# because cli::win10_build fails because grepl("^Win...", osVersion) won't work.
# This overwrites win10_build and just returns 0L
# https://github.com/r-lib/cli/issues/273
# We could also use
# SINGULARITYENV_R_CLI_NUM_COLORS=1 \
WORKAROUND='assignInNamespace("win10_build", function()0L, ns = "cli")'

REXPR=${1:-"${WORKAROUND}; targets::tar_make(); workflowr::wflow_build(rprojroot::find_rstudio_root_file('analysis', 'pipeline.Rmd'), view = FALSE)"}
PREPEND_PATH=""
BIND_PATH="/var/run"

## on an HPC
if ! [[ ${HOSTNAME} =~ (x1|t400) ]] ; then
    module load singularity slurm
    PREPEND_PATH=$(IFS=:; for i in ${PATH}; do if [[ $i =~ (slurm|munge|singularity) ]] ; then echo -n "${i}:"; fi; done;)
    PREPEND_PATH=${PREPEND_PATH%:}
    BIND_PATH="/etc/slurm/,/usr/lib64/libmunge.so.2,${BIND_PATH},$(echo ${PREPEND_PATH} | sed 's#:#\n#g; s#\(bin\|lib\)\/\?##g' | uniq | sed ':a;N;$!ba;s#\n#,#g')"
fi

# cli:::win10_build fails on guix generated containers, see
#
SINGULARITYENV_LOCPATH=/lib/locale/2.31/ \
    SINGULARITYENV_TZ="UTC" \
    SINGULARITYENV_PREPEND_PATH="${PREPEND_PATH}" \
    SINGULARITY_BIND="${BIND_PATH}" \
    singularity run container/ampel-leipzig-meld.sif \
    --vanilla --silent -e "${REXPR}"

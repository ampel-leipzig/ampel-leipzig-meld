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

REXPR=${1:-"${WORKAROUND}; targets::tar_make_future(workers = 4L); workflowr::wflow_build(rprojroot::find_rstudio_root_file('analysis', 'pipeline.Rmd'), view = FALSE)"}
BIND_PATH="/etc/passwd,/etc/group,/var/run,${SSH_AUTH_SOCK}"

SINGULARITYENV_LOCPATH=/lib/locale/2.31/ \
    SINGULARITYENV_TAR_MAKE_REPORTER="timestamp" \
    SINGULARITYENV_TZ="UTC" \
    SINGULARITY_BIND="${BIND_PATH}" \
    singularity exec container/ampel-leipzig-meld.squashfs \
    R --vanilla --silent -e "${REXPR}"

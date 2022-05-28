GUIX=/usr/local/bin/guix
GUIXCOMMIT=83f444d

.PHONEY: clean clean-all clean-container clean-reports clean-targets \
	container hpc local-guix run sync

run: container
	RUNLOCAL=1 R_CLI_NUM_COLORS=256 scripts/Rscript.sh code/make.R

hpc: sync
	R_CLI_NUM_COLORS=256 scripts/Rscript.sh code/make.R

container: container/ampel-leipzig-meld.squashfs

container/ampel-leipzig-meld.squashfs: guix/manifest.scm \
	guix/channels.scm \
	guix/channel/ampel/packages/cran.scm \
	guix/channel/ampel/packages/parallel.scm \
	guix/channel/ampel/packages/python-science.scm
	mkdir -p container
	cp $$($(GUIX) time-machine --commit=$(GUIXCOMMIT) -- pack \
	--relocatable --relocatable \
	--format=squashfs \
	--entry-point=bin/Rscript \
	--symlink=/bin=bin \
	--symlink=/lib=lib \
	--symlink=/share=share \
	--manifest=guix/manifest.scm \
	--load-path=guix/channel \
	--save-provenance) $@
	chmod 644 $@

sync: container scripts/Rscript.sh scripts/slurm_batchtools.tmpl
	rsync \
    --verbose \
    --modify-window=1 \
    --recursive \
    --links \
    --delete \
    .Renviron analysis code container logs scripts brain:~/

local-guix:
	guix package --manifest=guix/manifest.scm --load-path=guix/channel --profile="$(GUIX_EXTRA_PROFILES)"/ampel/ampel

clean: clean-targets

clean-all: clean-container clean

clean-container:
	@rm -rf container

clean-reports:
	@RUNLOCAL=1 ./scripts/Rscript.sh -e \
		'targets::tar_invalidate(starts_with("reports_")); targets::tar_invalidate(starts_with("site_"))'
	@rm -rf docs/*

clean-targets:
	@rm -rf _targets

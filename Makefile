GUIX=/usr/local/bin/guix
GUIXCOMMIT=f12a35c

.PHONEY: clean clean-all clean-container clean-reports clean-targets \
	container hpc run sync

run: container
	RUNLOCAL=1 scripts/Rscript.sh code/make.R

hpc: sync
	scripts/Rscript.sh code/make.R

container: container/ampel-leipzig-meld.squashfs

container/ampel-leipzig-meld.squashfs: guix/manifest.scm \
	guix/channels.scm \
	guix/channel/ampel/packages/rpackages.scm
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
    analysis code container logs scripts brain:~/

clean: clean-targets

clean-all: clean-container clean

clean-container:
	@rm -rf container

clean-reports:
	@RUNLOCAL=1 ./scripts/Rscript.sh -e \
		'targets::tar_invalidate(starts_with("reports_"))'
	@rm -rf docs/*

clean-targets:
	@rm -rf _targets

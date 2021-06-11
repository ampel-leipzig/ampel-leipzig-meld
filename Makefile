GUIX=/usr/local/bin/guix
GUIXCOMMIT=c78d6c6

.PHONEY: clean clean-container container run

run: container/ampel-leipzig-meld.sif
	./scripts/R.sh

container: container/ampel-leipzig-meld.sif

container/ampel-leipzig-meld.sif: guix/manifest.scm \
	guix/channels.scm \
	guix/channel/ampel/packages/rpackages.scm
	mkdir -p container
	cp `$(GUIX) time-machine --commit=$(GUIXCOMMIT) -- pack \
    	--relocatable --relocatable \
    	--format=squashfs \
    	--entry-point=bin/R \
		--symlink=/bin=bin \
        --symlink=/lib=lib \
        --symlink=/share=share \
    	--manifest=guix/manifest.scm \
    	--load-path=guix/channel \
		--save-provenance` $@

clean: clean-container

clean-container:
	@rm -rf container

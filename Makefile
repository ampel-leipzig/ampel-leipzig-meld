GUIX=/usr/local/bin/guix
GUIXCOMMIT=c78d6c6

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
		--save-provenance
	install -D -m 664 "$(shell ls -c /gnu/store/*.squashfs | head -n 1)" $@

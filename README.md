# ampel-leipzig-meld

## Directories

- `analysis/` contains the R markdown files used to generated the reports and the website.
- `code/` contains the R code.
- `container/` contains the *singularity* container.
- `docs/` contains the generated HTML files.
- `guix/` contains the manifest and channel description to create the container.
- `scripts/` contains the container start scripts.

## Bootstrap

[GUIX](http://guix.gnu.org/) and [Singularity](https://sylabs.io/singularity/)
have to be installed on the system you want to use to create the container.

```bash
# on a Debian GNU/Linux
sudo apt install singularity-container
cd /tmp && \
    wget https://git.savannah.gnu.org/cgit/guix.git/plain/etc/guix-install.sh && \
    chmod +x guix-install.sh && \
    sudo ./guix-install.sh && guix pull
```

This is a [workflowr](https://github.com/jdblischak/workflowr) project.
After creating the singularity container it was created by:

(You can skip this if you downloaded/clone this repository.)

```bash
singularity exec container/ampel-leipzig-meld.sif \
    R -e 'library("workflowr"); wflow_start(".", existing = TRUE)'
```

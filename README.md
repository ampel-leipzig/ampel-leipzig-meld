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
sudo apt install singularity-container make rsync

# newer Debian versions may support installation of guix via apt
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

## HPC

### Requirements

- Linux cluster
- `slurm` (version 21.08.x)
- `singularity` (tested with version 3.4.2)
- `ssh` access.

### Adoption

The login node in `_targets.R` (here `brain`) has to match an
entry in `~/.ssh_config` or be configured manually.

```r
login <- future::tweak(
    future::remote,
    workers = "brain",
```

The partitions/ncpu/mcpu settings have to be changed in the `_target.R`.

```r
slurm <- future::tweak(
    future.batchtools::batchtools_slurm,
    template = "scripts/slurm_batchtools.tmpl",
    workers = 16L,
    resources = list(
        partition = "batch,compute,snowball",
        ncpu = 64, # 72, 64
        mcpu = 2L * 1024L, # 2L
        walltime = 24L * 60L * 60L # seconds
    )
)
```

The `scripts/Rscript.sh` has to be adopted to the cluster's module system and
singularity version. Maybe the `scripts/slurm_batchtools.tmpl` has to be
modified as well.

# ampel-leipzig-meld


## Bootstrap

[GUIX](http://guix.gnu.org/) has to be installed on the system you want to use
to create the container.

This is a [workflowr](https://github.com/jdblischak/workflowr) project.
After creating the singularity container it was created by:

(You can skip this if you downloaded/clone this repository.)

```bash
singularity exec container/ampel-leipzig-meld.sif \
    R -e 'library("workflowr"); wflow_start(".", existing = TRUE)'
```


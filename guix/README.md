# Build singularity container from guix

`relocatable` is applied twice in case *user namespace support* is missing in
the kernel of the target system. If applied once it requires
*user namespace support* if applied twice it tries some fallback solutions.
```
guix pack \
    --relocatable --relocatable \
    --entry-point=bin/R \
    --format=squashfs \
    --symlink=/bin=bin \
    --symlink=/lib=lib \
    --symlink=/share=share \
    --manifest=manifest.scm \
    --load-path=channel
```

# Importing non-existing packages

```
guix import cran --recursive PACKAGE

# from github
guix import cran --recursive --archive=git URL
```

# Save channels

```
guix describe --format=channels > channels.scm
```

# Rebuild

```
guix time-machine --channels channels.scm
```

# Upgrade Packages

- update COMMIT in `Makefile`, and `guix/manifest.scm`, and `guix/channels.scm`

```
guix refresh --load-path=guix/channel --update $(grep define-public guix/channel/ampel/packages/*.scm | cut -f 2 -d ' ' | grep -v slurm)
```

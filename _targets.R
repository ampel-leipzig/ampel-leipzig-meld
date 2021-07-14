library("targets")
library("tarchetypes")

library("future")
library("future.batchtools")
library("future.callr")

#Sys.setenv(RUNLOCAL = 1)
Sys.setenv(DEBUGME = "batchtools")
lgr::get_logger("mlr3")$set_threshold("info")
lgr::get_logger("bbotk")$set_threshold("info")

login <- future::tweak(
    future::remote,
    workers = "brain",
    rscript = "scripts/Rscript.sh",
    rshopts = if (nchar(Sys.getenv("DEBUGME"))) "-v" else ""
)

slurm <- future::tweak(
    future.batchtools::batchtools_slurm,
    template = "scripts/slurm_batchtools.tmpl",
    workers = 4L,
    resources = list(
        logfile = "logs/job%s.log",
        partition = "batch,compute,pinky,snowball",
        ncpu = 8L,
        mcpu = 16L * 1024L,
        walltime = 4L * 60L * 60L
    )
)

if (nchar(Sys.getenv("RUNLOCAL"))) {
    future::plan(callr, workers = 3)
} else {
    future::plan(list(login, slurm, future::tweak(callr, workers = 8L)))
}

source("code/01-data.R")
source("code/02-benchmarking.R")
source("code/03-reports.R")
source("code/99-site.R")

list(
   tg_data,
   tg_tasks,
   tg_benchmarks,
   tg_benchmark_results,
   tg_reports,
   tg_site
)

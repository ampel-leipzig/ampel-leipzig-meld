library("targets")
library("tarchetypes")

library("future")
library("future.batchtools")

library("lgr")

#Sys.setenv(RUNLOCAL = 1)
Sys.setenv(DEBUGME = "batchtools")
tf <- rprojroot::find_rstudio_root_file("logs", "lgr.log")
lgr$add_appender(AppenderFile$new(tf), name = "file")
lgr$set_threshold("all")
get_logger("mlr3")$set_threshold("all")
get_logger("bbotk")$set_threshold("all")
get_logger("mlr3")$add_appender(AppenderFile$new(tf), name = "file")
get_logger("bbotk")$add_appender(AppenderFile$new(tf), name = "file")

login <- future::tweak(
    future::cluster,
    workers = "brain",
    homogeneous = FALSE,
    rscript = "scripts/Rscript.sh",
    rshopts = if (nchar(Sys.getenv("DEBUGME"))) "-v" else ""
)

resources <- list(
    workers = 32L,
    partition = "snowball",
    ncpu = 36,
    mcpu = 1L * 1024L,
    walltime = 4L * 60L * 60L # seconds
)

slurm <- future::tweak(
    future.batchtools::batchtools_slurm,
    template = "scripts/slurm_batchtools.tmpl",
    workers = resources$workers,
    resources = resources
)

node <- future::tweak(
    multisession,
    workers = resources$ncpu
)

if (nchar(Sys.getenv("RUNLOCAL"))) {
    future::plan(list(
        future::tweak(multisession, workers = 2L),
        future::tweak(multicore, workers = 3L))
    )
} else {
    future::plan(list(login, slurm, node))
}

source("code/01-data.R")
source("code/02-mlr-tasks.R")
source("code/03-mlr-learners.R")
source("code/04-mlr-benchmarking.R")
source("code/08-tables.R")
source("code/09-reports.R")
source("code/99-site.R")

list(
   tg_data,
   tg_lrns,
   tg_tasks,
   tg_benchmarks,
   tg_benchmark_results,
   tg_tables,
   tg_reports,
   tg_site
)

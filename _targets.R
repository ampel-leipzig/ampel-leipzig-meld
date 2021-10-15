library("targets")
library("tarchetypes")

library("future")
library("future.batchtools")
library("future.callr")

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
    future::remote,
    workers = "brain",
    rscript = "scripts/Rscript.sh",
    rshopts = if (nchar(Sys.getenv("DEBUGME"))) "-v" else ""
)

slurm <- future::tweak(
    future.batchtools::batchtools_slurm,
    template = "scripts/slurm_batchtools.tmpl",
    workers = 16L,
    resources = list(
        partition = "batch,compute,snowball",
        ncpu = 64,
        mcpu = 2L * 1024L,
        walltime = 48L * 60L * 60L # seconds
    )
)

if (nchar(Sys.getenv("RUNLOCAL"))) {
    future::plan(callr, workers = 7L)
} else {
    future::plan(list(login, slurm, callr))
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

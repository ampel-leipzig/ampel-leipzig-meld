library("targets")
library("tarchetypes")

tar_option_set(packages = c(
    "ameld",
    "zlog"
))

source("code/01-data.R")
source("code/03-reports.R")
source("code/99-site.R")

list(
   tg_data,
   tg_reports,
   tg_site
)

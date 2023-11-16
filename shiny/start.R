#! /usr/bin/env Rscript

library(shiny)

app_path <- sprintf("%s/data/red_kgr/shiny/app.R", Sys.getenv("HOME"))
runApp(app_path)

## Load your packages, e.g. library(targets).
source("./packages.R")

## Load your R files
lapply(list.files("./R", full.names = TRUE), source)

## tar_plan supports drake-style targets and also tar_target()
tar_plan(
  
  ## Section: Input data files
  ##################################################
  
  # The red wine data file
  tar_file(red_wine_file,
           here::here("data", "winequality-red.csv")),
  
  # The white wine data file
  tar_file(white_wine_file,
           here::here("data", "winequality-white.csv")),

  
  ## Section: Reading in data
  ##################################################
  
  # Tibble of the red wine data
  tar_target(all_wine_data,
             clean_data(red_wine_file, white_wine_file)),
  
  # The full column names from the original data
  tar_target(long_variable_names,
             read_delim(red_wine_file, delim = ";") %>% 
               colnames() %>% 
               str_to_title() %>%
               str_replace("Ph","pH") %>% 
               append("Wine Type")),
  
  
  ## Section: Exploratory data analysis
  ##################################################
  
  # Summary tables of the data
  tar_target(eda_summary_tables,
             make_eda_summary_tables(all_wine_data)),

  
  ## Section: Writeup
  ##################################################
  tar_render(writeup, "doc/writeup.Rmd")

)

#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param red_wine_file
#' @param white_wine_file
#' @return
#' @author Jay Gillenwater
#' @export
clean_data <- function(red_wine_file, white_wine_file) {

  # Read in each of the files and combine them
  red_wine_data <- read_delim(red_wine_file, delim = ";") %>% 
    clean_names() %>% 
    mutate(wine_type = "red")
  
  white_wine_data <- read_delim(white_wine_file, delim = ";") %>% 
    clean_names() %>% 
    mutate(wine_type = "white")
  
  # Combine the data sets and convert quality and wine_type to factors
  all_wine_data <- bind_rows(red_wine_data, white_wine_data) %>% 
    mutate(quality = factor(sort(quality)), 
           wine_type = factor(sort(wine_type)))
  
  # Return the merged data
  return(all_wine_data)
}

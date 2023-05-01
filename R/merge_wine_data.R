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
merge_wine_data <- function(red_wine_file, white_wine_file) {

  # Read in the data from the white wine and the red wine and add
  # a "wine_type" column for 
  white_wine_data <- read_delim(white_wine_file, delim = ";") %>% 
    clean_names() %>% 
    select(-quality) %>% 
    mutate(wine_type = "white")
  
  red_wine_data <- read_delim(red_wine_file, delim = ";") %>% 
    clean_names() %>% 
    select(-quality) %>% 
    mutate(wine_type = "red")
  
  # Merge the two dataframes and add a wine type column
  all_wine_data <- bind_rows(white_wine_data, red_wine_data) %>% 
    mutate(wine_type = factor(wine_type))
  
  return(all_wine_data)

}

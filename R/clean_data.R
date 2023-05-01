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
clean_data <- function(white_wine_file) {

  white_wine_data <- read_delim(white_wine_file, delim = ";") %>% 
    clean_names()
  
  # Combine the data sets and convert quality and wine_type to factors
  all_wine_data <- white_wine_data %>% 
    mutate(quality = ordered(sort(quality)))
  
  # Return the merged data
  return(all_wine_data)
}

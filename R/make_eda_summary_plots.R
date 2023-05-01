#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param wine_data
make_eda_summary_plots <- function(wine_data) {

  # Pairs plot for all variables
  pairs_plot <- GGally::ggpairs(wine_data) + 
    theme(text = element_text(size = 10))
  
  # Barplot for response variable
  quality_counts <- wine_data %>% 
    count(quality)
  
  response_hist <- ggplot(quality_counts, aes(x = quality, y = n)) + 
    geom_bar(stat = "identity") + 
    theme_gdocs() + 
    labs(y = "Count", x = "Quality score")
  
  
  res <- list("pairs_plot" = pairs_plot,
              "response_dist" = response_hist)
  
  return(res)
}

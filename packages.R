
#Install the pacman package if it is not installed
if(!("pacman" %in% installed.packages()[, "Package"])){
  install.packages("pacman")
}

# Workflow organization
pacman::p_load(conflicted,
               dotenv,
               targets,
               tarchetypes,
               here)

# Data wrangling
pacman::p_load(dplyr,
               tidyr,
               readr,
               janitor,
               purrr,
               stringr,
               psych,
               skimr)

# Visualization
pacman::p_load(ggplot2,
               ggthemes,
               GGally)

# Modeling
pacman::p_load(rsample,
               yardstick,
               recipes,
               discrim,
               tune,
               finetune,
               bestNormalize,
               multilevelmod,
               workflows,
               workflowsets,
               dials,
               tidymodels)

# writeup
pacman::p_load(kableExtra,
               rmdformats,
               rmarkdown)

tidymodels_prefer()
conflicts_prefer(scales::alpha)


# ST537_final_project
Data and code for ST537 final project


## Overview
The code in this analysis is broken into two component. One component is a [targets](https://books.ropensci.org/targets/) workflow that does the initial data cleaning and final sumamry reports for the analysis. The second component is the machine learning itself. I have these two components separate for now because I was not sure how best to combine the tidymodels framework with targets yet. 

Because of this, the workflow will have to be run in stages in the current setup. 

1. **Prepare the input data**: Run `source("./packages.R")` and then `tar_make(red_white_compare)`. This will clean the input data tables so that it is ready for tidymodels.  
2. **Machine learning**: The main modeling script is in sandbox/workflow_table.R. Once packages are loaded, the script can be run with `source("./sandbox/workflow_table.R")`. This will run through a tidymodels workflow and produce a final table of models `race_results`
3. **Summaries**: The final steps of the targets workflow summaries output from the script in step 2. They can all be run with `tar_make()`.


### Directory components
The **_targets.R** script is the control script for the targets workflow. Input data can be found in the **data** directory and the machine learning script can be found in the **sandbox/workflow_table.R** script. Code for the steps in the targets workflow can be found in the **R** directory.

wine_data <- tar_read(red_white_compare)

# Split the data into training and test sets using stratified random sampling
# using quality scores to define the strata
wine_split <- initial_split(wine_data, prop = 0.8, strata = wine_type)
wine_train <- training(wine_split)
wine_test  <- testing(wine_split)

# No data transformations
base_recipe <- recipe(wine_type ~ ., data = wine_data) %>%
  prep(training = wine_train, retain = TRUE)

# PCA on the predictors
pca_recipe <- recipe(wine_type ~ ., data = wine_data) %>% 
  step_zv(all_numeric_predictors()) %>%
  step_orderNorm(all_numeric_predictors()) %>% 
  step_normalize(all_numeric_predictors()) %>%
  step_pca(all_predictors(), num_comp = tune())

# Normalization recipe
normalization_recipe <- recipe(wine_type ~ ., data = wine_data) %>% 
  step_zv(all_numeric_predictors()) %>%
  step_orderNorm(all_numeric_predictors()) %>% 
  step_normalize(all_numeric_predictors()) %>%
  prep(training = wine_train, retain = TRUE)

# 10 fold cv 
wine_cv <- vfold_cv(wine_train, strata = wine_type)

decision_tree_rpart_spec <-
  decision_tree(tree_depth = tune(), min_n = tune(), cost_complexity = tune()) %>%
  set_engine('rpart') %>%
  set_mode('classification')

discrim_linear_MASS_spec <-
  discrim_linear() %>%
  set_engine('MASS')

discrim_quad_MASS_spec <-
  discrim_quad() %>%
  set_engine('MASS')

logistic_reg_glmer_spec <-
  logistic_reg() %>%
  set_engine('glmer')

multinom_reg_nnet_spec <-
  multinom_reg(penalty = tune()) %>%
  set_engine('nnet')

mlp_nnet_spec <-
  mlp(hidden_units = tune(), penalty = tune(), epochs = tune()) %>%
  set_engine('nnet') %>%
  set_mode('classification')

naive_Bayes_klaR_spec <-
  naive_Bayes(smoothness = tune(), Laplace = tune()) %>%
  set_engine('klaR')

nearest_neighbor_kknn_spec <-
  nearest_neighbor(neighbors = tune(), weight_func = tune(), dist_power = tune()) %>%
  set_engine('kknn') %>%
  set_mode('classification')

svm_linear_kernlab_spec <-
  svm_linear(cost = tune(), margin = tune()) %>%
  set_engine('kernlab') %>%
  set_mode('classification')

svm_poly_kernlab_spec <-
  svm_poly(cost = tune(), degree = tune(), scale_factor = tune(), margin = tune()) %>%
  set_engine('kernlab') %>%
  set_mode('classification')

svm_rbf_kernlab_spec <-
  svm_rbf(cost = tune(), rbf_sigma = tune(), margin = tune()) %>%
  set_engine('kernlab') %>%
  set_mode('classification')

normalized_set <- workflow_set(
  preproc = list(pca = pca_recipe, 
                normalization = normalization_recipe),
  models = list(linear_discrim    = discrim_linear_MASS_spec,
                quadratic_discrim = discrim_quad_MASS_spec,
                knn = nearest_neighbor_kknn_spec,
                linear_svm = svm_linear_kernlab_spec)
)

no_preproc_workflow_set <- workflow_set(
  preproc = list(base = base_recipe),
  models = list(decision_tree = decision_tree_rpart_spec)
)


all_workflows <- bind_rows(normalized_set, no_preproc_workflow_set)

race_ctrl <- control_race(
  save_pred = TRUE,
  parallel_over = "everything",
  save_workflow = TRUE
)



race_results <-
  all_workflows %>%
  workflow_map(
    "tune_race_anova",
    seed = 1503,
    resamples = wine_cv,
    grid = 25,
    control = race_ctrl
  )



train_data <- juice(wine_recipe)
test_data <- bake(wine_recipe, wine_test)

wine_folds <- vfold_cv(wine_data, v = 10)


pca_workflow <- workflow() %>% 
  add_model(discrim_linear_MASS_spec) %>% 
  add_recipe(pca_recipe)

pca_param <- 
  pca_workflow %>% 
  extract_parameter_set_dials() %>% 
  update(
    num_comp = num_comp(c(0, 10))
  )

pca_tune <- pca_workflow %>% 
  tune_grid(wine_cv, grid = pca_param %>% grid_regular(levels = 10), metrics =  metric_set(roc_auc))

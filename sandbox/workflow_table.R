tar_load(wine_data)


wine_split <- initial_split(wine_data, prop = 0.8, strata = quality)
wine_train <- training(wine_split)
wine_test  <- testing(wine_split)

wine_recipe <- recipe(quality ~ ., data = wine_data) %>% 
  step_BoxCox(all_predictors()) %>%
  prep(training = wine_train, retain = TRUE)


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


train_data <- juice(wine_recipe)
test_data <- bake(wine_recipe, wine_test)

wine_folds <- vfold_cv(wine_data, v = 10)


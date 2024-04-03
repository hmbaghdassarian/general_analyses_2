suppressMessages({
    suppressWarnings({
        library(caret, quietly = TRUE)
        library(readxl, quietly = TRUE)
        library(dplyr, quietly = TRUE)
        library(textshape, quietly = TRUE)
        library(glmnet, quietly = TRUE)
        library(ggplot2, quietly = T)
        library(RColorBrewer, quietly = T)
        library(cowplot, quietly = T)
        library(tibble, quietly = T)
        library(reshape2, quietly = T)
        library(tidyr, quietly = T)
        library(RhpcBLASctl, quietly = T)
    })
})

source('functions.r')

n_cores = 20
RhpcBLASctl::blas_set_num_threads(round(n_cores/2)) # limit core usage

seed = 888
set.seed(seed)
data_path<-'/net/bmc-pub14/data/dallgglab/users/hmbaghda/cart_lembas' # '/nobackup/users/hmbaghda/cart_lembas'

n_cores = 16
alpha = 1 # 1 is lasso, 0 is ridge
subfolds = 5 #k-fold cross-validation
error.measure = 'mse'
threshold = 0.8 # selected 80% of the time
n_trials = 100

all_iter = n_trials/n_cores
single_iter = all_iter
if (n_trials %% n_cores != 0){
    single_iter = ceiling(all_iter)
}

for (i in 1:single_iter){
    print(i)
    if (i <= all_iter){
        n_trials_iter = n_cores
    }else{
        n_trials_iter = (1-(single_iter - all_iter))*n_cores
    }
    suppressWarnings({
        selected_features<-feature_select_iter(X = X, y = y, 
                                              options = list(n_trials = n_trials_iter, 
                                                             threshold = 0.001, # shows up atleast once, then apply threshold after combining across all
                                                             force_select = TRUE,
                                                             alpha = alpha, subfolds = subfolds, error.measure = error.measure),
                                               par = T, n.cores = n_cores,
                                              standardize = F)
    })
    saveRDS(selected_features, file.path(data_path, 'interim', paste0('single_cell_lasso_ICD_', i, '.rds'))) 
}

saved.files <- list.files(file.path(data_path, 'interim'))
selected_features.files <- saved.files[grepl("^single_cell_lasso_ICD_", list.files(file.path(data_path, 'interim')))]
selected_features<-lapply(selected_features.files, function(fn) readRDS(file.path(data_path, 'interim', fn)))

# Combine the lists by summing the integers for the same names
selected_features <- Reduce(function(x, y) {
  common_names <- intersect(names(x), names(y))
  for (name in common_names) {
    x[[name]] <- x[[name]] + y[[name]]
  }
  unique_names <- setdiff(names(y), names(x))
  for (name in unique_names) {
    x[[name]] <- y[[name]]
  }
  x
}, selected_features)
selected_features <- Filter(function(x) x >= threshold*n_trials, selected_features) # threshold filter across all iterations

#### Preamble ####
# Purpose: create and store the Bayesian multi-linear model for this paper
# Author: Junbo Li
# Date: 12 NOV 2024
# Contact: junb.li@mail.utoronto.ca
# License: MIT
# Pre-requisites: Cleaned data in data folder
# Any other information needed? None


#### Workspace setup ####
library(tidyverse)
library(rstanarm)
library(arrow)

#### Read data ####
analysis_data <- read_parquet("data/02-analysis_data/analysis_data.parquet")

# Fit the model using stan_glm with custom priors for scaled predictors
first_model <- stan_glm(
  formula = Mortality ~ Food + Vacinne + Health_expense,
  data = analysis_data,
  family = gaussian(),
  prior = normal(location = c(0, 0, 0), scale = c(2.5, 2.5, 2.5), autoscale = FALSE),
  prior_intercept = normal(location = 2.5, scale = 1, autoscale = TRUE),
  prior_aux = exponential(rate = 1, autoscale = TRUE),
  seed = 853
)

#### Save model ####
saveRDS(
  first_model,
  file = "models/Mortality_Model.rds"
)

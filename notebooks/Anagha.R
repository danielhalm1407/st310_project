library(dplyr)
library(caret)
library(glmnet)

# Load data
heart <- read.csv("heart.csv")
head(heart)

# Recoding sex

heart <- heart %>%
  mutate(sex_factor = recode(sex,
                             "0" = "Female",
                             "1" = "Male"))

# Quantitative variables

heart_Correlations <- heart %>%
  select(age, thalach, ca, oldpeak, trestbps, chol, target) %>%
  cor() %>%
  as.data.frame() %>%
  select(target) %>%
  arrange(desc(abs(target)))
heart_Correlations # most highly correlated is oldpeak

# Categorical variables

glm_categoricals <- glm(target ~ ., data = heart %>% select(c(sex_factor, cp, fbs, restecg, exang, slope, thal), target), family = binomial)
sort(summary(glm_model)$coefficients[,4]) # most significant is cp

## Task 1: Interpretable model - taking the most highly correlated numerical predictor and the most significant categorical predictor

glm1 <- glm(target ~ cp + oldpeak, data = heart)
summary(glm1)

## Task 4: For loop to see which two predictor give best validation or cross validation missclassification rate

heart$target <- as.factor(heart$target) # recoding target to be categorical

predictors <- c("age", "thalach", "ca", "oldpeak", "trestbps", "chol",
                "cp", "slope", "thal", "sex_factor", "exang", "restecg", "fbs") 

glm_full <- glm(target ~ ., data = heart %>% select(all_of(predictors), target), family = "binomial")
summary(glm_full) # logistic model fit on all predictors

# use lasso to select predictors
x <- model.matrix(target ~ ., data = heart %>% select(all_of(predictors), target))[, -1]
y <- heart$target
lasso_model <- cv.glmnet(x, y, family = "binomial", alpha = 1)
best_lambda <- lasso_model$lambda.min
lasso_coeffs <- coef(lasso_model, s = best_lambda) 

selected_predictors <- rownames(lasso_coeffs)[lasso_coeffs[, 1] != 0][-1] # checking if predictors exist in dataset

selected_predictors <- intersect(selected_predictors, colnames(heart)) 
selected_predictors # predictors ranked pre for loop

predictor_pairs <- combn(selected_predictors, 2, simplify = FALSE) # all predictor combinations

results <- data.frame(Predictor1 = character(),
                      Predictor2 = character(),
                      MisclassificationRate = numeric()) # predictor combos stored

cv_control <- trainControl(method = "cv", number = 10) # cross validation set up

for (pair in predictor_pairs)  { #for loop to find 2 most important predictors
  
  pair <- unlist(pair)
  
  selected_data <- heart %>% select(all_of(pair), target) # subset to ensure only looking at predictor pair and target
  
# cross validation of logistic model
  model <- tryCatch(
    {
      train(target ~ ., data = selected_data, 
            method = "glm", 
            family = "binomial",
            trControl = cv_control)
    },
    error = function(e) {
      message("Error in model training for predictors: ", paste(pair, collapse = ", "))
      return(NULL)
    }
  )
  
  if (!is.null(model) && !is.null(model$results$Accuracy)) { # checking if model trained correctly
    accuracy <- max(model$results$Accuracy, na.rm = TRUE)
  } else {
    accuracy <- NA  # for failed models
  }
  
  misclassification_rate <- 1 - accuracy # misclassification calculated
  
  results <- rbind(results, 
                   data.frame(Predictor1 = pair[1], 
                              Predictor2 = pair[2], 
                              MisclassificationRate = misclassification_rate)) # store results
}

best_pairs <- results[order(results$MisclassificationRate, na.last = NA), ] 

head(best_pairs) # test_bps and cp has the lowest misclassification rate


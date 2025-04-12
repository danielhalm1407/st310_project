library(tidyverse)
library(tidymodels)
library(pROC)

Heart <- read.csv(file.choose())

design_matrix <- function(training) {
	training %>%
		select(-c(all_of("target"))) %>%
		mutate(intercept = 1, .before = 1) %>%
		mutate_at(vars(-intercept), scale) %>%
		as.matrix
}

logistic_func <- function(logits) {
	1/(1 + exp(-logits))
}

logistic_loss <- function(betas, X, y) {
	y_hats <- logistic_func(X %*% betas)
	-sum(y * log(y_hats) + (1 - y) * log(1 - y_hats))
}

gradients <- function(betas, X, y) {
	y_hats <- logistic_func(X %*% betas)
	t(X) %*% (y_hats - y)
}

simulate_data <- function(n_observations = 5000, predictor_names) {
	set.seed(1)

	n_predictors <- length(predictor_names)

	raw_data <- matrix(
		runif(n_observations * n_predictors),
		ncol = n_predictors)
	true_coefficients <- runif(n_predictors + 1)

	X_simulated <- cbind(
		rep(1, n_observations),
		raw_data)
	y_simulated <- rbinom(
		n_observations,
		1,
		logistic_func(X_simulated %*% true_coefficients))

	simulated_dataset <- cbind(X_simulated[,-1], target = y_simulated) %>% as.data.frame
	colnames(simulated_dataset) <- c(predictor_names, "target")

	set.seed(NULL)

	list(
		training = simulated_dataset,
		true_coefficients = true_coefficients
	)
}

update_step_size <- function(iteration, betas, gradients) {
	betas_delta <- betas[iteration - 1,] - betas[iteration - 2,]
	gradients_delta <- gradients[iteration - 1,] - gradients[iteration - 2,]

	# return the step size as defined by the Barzilai-Borwein method formula
	# result <- ( t(betas_delta) %*% gradients_delta ) / ( t(gradients_delta) %*% gradients_delta )
	# print(iteration)
	# result
	# (betas_delta %*% gradients_delta) / (gradients_delta %*% gradients_delta)
	sum(betas_delta * betas_delta) / sum(betas_delta * gradients_delta)
}

gradient_descent <- function(
		training,
		predictor_names,
		learning_rate = 1e-6,
		tolerance = 0.0001,
		max_iterations = 10000,
		is_simulated = FALSE) {
	if(!is_simulated) {
		X_training <- design_matrix(training)
	} else {
		X_training <- training %>%
			select(-c(all_of("target"))) %>%
			mutate(intercept = 1, .before = 1) %>%
			as.matrix
	}
	y_training <- training$target

	initial_betas <- runif(ncol(X_training))
	losses <- numeric(max_iterations)
	step_sizes <- numeric(max_iterations)

	# each row is an iteration of updated betas
	betas <- matrix(NA, nrow = max_iterations, ncol = ncol(X_training))
	gradients <- matrix(NA, nrow = max_iterations, ncol = ncol(X_training))

	betas[1,] <- initial_betas
	gradients[1,] <- gradients(betas[1,], X_training, y_training)
	step_sizes[1] <- learning_rate
	losses[1] <- logistic_loss(betas[1,], X_training, y_training)

	# update the betas once manually to kickstart descent algorithm
	betas[2,] <- betas[1,] - step_sizes[1] * gradients[1,]
	gradients[2,] <- gradients(betas[2,], X_training, y_training)
	step_sizes[2] <- learning_rate
	losses[2] <- logistic_loss(betas[2,], X_training, y_training)

	for(iteration in 3:max_iterations) {
		previous_beta <- betas[iteration - 1,]
		previous_gradient <- gradients[iteration - 1,]
		previous_step_size <- step_sizes[iteration - 1]

		step_sizes[iteration] <- update_step_size(iteration, betas, gradients)
		betas[iteration,] <- previous_beta - step_sizes[iteration] * previous_gradient
		gradients[iteration,] <- gradients(betas[iteration,], X_training, y_training)
		losses[iteration] <- logistic_loss(betas[iteration,], X_training, y_training)

		if (sqrt(sum((step_sizes[iteration] * gradients[iteration,])^2)) < tolerance) {
			betas <- betas[1:iteration,]
			gradients <- gradients[1:iteration,]
			losses <- losses[1:iteration]
			step_sizes <- step_sizes[1:iteration]
			break
		}
	}

	list(coefficients = betas,
			 gradients = gradients,
			 losses = losses,
			 predictors = predictor_names)
}

predictor_names <- c("chol", "thalach", "cp")

data_subset <- Heart %>% select(all_of(predictor_names), "target")
Heart_split <- initial_split(data_subset, prop = 0.7)

training <- Heart_split %>% training()
testing <- Heart_split %>% testing()

r_model <- glm(
	target ~ .,
	family = binomial,
	data = training %>%
		mutate_at(vars(-target), scale))

log_model <- gradient_descent(
	training,
	predictor_names,
	learning_rate = 0.01,
	tolerance = 0.01,
	max_iterations = 10000,
	is_simulated = FALSE)

n_observations <- 5000
simulated_data <- simulate_data(n_observations, predictor_names)
naive_model <- gradient_descent(
	simulated_data$training,
	predictor_names,
	learning_rate = 1e-6,
	tolerance = 1e-3,
	max_iterations = 10000,
	is_simulated = TRUE)

compare_coefficients <- function(model, r_model) {
	final_iteration <- nrow(model$coefficients)
	predicted_coefficients <- matrix(model$coefficients[final_iteration,])
	r_coefficients <- matrix(r_model$coefficients)

	deltas <- r_coefficients - predicted_coefficients

	coefficients_comparison <- cbind(predicted_coefficients, r_coefficients, deltas)
	colnames(coefficients_comparison) <- c("Estimates", "R estimates", "Deltas")
	rownames(coefficients_comparison) <- c("(Intercept)", model$predictors)
	coefficients_comparison
}

plot_losses <- function(model, model_type = "normal") {
	n_iterations <- length(model$losses)
	min_loss <- min(model$losses)

	ggplot(data.frame(iteration = 1:n_iterations, loss = model$losses)) +
		geom_line(aes(x = iteration, y = loss), color = "blue", linewidth = 1) +
		geom_hline(yintercept = min_loss, linetype = "dotted", color = "gray", linewidth = 0.75) +
		annotate("text", x = n_iterations * 0.9, y = min_loss, label = paste("minimum loss:", round(min_loss, 2)), vjust = -0.5, color = "darkgray") +
		labs(title = paste("Losses of binary cross-entropy of", model_type, "model over iterations"),
				 subtitle = paste("Fitted on the predictor(s)", toString(model$predictors)),
				 caption = "Data from the 1988 UCI Heart Disease study") +
		theme_classic() +
		theme(legend.position = "none") +
		xlab("Iteration") +
		ylab("Loss")
}

plot_betas_predictors <- function(model, r_model, naive_model) {
	final_coefficients <- model$coefficients[nrow(model$coefficients),]
	r_coefficients <- r_model$coefficients
	naive_coefficients <- naive_model$coefficients[nrow(naive_model$coefficients),]

	predictors = c("(intercept)", model$predictors)
	models <- c("ours", "glm", "naive")

	to_plot <- data.frame(
		predictor = factor(predictors, levels=predictors),
		coefficient = c(final_coefficients, r_coefficients, naive_coefficients),
		model = factor(models, levels=models)
	)

	ggplot(to_plot, aes(x = predictor, y = coefficient, shape = model, color = model)) +
		geom_point(size = 3, stroke = 1.2) +
		labs(x = "Predictor", y = "Coefficient") +
		labs(title = "Comparing estimated coefficients against naive and glm models",
				 subtitle = paste("Fitted on the predictor(s)", toString(model$predictors)),
				 caption = "Data from the 1988 UCI Heart Disease study") +
		theme_minimal()
}
plot_betas <- function(model) {
	n_iterations <- nrow(model$coefficients)

	to_plot <- data.frame(
		iteration = c(1:n_iterations),
		coefficient = as.data.frame(model$coefficients)
	)
	colnames(to_plot) <- c("iteration", "intercept", model$predictors)

	to_plot <- to_plot %>%
		pivot_longer(cols = -iteration, names_to = "predictor", values_to = "coefficient")

	ggplot(to_plot, aes(x = iteration, y = coefficient, color = predictor)) +
		geom_point(size = 3, stroke = 1.2) +
		geom_line() +
		labs(x = "Iteration", y = "Coefficient") +
		labs(title = "Estimated model coefficients over iterations",
				 subtitle = paste("Fitted on the predictor(s)", toString(model$predictors)),
				 caption = "Data from the 1988 UCI Heart Disease study") +
		theme_minimal()
}

compare_coefficients(log_model, r_model)
plot_losses(log_model, model_type = "normal")

plot_betas_predictors(log_model, r_model, naive_model)
plot_betas(log_model)

compare_predictions <- function(training, testing, model, r_model, threshold = 0.5) {
	X_training <- design_matrix(training)
	X_testing <- design_matrix(testing)
	r_testing <- testing %>% mutate_at(vars(-target), scale)

	final_betas <- model$coefficients[nrow(model$coefficients),]

	predictions_training <- logistic_func(X_training %*% final_betas)
	predictions_testing <- logistic_func(X_testing %*% final_betas)

	training_classes <- ifelse(predictions_training >= threshold, 1, 0)
	testing_classes <- ifelse(predictions_testing >= threshold, 1, 0)

	r_predictions <- predict(r_model, newdata = r_testing, type = "response")
	r_classes <- ifelse(r_predictions >= threshold, 1, 0)

	list(
		training_accuracy = mean(training_classes == training$target),
		training_auc = auc(roc(training$target, as.vector(training_classes), quiet = TRUE)),
		testing_accuracy = mean(testing_classes == testing$target),
		testing_auc = auc(roc(testing$target, as.vector(testing_classes), quiet = TRUE)),
		r_accuracy = mean(r_classes == testing$target),
		r_auc = auc(roc(testing$target, as.vector(r_classes), quiet = TRUE))
	)
}
display_metrics <- function(metrics) {
	neat_metrics <- data.frame(
		training = c(metrics$training_accuracy, metrics$training_auc),
		testing = c(metrics$testing_accuracy, metrics$testing_auc),
		glm = c(metrics$r_accuracy, metrics$r_auc)
	)

	row.names(neat_metrics) <- c("accuracy", "AUC")

	neat_metrics
}

metrics <- compare_predictions(training, testing, log_model, r_model, threshold = 0.5)
display_metrics(metrics)

compare_naive_coefficients <- function(model, simulated_data) {
	final_iteration <- nrow(model$coefficients)
	predicted_coefficients <- matrix(model$coefficients[final_iteration,])
	true_coefficients <- matrix(simulated_data$true_coefficients)

	deltas <- true_coefficients - predicted_coefficients

	coefficients_comparison <- cbind(predicted_coefficients, true_coefficients, deltas)
	colnames(coefficients_comparison) <- c("Estimated betas", "True betas", "Differences")
	rownames(coefficients_comparison) <- c("(Intercept)", model$predictors)
	coefficients_comparison
}
naive_metrics <- function(model, training, testing) {
	predictions_training <- rep(1, nrow(training))
	predictions_testing <- rep(1, nrow(testing))

	training_classes <- ifelse(predictions_training >= 0.5, 1, 0)
	testing_classes <- ifelse(predictions_testing >= 0.5, 1, 0)

	metrics <- list(
		training_accuracy = mean(training_classes == training$target),
		training_auc = auc(roc(training$target, training_classes), quiet = TRUE),
		testing_accuracy = mean(testing_classes == testing$target),
		testing_auc = auc(roc(testing$target, testing_classes), quiet = TRUE)
	)

	neat_metrics <- data.frame(
		training = c(metrics$training_accuracy, metrics$training_auc),
		testing = c(metrics$testing_accuracy, metrics$testing_auc)
	)

	row.names(neat_metrics) <- c("accuracy", "AUC")

	neat_metrics
}

compare_naive_coefficients(naive_model, simulated_data)
plot_losses(naive_model, model_type = "naive")

naive_metrics(naive_model, training, testing)

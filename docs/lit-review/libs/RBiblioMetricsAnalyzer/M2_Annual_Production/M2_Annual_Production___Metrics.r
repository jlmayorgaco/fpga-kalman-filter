# Function to convert moving average list to a data frame
convert_to_df <- function(moving_average_list, type_label) {
  df <- data.frame(
    Year = moving_average_list[[1]][[1]],
    Articles = moving_average_list[[1]][[2]],
    Type = type_label
  )
  return(na.omit(df))
}

# Function to calculate metrics for a model
calculate_metrics <- function(model, data) {
  if (is.null(model)) return(list(rmse = NA, r_squared = NA))
  
  data$Year <- as.numeric(as.character(data$Year))
  predictions <- predict(model, newdata = data)
  residuals <- data$Articles - predictions
  rmse <- sqrt(mean(residuals^2))
  r_squared <- 1 - sum(residuals^2) / sum((data$Articles - mean(data$Articles))^2)
  
  list(rmse = rmse, r_squared = r_squared)
}

# Function to extract parameters from a model
extract_parameters <- function(model) {
  if (is.null(model)) return(NA)
  paste(names(coef(model)), "=", coef(model), collapse = ", ")
}

# Function to manually calculate AIC for nls models
manual_aic <- function(model) {
  if (is.null(model)) return(NA)
  
  rss <- sum(residuals(model)^2)
  n <- length(residuals(model))
  k <- length(coef(model))
  n * log(rss / n) + 2 * k
}

# Function to determine the best model based on a criterion
determine_best_model <- function(comparison_table, criterion = "AIC") {
  best_index <- which.min(comparison_table[[criterion]])
  comparison_table$Model_Name[best_index]
}

# Function to get the metrics comparison table
get_metrics_comparison_table <- function(models, data) {
  metrics <- lapply(models, calculate_metrics, data = data)
  aics <- sapply(models, manual_aic)
  
  comparison_table <- data.frame(
    Model_Name = names(models),
    Model_Object = I(models),
    AIC = aics,
    RMSE = sapply(metrics, `[[`, "rmse"),
    R_Squared = sapply(metrics, `[[`, "r_squared"),
    Parameters = sapply(models, extract_parameters),
    stringsAsFactors = FALSE
  )
  
  return(comparison_table)
}

# Function to get anomalies in the data
get_anomalies <- function(df, articles_col, year_col, model_name, model_params) {
  # Ensure the columns exist
  if (!(articles_col %in% names(df)) || !(year_col %in% names(df))) {
    stop("Specified columns do not exist in the dataframe.")
  }
  
  # Calculate residuals based on the model
  df$residuals <- residuals(lm(df[[articles_col]] ~ df[[year_col]], data = df)) # Example linear model
  
  # Define a threshold for anomalies
  threshold <- 2 * sd(df$residuals, na.rm = TRUE)  # Example threshold
  
  # Identify anomalies
  anomalies <- df %>%
    filter(abs(residuals) > threshold)
  
  # Return anomalies as a data frame
  return(anomalies)
}
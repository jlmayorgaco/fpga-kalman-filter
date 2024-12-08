library(dplyr)
library(rlang)
library(minpack.lm)

# Define growth model functions
linear_growth <- function(t, a, b) { a * t + b }
exponential_growth <- function(t, r, N0, t0) { N0 * exp(r * (t - t0)) }
logarithmic_growth <- function(t, a, b) { a * log(t) + b }
powerlaw_growth <- function(t, a, b) { a * t^b }
gompertz_growth <- function(t, N0, Nmax, k, t0, y0) {
  N <- y0 + N0 * exp(log(Nmax / N0) * exp(-k * (t - t0)))
  return(N)
}
gompertz_growth_derivative <- function(t, N0, Nmax, k, t0, y0) {
  # Explicit formula for the Gompertz growth model
  A <- log(Nmax / N0)
  B <- exp(-k * (t - t0))
  N <- y0 + N0 * exp(A * B)
  # Derivative of the Gompertz growth model
  dNdt <- -k * A * B * (N - y0)
  return(dNdt)
}
weibull_growth <- function(t, K, r, t0) { K * (1 - exp(-(t/t0)^r)) }
vonbertalanffy_growth <- function(t, Linf, k, t0) { Linf * (1 - exp(-k * (t - t0))) }
normal_growth <- function(t, mu, sigma, A) { A * exp(-0.5 * ((t - mu) / sigma)^2) }
logistic_growth <- function(t, K, r, t0) { K / (1 + exp(-r * (t - t0))) }

model_function_map <- list(
  Linear = linear_growth,
  Exponential = exponential_growth,
  Logarithmic = logarithmic_growth,
  Logistic = logistic_growth,
  Gompertz = gompertz_growth,
  GompertzDerivate = gompertz_growth_derivative,
  Weibull = weibull_growth,
  VonBertalanffy = vonbertalanffy_growth,
  Normal = normal_growth
)


# Function to fit models with error handling
fit_model <- function(formula, data, start, model_func_name) {
  tryCatch(
    {
      nlsLM(formula, data = data, start = start)
    },
    error = function(e) {
      message("Error fitting formula for model function: ", model_func_name)
      message("Error fitting model: ", e$message)
      NULL
    }
  )
}

# Generalized function to fit specific growth models
fit_specific_model <- function(model_func, start_params, data) {
  model_func_name <- deparse(substitute(model_func))
  years <- data$Year
  papers <- data$Articles
  formula <- as.formula(paste("papers ~", model_func_name, "(years,", paste(names(start_params), collapse = ", "), ")"))
  fit_model(formula, data, start = start_params, model_func_name = model_func_name)
}

get_regression_models <- function(x , y){

    annual_production <- data.frame(Year = x, Articles = y)
    annual_production$Year <- as.numeric(as.character(x))
    annual_production$Articles <- as.numeric(as.character(y))

    # Fit models
    linear_model <- lm(Articles ~ Year, data = annual_production)
    exponential_model <- fit_specific_model(exponential_growth, list(r = 0.0651, N0 = 2.87, t0 = 0.01), annual_production)
    logarithmic_model <- fit_specific_model(logarithmic_growth, list(a = 1, b = 1), annual_production)
    logistic_model <- fit_specific_model(logistic_growth, list(K = 150, r = 0.1, t0 = 2000), annual_production)
    gompertz_model <- fit_specific_model(gompertz_growth, list(N0 = 115, Nmax = 15.5, k = 0.1, t0 = 2000, y0 = 0.001), annual_production)
    gompertz_derivate_model <- fit_specific_model(GompertzDerivate, list(N0 = 115, Nmax = 15.5, k = 0.1, t0 = 2000, y0 = 0.001), annual_production)
    weibull_model <- fit_specific_model(weibull_growth, list(K = 150, r = 0.1, t0 = 2000), annual_production)
    vonbertalanffy_model <- fit_specific_model(vonbertalanffy_growth, list(Linf = 150, k = 0.1, t0 = 2000), annual_production)
    normal_model <- fit_specific_model(normal_growth, list(mu = mean(annual_production$Year), sigma = sd(annual_production$Year), A = max(annual_production$Articles)), annual_production)


    # Calculate model metrics
    models <- list(
        Linear = linear_model,
        Exponential = exponential_model,
        Logarithmic = logarithmic_model,
        Logistic = logistic_model,
        Gompertz = gompertz_model,
        GompertzDerivate = gompertz_derivate_model,
        Weibull = weibull_model,
        VonBertalanffy = vonbertalanffy_model,
        Normal = normal_model
    )

    return(models)
}


do_model_prediction <- function(current_df, future_years, model_name){

}
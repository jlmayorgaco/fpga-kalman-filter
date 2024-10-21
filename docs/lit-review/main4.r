# Load necessary libraries
library(ggplot2)
library(minpack.lm) # For non-linear least squares fitting

# Provided data
years <- c(
  1965, 1976, 1978, 1980, 1981, 1982, 1983, 1984, 1985, 1986, 1987, 1988, 1989, 1990, 1991, 1992, 1993, 1994, 1995, 1996,
  1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015,
  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023
)
papers <- c(
  1, 2, 1, 1, 5, 1, 2, 6, 6, 8, 4, 5, 11, 8, 6, 7, 5, 3, 13, 6, 11, 9, 11, 15, 30, 16, 38, 45, 37, 70, 63, 72, 63, 78,
  71, 78, 71, 79, 98, 64, 86, 83, 100, 98, 102, 103, 115
)

# Define the logistic growth model
logistic_growth <- function(t, K, r, t0) {
  K / (1 + exp(-r * (t - t0)))
}

# Initial parameter guesses
start_params <- list(K = 150, r = 0.1, t0 = 2000)

# Fit the model using nlsLM from minpack.lm
fit <- nlsLM(papers ~ logistic_growth(years, K, r, t0), start = start_params)

# Extract fitted parameters
params <- coef(fit)

print(" ")
print(" params <- coef(fit) ")
print(params)
print(" ")
print(" ")

# Generate fitted values
fitted_papers <- logistic_growth(years, params["K"], params["r"], params["t0"])

# Plot the original data and the fitted model
data <- data.frame(years, papers, fitted_papers)

ggplot(data, aes(x = years)) +
  geom_point(aes(y = papers), color = "blue") +
  geom_line(aes(y = fitted_papers), color = "red") +
  labs(
    title = "Papers Production Per Year",
    x = "Year",
    y = "Number of Papers"
  ) +
  theme_minimal()



# Calculate AIC
aic <- AIC(fit)

# Calculate RMSE
rmse <- sqrt(mean((papers - fitted_papers)^2))

# Calculate R-squared
ss_total <- sum((papers - mean(papers))^2)
ss_residual <- sum((papers - fitted_papers)^2)
r_squared <- 1 - (ss_residual / ss_total)

# Print metrics
cat("AIC:", aic, "\n")
cat("RMSE:", rmse, "\n")
cat("R-squared:", r_squared, "\n")
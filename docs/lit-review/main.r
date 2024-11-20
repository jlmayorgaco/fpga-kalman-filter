# nolint: line_length_linter

# ---------------------------------------------------------------------------- #
# -- main.r ------------------------------------------------------------------ #
# ---------------------------------------------------------------------------- #


# --------------------------------------------------- #
# -- SystemayicReview.r ----------------------------- #
# --------------------------------------------------- #

# SystemayicReview Class
systematicReview <- SystematicReview() # nolint

# Add Config Settings
systematicReview.setDate()
systematicReview.setQuery("")
systematicReview.setBibPath("")
systematicReview.setKeywords(c())

# Load and Init Data
systematicReview.init()

# Check Status and Requirements
systematicReview.do_m0_check_health_status()
systematicReview.do_m0_check_required_columns()

# Modules
systematicReview.do_m1_cleaning()
systematicReview.do_m2_overview()
systematicReview.do_m3_authors()
systematicReview.do_m4_documents()
systematicReview.do_m5_clusterings()
systematicReview.do_m6_conceptual_structure()
systematicReview.do_m7_social_structure()

# Create Report
systematicReview.do_m8_report()

# --------------------------------------------------- #
# -- / SystemayicReview.r --------------------------- #
# --------------------------------------------------- #



# ---------------------------------------------------------------------------- #
# -- Packages and Install Dependencies --------------------------------------- #
# ---------------------------------------------------------------------------- #

# Set CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org"))

# Install and load necessary packages
packages <- c("bibliometrix", "kableExtra", "jsonlite", "pander", "dplyr", "broom", "Metrics", "knitr", "ggplot2", "plotly", "webshot", "gridExtra", "igraph", "nls2", "reshape2", "minpack.lm") # nolint
install.packages(packages, dependencies = TRUE)

# Load required libraries
lapply(packages, require, character.only = TRUE)

# ---------------------------------------------------------------------------- #

# ---------------------------------------------------------------------------- #
# -- Import Data Sources  ---------------------------------------------------- #
# ---------------------------------------------------------------------------- #

# Declare the BibTeX data file path
bib_dir <- "query_power_systems_frequency_estimator_from_1960_to_2023"
bib_path <- paste0("data/scopus/", bib_dir, "/scopus.bib")

# Convert BibTeX data to dataframe
bib_data <- tryCatch(
  {
    convert2df(bib_path, dbsource = "scopus", format = "bibtex")
  },
  error = function(e) {
    stop("Error: Could not convert BibTeX file to dataframe. ", conditionMessage(e)) # nolint
  }
)

# ---------------------------------------------------------------------------- #

# ---------------------------------------------------------------------------- #
# -- Cleaning Data ----------------------------------------------------------- #
# ---------------------------------------------------------------------------- #

# Check for missing mandatory tags
res <- tryCatch(
  {
    missingData(bib_data)
  },
  error = function(e) {
    stop("Error: Could not check for missing mandatory tags. ", conditionMessage(e))
  }
)

# ---------------------------------------------------------------------------- #

# ---------------------------------------------------------------------------- #
# -- Check Required Columns -------------------------------------------------- #
# ---------------------------------------------------------------------------- #
check_required_columns <- function(df, required_columns) {
  missing_columns <- setdiff(required_columns, colnames(df))
  if (length(missing_columns) > 0) {
    warning(paste("Warning: The following required columns are missing:", paste(missing_columns, collapse = ", ")))
    return(FALSE)
  }
  return(TRUE)
}

required_columns_local_citations <- c("AU", "PY", "Page.start", "Page.end", "PP", "SR")

# ---------------------------------------------------------------------------- #

# ---------------------------------------------------------------------------- #
# -- Ch1 BiblioAnalysis  ----------------------------------------------------- #
# ---------------------------------------------------------------------------- #
res1 <- biblioAnalysis(bib_data, sep = ";")
s1 <- summary(res1, pause = FALSE, verbose = FALSE)

# Extract summary information
summary_df <- s1$MainInformationDF

overview_data <- list(
  timespan = as.character(summary_df[summary_df$Description == "Timespan", "Results"]),
  sources = as.integer(summary_df[summary_df$Description == "Sources (Journals, Books, etc)", "Results"]),
  documents = as.integer(summary_df[summary_df$Description == "Documents", "Results"]),
  annual_growth_rate = as.numeric(summary_df[summary_df$Description == "Annual Growth Rate %", "Results"]), # nolint: line_length_linter.
  document_average_age = as.numeric(summary_df[summary_df$Description == "Document Average Age", "Results"]),
  avg_citations_per_doc = as.numeric(summary_df[summary_df$Description == "Average citations per doc", "Results"]),
  avg_citations_per_year_per_doc = as.numeric(summary_df[summary_df$Description == "Average citations per year per doc", "Results"]),
  references = as.integer(summary_df[summary_df$Description == "References", "Results"]),
  document_types = list(
    article = as.integer(summary_df[summary_df$Description == "article", "Results"]),
    article_article = as.integer(summary_df[summary_df$Description == "article article", "Results"]),
    article_conference_paper = as.integer(summary_df[summary_df$Description == "article conference paper", "Results"]),
    article_conference_review = as.integer(summary_df[summary_df$Description == "article conference review", "Results"]),
    book_chapter = as.integer(summary_df[summary_df$Description == "book chapter", "Results"]),
    conference_paper = as.integer(summary_df[summary_df$Description == "conference paper", "Results"]),
    conference_paper_article = as.integer(summary_df[summary_df$Description == "conference paper article", "Results"]),
    conference_paper_conference_paper = as.integer(summary_df[summary_df$Description == "conference paper conference paper", "Results"]),
    conference_review = as.integer(summary_df[summary_df$Description == "conference review", "Results"]),
    conference_review_conference_paper = as.integer(summary_df[summary_df$Description == "conference review conference paper", "Results"]),
    erratum = as.integer(summary_df[summary_df$Description == "erratum", "Results"]),
    letter = as.integer(summary_df[summary_df$Description == "letter", "Results"]),
    retracted = as.integer(summary_df[summary_df$Description == "retracted", "Results"]),
    review = as.integer(summary_df[summary_df$Description == "review", "Results"])
  ),
  document_contents = list(
    keywords_plus = as.integer(summary_df[summary_df$Description == "Keywords Plus (ID)", "Results"]),
    authors_keywords = as.integer(summary_df[summary_df$Description == "Author's Keywords (DE)", "Results"])
  ),
  authors = list(
    total_authors = as.integer(summary_df[summary_df$Description == "Authors", "Results"]),
    author_appearances = as.integer(summary_df[summary_df$Description == "Author Appearances", "Results"]),
    single_authored_docs = as.integer(summary_df[summary_df$Description == "Authors of single-authored docs", "Results"])
  ),
  authors_collaboration = list(
    single_authored_docs = as.integer(summary_df[summary_df$Description == "Single-authored docs", "Results"]),
    documents_per_author = as.numeric(summary_df[summary_df$Description == "Documents per Author", "Results"]),
    co_authors_per_doc = as.numeric(summary_df[summary_df$Description == "Co-Authors per Doc", "Results"]),
    international_co_authorships_pct = as.numeric(summary_df[summary_df$Description == "International co-authorships %", "Results"])
  )
)

# Extract additional summary information
most_prod_authors <- s1$MostProdAuthors
annual_production <- s1$AnnualProduction
most_cited_papers <- s1$MostCitedPapers
most_prod_countries <- s1$MostProdCountries
tc_per_countries <- s1$TCperCountries
most_rel_sources <- s1$MostRelSources
most_rel_keywords <- s1$MostRelKeywords

# Print summary information
#  pander(summary_df, caption = "Summary Information")
# ---------------------------------------------------------------------------- #

# ---------------------------------------------------------------------------- #
# -- Ch2 Author Production Over Time ----------------------------------------- #
# ---------------------------------------------------------------------------- #
author_prod_over_time <- authorProdOverTime(bib_data, graph = TRUE)
author_prod_df <- author_prod_over_time$dfAU
author_prod_papers_df <- author_prod_over_time$dfPapersAU
author_prod_graph <- author_prod_over_time$graph

# Save the graph as an image file
author_prod_graph_file <- "author_prod_over_time.png"
ggsave(author_prod_graph_file, plot = author_prod_graph, width = 8, height = 6)
# ---------------------------------------------------------------------------- #

# ---------------------------------------------------------------------------- #
# -- Ch3 Most Relevant Sources ----------------------------------------------- #
# ---------------------------------------------------------------------------- #
most_rel_sources <- table(bib_data$SO)
most_rel_sources_df <- as.data.frame(most_rel_sources)
colnames(most_rel_sources_df) <- c("Source", "Frequency")
most_rel_sources_df <- most_rel_sources_df[order(-most_rel_sources_df$Frequency), ]
# ---------------------------------------------------------------------------- #

# ---------------------------------------------------------------------------- #
# -- Ch4 Bradford's Law ------------------------------------------------------ #
# ---------------------------------------------------------------------------- #
bradford_law <- bradford(bib_data)
bradford_law_df <- bradford_law$table
# ---------------------------------------------------------------------------- #

# ---------------------------------------------------------------------------- #
# -- Ch5 Sources Local Impact ------------------------------------------------ #
# ---------------------------------------------------------------------------- #
if (check_required_columns(bib_data, required_columns_local_citations)) {
  source_local_impact <- localCitations(bib_data, sep = ";")
  source_local_impact_df <- source_local_impact$LocalSources
} else {
  print("Warning: Required columns for localCitations are missing. Skipping this analysis.")
}
# ---------------------------------------------------------------------------- #

# ---------------------------------------------------------------------------- #
# -- Ch6 Sources Production Over Time ---------------------------------------- #
# ---------------------------------------------------------------------------- #
source_prod_over_time <- sourceGrowth(bib_data)
source_prod_over_time_df <- source_prod_over_time
DF <- melt(source_prod_over_time_df, id = "Year")
ggplot(DF, aes(Year, value, group = variable, color = variable)) +
  geom_line()
# Plot sources production over time
source_prod_over_time_graph <- ggplot(DF, aes(Year, value, group = variable, color = variable)) +
  geom_line()
# Save the graph as an image file
source_prod_over_time_graph_file <- "source_prod_over_time.png"
ggsave(source_prod_over_time_graph_file, plot = source_prod_over_time_graph, width = 8, height = 6)
# ---------------------------------------------------------------------------- #



# ---------------------------------------------------------------------------- #
# -- Model Fit for Annual Production ----------------------------------------- #
# ---------------------------------------------------------------------------- #

# Load necessary libraries
library(ggplot2)
library(dplyr)
library(broom)
library(Metrics)

# Ensure 'Year' is recognized as a column in annual_production
# Convert 'Year' to numeric if necessary
annual_production$Year <- as.numeric(as.character(annual_production$Year))
annual_production <- annual_production %>% filter(Year < 2024)

# Define growth model functions
logistic_growth <- function(t, K, r, N0, t0, y0) {
  y0 + K / (1 + ((K - N0) / N0) * exp(-r * (t - t0)))
}

exponential_growth <- function(t, r, N0) {
  N0 * exp(r * (t - min(t)))
}

# Define Gompertz growth model function
gompertz_growth <- function(t, K, r, t0) {
  K * exp(-exp(r * (t0 - t)))
}

# Define Weibull growth model function
weibull_growth <- function(t, K, lambda, c, t0) {
  K * (1 - exp(-lambda * (t - t0)^c))
}
vonbertalanffy_growth <- function(t, K, r, N0) {
  K * (1 - exp(-r * (t - min(t))))^3
}

linear_growth <- function(t, a, b) {
  a * t + b
}

logarithmic_growth <- function(t, a, b) {
  a * log(t) + b
}

powerlaw_growth <- function(t, a, b) {
  a * t^b
}

# Function to fit a model with error handling
fit_model <- function(formula, data, start) {
  # Remove data for the year 2024
  tryCatch(
    {
      nls(formula, data = data, start = start)
    },
    error = function(e) {
      message("Error fitting model:")
      message(e$message)
      NULL
    }
  )
}

# Fit models with improved error handling
logistic_model <- fit_model(Articles ~ logistic_growth(Year, K, r, N0),
  annual_production,
  start = list(
    K = max(annual_production$Articles),
    r = 0.1,
    y0 = 0.001,
    t0 = 1980,
    N0 = min(annual_production$Articles)
  )
)

exponential_model <- fit_model(Articles ~ exponential_growth(Year, r, N0),
  annual_production,
  start = list(r = 0.1, N0 = min(annual_production$Articles))
)



# Fit Gompertz model with error handling
gompertz_model <- tryCatch(
  {
    fit_model(Articles ~ gompertz_growth(Year, K, r, t0),
      annual_production,
      start = list(
        K = max(annual_production$Articles),
        r = 1,
        t0 = min(annual_production$Year)
      )
    )
  },
  error = function(e) {
    message("Error fitting Gompertz model:")
    message(e$message)
    NULL
  }
)

# Fit Weibull model with error handling
weibull_model <- tryCatch(
  {
    fit_model(Articles ~ weibull_growth(Year, K, lambda, c, t0),
      annual_production,
      start = list(
        K = max(annual_production$Articles),
        lambda = 1,
        c = 0.1,
        t0 = min(annual_production$Year)
      )
    )
  },
  error = function(e) {
    message("Error fitting Weibull model:")
    message(e$message)
    NULL
  }
)



linear_model <- lm(Articles ~ Year, data = annual_production)

logarithmic_model <- fit_model(Articles ~ logarithmic_growth(Year, a, b),
  annual_production,
  start = list(a = 1, b = 1)
)

# Create a sequence of years for plotting
year_seq <- seq(min(annual_production$Year), max(annual_production$Year), length.out = 100)

# Get predictions for each model
predict_model <- function(model, year_seq) {
  if (!is.null(model)) {
    predict(model, newdata = data.frame(Year = year_seq))
  } else {
    rep(NA, length(year_seq))
  }
}

predicted_logistic <- predict_model(logistic_model, year_seq)
predicted_exponential <- predict_model(exponential_model, year_seq)
predicted_gompertz <- predict_model(gompertz_model, year_seq)
predicted_weibull <- predict_model(weibull_model, year_seq)
predicted_linear <- predict_model(linear_model, year_seq)
predicted_logarithmic <- predict_model(logarithmic_model, year_seq)

# Calculate residuals and error metrics
calculate_metrics <- function(model, data) {
  if (!is.null(model)) {
    predictions <- predict(model, newdata = data)
    residuals <- data$Articles - predictions
    rmse <- sqrt(mean(residuals^2))
    r_squared <- 1 - sum(residuals^2) / sum((data$Articles - mean(data$Articles))^2)
    list(rmse = rmse, r_squared = r_squared)
  } else {
    list(rmse = NA, r_squared = NA)
  }
}

metrics_logistic <- calculate_metrics(logistic_model, annual_production)
metrics_exponential <- calculate_metrics(exponential_model, annual_production)
metrics_gompertz <- calculate_metrics(gompertz_model, annual_production)
metrics_weibull <- calculate_metrics(weibull_model, annual_production)
metrics_linear <- calculate_metrics(linear_model, annual_production)
metrics_logarithmic <- calculate_metrics(logarithmic_model, annual_production)

# Create comparison table with parameters and error metrics
extract_parameters <- function(model) {
  if (!is.null(model)) {
    paste(names(coef(model)), "=", coef(model), collapse = ", ")
  } else {
    NA
  }
}

# Calculate AIC manually for nls models
manual_aic <- function(model) {
  if (!is.null(model)) {
    rss <- sum(residuals(model)^2)
    n <- length(residuals(model))
    k <- length(coef(model))
    aic <- n * log(rss / n) + 2 * k
    return(aic)
  } else {
    NA
  }
}

comparison_table <- data.frame(
  Model = c("Logistic", "Exponential", "Gompertz", "Weibull", "Linear", "Logarithmic"),
  AIC = c(manual_aic(logistic_model), manual_aic(exponential_model), manual_aic(gompertz_model), manual_aic(weibull_model), AIC(linear_model), manual_aic(logarithmic_model)),
  RMSE = c(metrics_logistic$rmse, metrics_exponential$rmse, metrics_gompertz$rmse, metrics_weibull$rmse, metrics_linear$rmse, metrics_logarithmic$rmse),
  R_Squared = c(metrics_logistic$r_squared, metrics_exponential$r_squared, metrics_gompertz$r_squared, metrics_weibull$r_squared, metrics_linear$r_squared, metrics_logarithmic$r_squared),
  Parameters = c(
    extract_parameters(logistic_model),
    extract_parameters(exponential_model),
    extract_parameters(gompertz_model),
    extract_parameters(weibull_model),
    extract_parameters(linear_model),
    extract_parameters(logarithmic_model)
  )
)

# Function to determine the best model based on a specific criterion
determine_best_model <- function(comparison_table, criterion = "AIC") {
  best_index <- which.min(comparison_table[[criterion]])
  best_model <- comparison_table$Model[best_index]
  return(best_model)
}

# Determine the best model based on AIC
best_model <- determine_best_model(comparison_table, criterion = "AIC")


# Print the comparison table
print(comparison_table)

# Save the comparison table to a CSV file
write.csv(comparison_table, "model_comparison_table.csv", row.names = FALSE)

# Check if data contains NA values
clean_data <- na.omit(annual_production)

# Function to check validity of line data and add it to the plot
add_line_if_valid <- function(plot, data, color, linetype, model_name, best_model) {
  if (model_name != best_model) {
    return(plot)
  }
  plot <- plot + geom_line(data = data, aes(x = Year, y = Articles), color = color, linetype = "solid")
  return(plot)
}
# Function to check validity of x-intercept and add vertical line to the plot
add_vline_if_valid <- function(plot, xintercept, color, linetype, label = NULL) {
  if (!is.na(xintercept)) {
    plot <- plot + geom_vline(xintercept = xintercept, linetype = linetype, color = color)
    if (!is.null(label)) {
      plot <- plot + annotate("text", x = xintercept, y = Inf, label = label, angle = 90, vjust = -0.5, hjust = 1, color = color)
    }
  }
  return(plot)
}


# Initial plot with clean data points
title <- paste("Annual Publications '", best_model, "' Fit")
plot <- ggplot(clean_data, aes(x = Year, y = Articles))
plot <- plot + geom_point()
plot <- plot + theme_minimal()
plot <- plot + scale_y_continuous(limits = c(0, NA))
plot <- plot + theme(legend.position = "none")
plot <- plot + labs(x = "Year", y = "Articles", title = title)

# Add lines conditionally based on the best model
plot <- add_line_if_valid(plot, data.frame(Year = year_seq, Articles = predicted_logistic), "blue", "solid", "Logistic", best_model)
plot <- add_line_if_valid(plot, data.frame(Year = year_seq, Articles = predicted_exponential), "purple", "dotdash", "Exponential", best_model)
plot <- add_line_if_valid(plot, data.frame(Year = year_seq, Articles = predicted_linear), "orange", "longdash", "Linear", best_model)
plot <- add_line_if_valid(plot, data.frame(Year = year_seq, Articles = predicted_logarithmic), "brown", "dotted", "Logarithmic", best_model)
plot <- add_line_if_valid(plot, data.frame(Year = year_seq, Articles = predicted_gompertz), "green", "solid", "Gompertz", best_model)
plot <- add_line_if_valid(plot, data.frame(Year = year_seq, Articles = predicted_weibull), "red", "dashed", "Weibull", best_model)


# Generate predictions for future years
params <- coef(logistic_model)
K <- params["K"]
r <- params["r"]
N0 <- params["N0"]
y0 <- params["y0"]
t0 <- params["t0"]


future_years <- data.frame(year = seq(2018, 2030))
t <- future_years$year


future_predictions <- logistic_growth(t, K, r, N0, t0, y0)
print(" ")
print(" ")
print(" ===== params ===== ")
print("K")
print(K)
print("r")
print(r)
print("N0")
print(N0)
print(" ===== future_predictions ===== ")
print(future_predictions)
print(" ")
print(" ")

future_data <- data.frame(year = future_years$year, documents = future_predictions)
future_df <- data.frame(Year = future_years$year, Articles = future_predictions)

plot <- plot + geom_line(data = future_df, linetype = "dotted", color = "red", size = 1) # Predictions as a dotted line


# Add vertical lines conditionally with labels
plot <- add_vline_if_valid(plot, 2020, "blue", "dashed", label = "COVID-19")
plot <- add_vline_if_valid(plot, 2008, "blue", "dashed", label = "Market Crash")



# Save the plot as PNG
annual_prod_plot_file <- "results/growth_model_fits.png"
ggsave(annual_prod_plot_file, plot = plot, width = 6, height = 4, dpi = 600)



# ---------------------------------------------------------------------------- #
# -- / Model Fit for Annual Production --------------------------------------- #
# ---------------------------------------------------------------------------- #




# ---------------------------------------------------------------------------- #
# -- Output and Save Files --------------------------------------------------- #
# ---------------------------------------------------------------------------- #
# Save results to JSON
json_file <- "results.json"
json_data <- list(
  data = list(
    status = res$mandatoryTags,
    overview = list(
      main_information = overview_data,
      annual_production = list(
        data = annual_production,
        graph = annual_prod_plot_file
      ),
      most_cited_papers = most_cited_papers,
      most_prod_countries = most_prod_countries,
      tc_per_country = tc_per_countries,
      most_rel_source = most_rel_sources_df,
      most_rel_keywords = most_rel_keywords,
      most_prod_authors = most_prod_authors,
      author_prod_over_time = list(
        au = author_prod_df,
        paper_au = author_prod_papers_df,
        graph = author_prod_graph_file
      ),
      bradford_law = bradford_law_df,
      source_local_impact = if (exists("source_local_impact_df")) source_local_impact_df else NULL,
      source_prod_over_time = list(
        data = source_prod_over_time_df,
        graph = source_prod_over_time_graph_file
      )
    ),
    authors = list(),
    documents = list(),
    clustering = list(),
    conceptual_structure = list(),
    social_structure = list(),
    report = list()
  )
)

# Save overview_data to JSON
overview_json_path <- "results/json_data.json"
write_json(json_data, overview_json_path, pretty = TRUE)

# Save overview_data to JSON
overview_json_path <- "results/overview_data.json"
write_json(overview_data, overview_json_path, pretty = TRUE)

# Save most relevant sources to CSV
most_rel_sources_csv_path <- "results/most_rel_sources.csv"
write.csv(most_rel_sources_df, most_rel_sources_csv_path, row.names = FALSE)

# Save Bradford's Law data to CSV
bradford_law_csv_path <- "results/bradford_law.csv"
write.csv(bradford_law_df, bradford_law_csv_path, row.names = FALSE)

# Save source local impact data to CSV
if (exists("source_local_impact_df")) {
  source_local_impact_csv_path <- "results/source_local_impact.csv"
  write.csv(source_local_impact_df, source_local_impact_csv_path, row.names = FALSE)
}

# Save source production over time data to CSV
source_prod_over_time_csv_path <- "results/source_prod_over_time.csv"
write.csv(source_prod_over_time_df, source_prod_over_time_csv_path, row.names = FALSE)

# Save author production over time data to CSV
author_prod_csv_path <- "results/author_prod_over_time.csv"
write.csv(author_prod_df, author_prod_csv_path, row.names = FALSE)

# Save the comparison table to CSV
comparison_table_csv_path <- "results/model_comparison_table.csv"
write.csv(comparison_table, comparison_table_csv_path, row.names = FALSE)

# Save most productive authors to CSV
most_prod_authors_csv_path <- "results/most_prod_authors.csv"
write.csv(most_prod_authors, most_prod_authors_csv_path, row.names = FALSE)

# Save most cited papers to CSV
most_cited_papers_csv_path <- "results/most_cited_papers.csv"
write.csv(most_cited_papers, most_cited_papers_csv_path, row.names = FALSE)

# Save most productive countries to CSV
most_prod_countries_csv_path <- "results/most_prod_countries.csv"
write.csv(most_prod_countries, most_prod_countries_csv_path, row.names = FALSE)

# Save total citations per country to CSV
tc_per_countries_csv_path <- "results/tc_per_countries.csv"
write.csv(tc_per_countries, tc_per_countries_csv_path, row.names = FALSE)

# Save most relevant keywords to CSV
most_rel_keywords_csv_path <- "results/most_rel_keywords.csv"
write.csv(most_rel_keywords, most_rel_keywords_csv_path, row.names = FALSE)
# ---------------------------------------------------------------------------- #

# ---------------------------------------------------------------------------- #
# -- End --------------------------------------------------------------------- #
# ---------------------------------------------------------------------------- #

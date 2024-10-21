# Load necessary libraries
library(ggplot2)
library(dplyr)
library(broom)
library(Metrics)
library(minpack.lm)
library(rlang)
library(zoo)
library(jsonlite)

# Load additional scripts
source('libs/RBiblioMetricsAnalyzer/M2_Annual_Production/M2_Annual_Production___Data_Cleaning.r')
source('libs/RBiblioMetricsAnalyzer/M2_Annual_Production/M2_Annual_Production___Metrics.r')
source('libs/RBiblioMetricsAnalyzer/M2_Annual_Production/M2_Annual_Production___Models.r')
source('libs/RBiblioMetricsAnalyzer/M2_Annual_Production/M2_Annual_Production___Regression.r')
source('libs/RBiblioMetricsAnalyzer/M2_Annual_Production/M2_Annual_Production___Plotter.r')
source('libs/RBiblioMetricsAnalyzer/M2_Annual_Production/M2_Annual_Production___Report.r')


# M2_Annual_Production class
M2_Annual_Production <- setRefClass(
  "M2_Annual_Production",
  fields = list(
    df = "data.frame",
    df_year_column = "character",
    df_articles_column = "character",
    regression_models = "list",
    metrics_best_model = "ANY",
    metrics_comparison_table = "ANY",
    report_path = "character"
  ),
  methods = list(
    # Constructor
    initialize = function(df, year_col = "Year", articles_col = "Articles", report_path = "results/M2_Annual_Production") {
      .self$df <- df
      .self$df_year_column <- year_col
      .self$df_articles_column <- articles_col
      .self$regression_models <- list()
      .self$metrics_best_model <- NULL
      .self$metrics_comparison_table <- NULL
      .self$report_path <- report_path
      .self$initializeReportDir()
    },
    
    # Initialize report directory
    initializeReportDir = function() {
      if (!dir.exists(.self$report_path)) {
        dir.create(.self$report_path, recursive = TRUE)
      }
    },
    
    # Accessor methods
    getYearData = function() {
      return(.self$df[[.self$df_year_column]])
    },
    
    getArticlesData = function() {
      return(.self$df[[.self$df_articles_column]])
    },
    
    # Run regression models and determine best fit
    runRegression = function() {
      x <- .self$getYearData()
      y <- .self$getArticlesData()
      .self$regression_models <- get_regression_models(x = x, y = y)
      .self$metrics_comparison_table <- get_metrics_comparison_table(models = .self$regression_models, data = .self$df)
      .self$metrics_best_model <- get_best_model(.self$metrics_comparison_table)
    },
    
    # Run all metrics
    runMetrics = function() {
      list(
        eda = .self$runMetricEDA(),
        trend = .self$runMetricTrending(),
        periodic = .self$runMetricPeriodic()
      )
    },
    
    # Run EDA metric
    runMetricEDA = function() {
      x <- .self$getYearData()
      y <- .self$getArticlesData()
      
      df <- .self$df
      
      start_year <- min(x, na.rm = TRUE)
      end_year <- max(x, na.rm = TRUE)
      peak_row <- df[which.max(y), ]
      
      anomalies <- get_anomalies(df, .self$df_articles_column, .self$df_year_column, .self$metrics_best_model$name, .self$metrics_best_model$params)
      window_sizes <- c(5, 10, 20)
      moving_avgs <- lapply(window_sizes, function(window) {
        df_avg <- data.frame(Year = df[[.self$df_year_column]], Articles = df[[.self$df_articles_column]])
        return(calculate_moving_average(df_avg, "Articles", window_size = window))
      })
      
      m0_eda <- list(
        start_date = start_year,
        end_year = end_year,
        peak_year = peak_row[[.self$df_year_column]],
        peak_articles = peak_row[[.self$df_articles_column]],
        anomalies = anomalies,
        outliers = list(
          zscore = detect_outliers_zscore(df, .self$df_articles_column),
          identified = identify_outliers(df, .self$df_articles_column, .self$df_year_column)
        ),
        moving_averages_arrays = moving_avgs,
        moving_averages_window_size = window_sizes
      )

      json_data <- toJSON(m0_eda, pretty = TRUE, auto_unbox = TRUE)
      write(json_data, file = file.path(.self$report_path, "m0_eda.json"))
      
      save_metric_m0_eda_table(m0_eda)
      save_metric_m0_eda_plots(m0_eda)

      return(m0_eda)
    },
    
    # Run Trending metric
    runMetricTrending = function() {
      message("[METRIC] M1 TREND")
      
      v_metrics_comparison_table <- .self$metrics_comparison_table %>% select(-Model_Object)
      
      m1_trending <- list(
        model_name = .self$metrics_best_model$name,
        model_params = .self$metrics_best_model$params,
        model_r_squared = .self$metrics_best_model$R2,
        model_aic = .self$metrics_best_model$AIC,
        model_rmse = .self$metrics_best_model$RMSE,
        model_regression_table = v_metrics_comparison_table
      )

      json_data <- toJSON(m1_trending, pretty = TRUE, auto_unbox = TRUE)
      write(json_data, file = file.path(.self$report_path, "m1_trending.json"))
      
      save_metric_m1_trending_table(m1_trending)
      # Uncomment the following line if plotting is implemented
      # save_metric_m1_trending_plots(m1_trending)
      
      return(m1_trending)
    },
    
    # Run Periodic metric
    runMetricPeriodic = function() {
      message("[METRIC] M2 PERIODIC")
      
      is_periodic <- FALSE # Placeholder logic for periodic analysis
      
      m2_periodic <- list(
        is_periodic = is_periodic
      )
      
      save_metric_m2_periodic_table(m2_periodic)
      save_metric_m2_periodic_plots(m2_periodic)
      
      return(m2_periodic)
    },
    
    # Run report generation
    runReport = function() {
      message("=============== RUN REPORT ==================")
      # Uncomment the following line to run all metrics before generating the report
      # .self$runMetrics()
    }
  )
)

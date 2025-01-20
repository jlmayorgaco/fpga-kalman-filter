library("ggsci")
library("ggplot2")
library("gridExtra")


determine_trend <- function(model_name, model_params, df, articles_column) {
  trend <- ""
  
  if (model_name == "Linear") {
    slope <- model_params["slope"]
    if (slope > 0) {
      trend <- "Linear Increasing"
      return(trend)
    }
    if (slope < 0) {
      trend <- "Linear Decreasing"
      return(trend)
    }
  }
  
    if (model_name == "Exponential") {
        r <- model_params["r"]
        if (r > 0) {
            trend <- "Exponential Increasing"
            return(trend)
        } else {
            trend <- "Exponential Decreasing"
            return(trend)
        }
    }
  
    if (model_name == "Logarithmic") {
        a <- model_params["a"]
        if (a > 0) {
            trend <- "Logarithmic Increasing"
            return(trend)
        } else {
            trend <- "Logarithmic Decreasing"
            return(trend)
        }
    }
  
    if (model_name == "PowerLaw") {
        b <- model_params["b"]
        if (b > 0) {
            trend <- "PowerLaw Increasing"
            return(trend)
        }
        if (b < 0) {
            trend <- "PowerLaw Decreasing"
            return(trend)
        }
    }
    
    if (model_name == "Gompertz") {
        trend <- "Gompertz growth"
        return(trend)
    }
    
    if (model_name == "Weibull") {
        trend <- "Weibull growth"
        return(trend)
    }
    
    if (model_name == "VonBertalanffy") {
        trend <- "Von Bertalanffy growth"
        return(trend)
    }
    
    if (model_name == "Normal") {
        trend <- "Normal growth"
        return(trend)
    }
    
    if (model_name == "Logistic") {
        K <- model_params["K"]
        max_articles <- max(df[[articles_column]], na.rm = TRUE)
        if (K > max_articles) {
            trend <- "Logistic Increasing"
            return(trend)
        } else {
            trend <- "Logistic Decreasing"
            return(trend)
        }
    }
    
    return(trend)
    }




# Year-over-Year Growth Rate
calculate_growth_rate <- function(df, year_column, articles_column) {
  df <- df %>% arrange(!!sym(year_column))
  df <- df %>% mutate(Growth_Rate = (df[[articles_column]] / lag(df[[articles_column]]) - 1) * 100)
  return(df)
}

# Year-over-Year Growth in Nominal Values
calculate_growth_rate_nominal <- function(df, year_column, articles_column) {
  # Ensure the data is sorted by the year
  df <- df %>% arrange(!!sym(year_column))
  # Calculate the absolute change in the number of articles
  #df <- df %>% mutate(Growth_Rate = diff(df[[articles_column]]))
  df <- df %>% mutate(Growth_Rate = df[[articles_column]] - lag(df[[articles_column]]))
  return(df)
}

# Moving Average
calculate_moving_average <- function(df, articles_column, window_size = 10) {
  # Calculate the moving average with NA padding
  df2 <- df %>%
    mutate(Articles = zoo::rollmeanr(df[[articles_column]], k = window_size, fill = NA))
  return(df2)
}

# Outlier Analysis
identify_outliers <- function(df, articles_column, year_column) {
  outliers <- boxplot.stats(df[[articles_column]])$out
  outlier_years <- df[df[[articles_column]] %in% outliers, ][[year_column]]
  return(outlier_years)
}

# Top N Years
identify_top_n_years <- function(df, articles_column, n = 5) {
  top_n_years <- df %>% arrange(desc(df[[articles_column]])) %>% head(n)
  return(top_n_years)
}


# Cohort Analysis
# Here, we assume you want to analyze cohorts in a specific way. Modify as needed.
cohort_analysis <- function(df, year_column, articles_column) {
  # Example: Calculate the sum of articles for each cohort (year)
  cohort_summary <- df %>% group_by(!!sym(year_column)) %>% summarise(Cohort_Sum = sum(!!sym(articles_column), na.rm = TRUE))
  return(cohort_summary)
}

# Percentage Contribution
calculate_percentage_contribution <- function(df, articles_column) {
  total_articles <- sum(df[[articles_column]], na.rm = TRUE)
  df <- df %>% mutate(Percentage_Contribution = (df[[articles_column]] / total_articles) * 100)
  return(df)
}


seasonal_analysis <- function(df, year_column, articles_column, frequency = 1) {
  # Extract the time series data
  start_year <- min(df[[year_column]])
  ts_data <- ts(df[[articles_column]], start = start_year, frequency = frequency)
  
  # Check if the time series has at least two periods
  min_periods <- if (frequency == 1) 2 else 24 / frequency  # 2 for annual, 24 for monthly, etc.
  if (length(ts_data) < min_periods) {
    message("The time series does not have enough data points for seasonal decomposition. At least two periods are required.")
    return(NULL)
  }
  
  # Perform STL decomposition
  decomposed <- tryCatch({
    stl(ts_data, s.window = "periodic")
  }, error = function(e) {
    message("Error in STL decomposition: ", e$message)
    return(NULL)
  })
  
  return(decomposed)
}

# Cumulative Count
calculate_cumulative_count <- function(df, articles_column) {
  df <- df %>% mutate(Cumulative_Count = cumsum(df[[articles_column]]))
  return(df)
}

report_get_summary<- function(){
    
}




save_report_table_csv <- function(df_name, df) {
  # Define the directory path
  dir_path <- "results/M2_Annual_Production"

  # Check if the directory exists, if not, create it
  if (!dir.exists(dir_path)) {
    dir.create(dir_path, recursive = TRUE)
  }

  # Define the file path
  file_path <- file.path(dir_path, paste0(df_name, ".csv"))

  # Check if the dataframe is NULL
  if (is.null(df)) {
    # Create a dataframe with the message
    message_df <- data.frame(Message = paste(df_name, " Analysis unable to run, given a NULL report"))
    # Write the message dataframe to a CSV file
    write.csv(message_df, file_path, row.names = FALSE)
  } else {
    # Write the original dataframe to a CSV file
    write.csv(df, file_path, row.names = FALSE)
  }
}




save_plot_report_df <- function(df_title, df_name, df_column, df) {

  # Remove rows with NA values
  df <- na.omit(df)

  # Save the plot
  dir_path <- "results/M2_Annual_Production"
  if (!dir.exists(dir_path)) {
    dir.create(dir_path, recursive = TRUE)
  }

  year_column <- "Year"
  v_aes <- aes_string(x = year_column, y = df_column)
  v_labs <- labs(title = df_title, x = "Year", y = df_column)

  # Define IEEE style theme
  ieee_theme <- theme(
    text = element_text(size = 12, family = "Times New Roman"),
    legend.title = element_text(size = 10),
    legend.text = element_text(size = 8),
    axis.title = element_text(size = 12),
    axis.line = element_line(color = "black", size = 0.25, linetype = "solid"),
    axis.text = element_text(size = 10),
    panel.background = element_rect(fill = "white"),
    panel.grid.major = element_line(color = "gray95", size = 0.25),
    panel.grid.minor = element_line(color = "gray95", size = 0.125),
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),  # Center title
    plot.margin = margin(t = 5, r = 5, b = 5, l = 5),
    axis.ticks = element_line(color = "black"),
    axis.ticks.length = unit(0.2, "cm"),  # Adjust this length as needed
    axis.ticks.length.minor = unit(0.1, "cm")  # Adjust this length as needed
  )

  # Calculate minimum and maximum values
  MinX <- min(df[[year_column]], na.rm = TRUE)
  MinY <- min(df[[df_column]], na.rm = TRUE)
  MaxX <- max(df[[year_column]], na.rm = TRUE)
  MaxY <- max(df[[df_column]], na.rm = TRUE)


  # Calculate break intervals
  Nx <- 5
  Ny <- 6
  DX <- MaxX - MinX
  DY <- MaxY - MinY

  # Ensure nx and ny are valid
  nx <- max(1, ceiling(DX / Nx), na.rm = TRUE)  # Ensure nx is at least 1
  ny <- max(1, ceiling(DY / Ny), na.rm = TRUE)  # Ensure ny is at least 1

  # Calculate breaks with a check to prevent invalid sequences
  x_breaks <- seq(MinX, MaxX, by = nx)
  x_breaks <- ceiling(x_breaks[x_breaks <= MaxX])  # Ensure breaks do not exceed max value
  y_breaks <- seq(MinY, MaxY, by = ny)
  y_breaks <- ceiling(y_breaks[y_breaks <= MaxY])  # Ensure breaks do not exceed max value

  # Plotting the growth rate over the years
  p <- ggplot(df, v_aes)
  p <- p + geom_line(color = "gray45", linetype = "solid")
  p <- p + geom_point(color = "black", size = 2, shape = 20)  # Professional point shape and color
  p <- p + theme_minimal(base_size = 10)
  p <- p + scale_color_npg()
  p <- p + v_labs
  p <- p + ieee_theme

  p <- p + scale_y_continuous(
    expand = c(0, 0),
    limits = c(MinY, MaxY),
    breaks = y_breaks
    #minor_breaks = seq(min(y_breaks), max(y_breaks), by = ny / 10)  # Adding minor breaks
  )
  p <- p + scale_x_continuous(
    expand = c(0, 0),
    limits = c(MinX, MaxX),
    breaks = x_breaks
    #minor_breaks = seq(min(x_breaks), max(x_breaks), by = nx / 10)  # Adding minor breaks
  )

  # Save the plot with dimensions and dpi suitable for a 2-column layout
  ggsave(filename = file.path(dir_path, paste0(df_name, ".png")), plot = p, width = 3.5, height = 2.5, dpi = 900)
}
detect_outliers_zscore <- function(df, column) {
  df <- df %>%  mutate(Z_Score = (df[[column]] - mean(df[[column]], na.rm = TRUE)) / sd(df[[column]], na.rm = TRUE))
  outliers <- df %>% filter(abs(Z_Score) > 3)  # Threshold of 3 standard deviations
  return(outliers)
}


detect_outliers_iqr <- function(df, column) {
  Q1 <- quantile(df[[column]], 0.25, na.rm = TRUE)
  Q3 <- quantile(df[[column]], 0.75, na.rm = TRUE)
  IQR <- Q3 - Q1
  lower_bound <- Q1 - 1.5 * IQR
  upper_bound <- Q3 + 1.5 * IQR
  outliers <- df %>% filter(df[[column]] < lower_bound | df[[column]] > upper_bound)
  return(outliers)
}


library(changepoint)

detect_change_points <- function(df, column) {
  # Extract the numeric vector from the data frame and remove NA values
  data <- df[[column]]
  data <- na.omit(data)
  data <- as.numeric(data)
  cp <- cpt.meanvar(data, method = "PELT")
  return(cp)
}

library(zoo)

detect_trend_changes_moving_avg <- function(df, column, window = 5) {
  df <- df %>% mutate(Moving_Avg = rollmean(df[[column]], window, fill = NA))
  df <- df %>% mutate(Deviation = abs(df[[column]] - Moving_Avg))
  return(df)
}

plot_data2 <- function(df, column) {
  p <- ggplot(df, aes(x = seq_along(df[[column]]), y = df[[column]])) +
    geom_line() +
    geom_point(aes(color = ifelse(df[[column]] %in% detect_outliers_zscore(df, column)$Growth_Rate, "Outlier", "Normal"))) +
    labs(title = "Time Series with Outliers", x = "Time", y = "Value") +
    theme_minimal()

  ggsave(filename = './results/M2_Annual_Production/plot_data2.png', plot = p, width = 3.5, height = 2.5, dpi = 900)
}

# Function to save EDA metrics to a CSV file
save_metric_m0_eda_table <- function(m0_eda) {
  # Define the file path for saving the results
  file_path <- file.path("results/M2_Annual_Production", "m0_eda_table.csv")
  
  # Create a dataframe for saving
  eda_data <- data.frame(
    Start_Date = m0_eda$start_date,
    End_Year = m0_eda$end_year,
    Peak_Year = m0_eda$peak_year,
    Peak_Articles = m0_eda$peak_articles,
    Anomalies_Count = nrow(m0_eda$anomalies),
    Outliers_ZScore_Count = length(m0_eda$outliers$zscore),
    Outliers_Identified_Count = length(m0_eda$outliers$identified),
    Moving_Averages_Window_Sizes = paste(m0_eda$moving_averages_window_size, collapse = ",")
  )
  
  # Write the dataframe to a CSV file
  write.csv(eda_data, file = file_path, row.names = FALSE)
  
  message("EDA metrics saved to: ", file_path)
}
save_metric_m0_eda_plots <- function(metric_eda) {

  # Main code
  moving_averages_window_size <- metric_eda$moving_averages_window_size
  moving_averages_arrays <- metric_eda$moving_averages_arrays

  # Convert lists to data frames with types
  df_moving_average_n1_years <- convert_to_df(moving_averages_arrays[1], "Moving Average N1")
  df_moving_average_n2_years <- convert_to_df(moving_averages_arrays[2], "Moving Average N2")
  df_moving_average_n3_years <- convert_to_df(moving_averages_arrays[3], "Moving Average N3")

  # Combine all data frames
  combined_df <- rbind(df_moving_average_n1_years, df_moving_average_n2_years, df_moving_average_n3_years)

  # Create directory if it doesn't exist
  dir_path <- "results/M2_Annual_Production"
  if (!dir.exists(dir_path)) {
    dir.create(dir_path, recursive = TRUE)
  }

  # Create and save the plot
  output_file_path <- file.path(dir_path, "moving_averages_plot.png")
  create_moving_average_plot(combined_df, output_file_path)

}
save_metric_m1_trending_plots <- function(metric_trend) {

}
save_metric_m2_periodic_plots <- function(metric_periodic) {

}

save_metric_m1_trending_table <- function(metric_trend) {
  path <- file.path("results/", "M2_Annual_Production/m1_trending_table.csv");
  # Create a list to store the metric data
  trend_list <- list(
    ModelName = metric_trend$model_name,
    ModelParams = metric_trend$model_params,
    ModelRSquare = metric_trend$model_r_squared,
    ModelRegressionTable = metric_trend$model_regression_table
  )
  # Save the list as a JSON file
  write.csv(trend_list, file = path, row.names = FALSE)
}
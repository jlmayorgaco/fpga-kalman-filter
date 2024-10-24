# Load necessary libraries
library(ggplot2)
library(ggsci)

# Define a color palette
plotters_colors <- c(
  "Blue" = "#3785cf",
  "Green" = "#46a152",
  "Orange" = "#e85803",
  "Yellow" = "#ffc103",
  "Brown" = "#8f2802",
  "DarkBlue" = "#0a2967",
  "Darkgrey" = "#232323"
)

# Function to add a valid line to the plot
add_line_if_valid <- function(plot, data, color, linetype, model_name, best_model) {
  if (model_name == best_model) {
    plot <- plot + geom_line(data = data, aes(x = Year, y = Articles), color = plotters_colors[color], linetype = linetype)
  }
  return(plot)
}

# Function to add a vertical line to the plot if valid
add_vline_if_valid <- function(plot, xintercept, color, linetype, label = NULL) {
  if (!is.na(xintercept)) {
    plot <- plot + geom_vline(xintercept = xintercept, linetype = linetype, color = plotters_colors[color])
    if (!is.null(label)) {
      plot <- plot + annotate("text", x = xintercept, y = Inf, label = label, angle = 90, vjust = -0.5, hjust = 1, color = plotters_colors[color])
    }
  }
  return(plot)
}

# Function to save plots with moving averages
save_moving_average_plots <- function(df_title, df_name, year_column, df, moving_avgs, window_sizes) {
  # Remove rows with NA values
  df <- clean_data(df)

  # Create directory for saving plots
  dir_path <- "results/M2_Annual_Production"
  ensure_directory(dir_path)

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
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    plot.margin = margin(t = 5, r = 5, b = 5, l = 5),
    axis.ticks = element_line(color = "black"),
    axis.ticks.length = unit(0.2, "cm"),
    axis.ticks.length.minor = unit(0.1, "cm")
  )

  # Plot all moving averages together
  p_all <- ggplot(df, aes_string(x = year_column)) +
    geom_line(aes(y = df[[df_name]]), color = "gray45", linetype = "solid") +
    geom_point(aes(y = df[[df_name]]), color = "black", size = 2, shape = 20) +
    theme_minimal(base_size = 10) +
    scale_color_npg() +
    ieee_theme +
    labs(title = paste0(df_title, " with Moving Averages"), x = "Year", y = df_name)

  for (i in seq_along(moving_avgs)) {
    p_all <- p_all +
      geom_line(data = moving_avgs[[i]], aes_string(y = "Moving_Average"), 
                color = scales::hue_pal()(length(window_sizes))[i], 
                linetype = "dashed")
  }

  ggsave(filename = file.path(dir_path, paste0(df_name, "_all_moving_averages.png")), 
         plot = p_all, width = 3.5, height = 2.5, dpi = 900)

  # Plot each moving average individually
  for (i in seq_along(moving_avgs)) {
    p_individual <- ggplot(df, aes_string(x = year_column)) +
      geom_line(aes(y = df[[df_name]]), color = "gray45", linetype = "solid") +
      geom_point(aes(y = df[[df_name]]), color = "black", size = 2, shape = 20) +
      geom_line(data = moving_avgs[[i]], aes_string(y = "Moving_Average"), 
                color = scales::hue_pal()(length(window_sizes))[i], 
                linetype = "dashed") +
      theme_minimal(base_size = 10) +
      scale_color_npg() +
      ieee_theme +
      labs(title = paste0(df_title, " with ", window_sizes[i], "-Year Moving Average"), 
           x = "Year", y = df_name)

    ggsave(filename = file.path(dir_path, paste0(df_name, "_", window_sizes[i], "_year_moving_average.png")), 
           plot = p_individual, width = 3.5, height = 2.5, dpi = 900)
  }
}



# Function to create the plot
create_moving_average_plot <- function(data, output_path) {
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
    axis.ticks.length = unit(0.2, "cm"),
    axis.ticks.length.minor = unit(0.1, "cm")
  )

  plot <- ggplot(data, aes(x = Year, y = Articles, color = Type)) +
    geom_point(size = 2) +
    geom_line(size = 0.75) +
    labs(
      title = "Moving Averages Over the Years",
      x = "Year",
      y = "Moving Average of Articles",
      color = "Type"
    ) +
    ieee_theme +
    scale_color_manual(values = c("red", "blue", "green")) +
    theme_minimal() +
    theme(legend.position = "bottom")

  ggsave(filename = output_path, plot = plot, width = 10, height = 6, dpi = 300)
}

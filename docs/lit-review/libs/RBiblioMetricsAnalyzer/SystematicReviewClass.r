# ---------------------------------------------------------------------------- #
# -- Packages and Install Dependencies --------------------------------------- #
# ---------------------------------------------------------------------------- #

# Set CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org"))

# Function to install and load packages
install_and_load <- function(packages) {
  new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]
  if (length(new_packages)) install.packages(new_packages, dependencies = TRUE)
  invisible(lapply(packages, require, character.only = TRUE))
}

# List of required packages
packages <- c("bibliometrix", "ggsci", "changepoint", "kableExtra", "jsonlite", 
              "pander", "rlang", "dplyr", "broom", "Metrics", "knitr", "ggplot2", 
              "plotly", "webshot", "gridExtra", "igraph", "nls2", "reshape2", "minpack.lm")

# Install and load necessary packages
install_and_load(packages)

# Load inner libraries and functions
source('libs/RBiblioMetricsAnalyzer/M2_Main_Information/M2_Main_Information.r')
source('libs/RBiblioMetricsAnalyzer/M2_Annual_Production/M2_Annual_Production.r')

# ---------------------------------------------------------------------------- #

# SystematicReviewClass.r
SystematicReview <- setRefClass(

  # -------------------------------------------- #
  # ---- Systematic Review Class --------------- #
  # -------------------------------------------- #
  "SystematicReview",
  # -------------------------------------------- #

  # -------------------------------------------- #
  # ---- Systematic Review Attributes ---------- #
  # -------------------------------------------- #
  fields = list(
    title = "character",
    date = "character",
    query = "character",
    bibPath = "character",
    keywords = "character",
    data = "ANY",
    results = "list"
  ),
  # -------------------------------------------- #

  # -------------------------------------------- #
  # ---- Systematic Review Methods ------------- #
  # -------------------------------------------- #
  methods = list(
    # Constructor
    new = function() {
      title <<- ''
      date <<- ''
      query <<- ''
      bibPath <<- ''
      keywords <<- character()
      data <<- NULL
      results <<- list(
        main_information = list()
      )
    },

    # Setters
    setTitle = function(title) {
      .self$title <- title
    },
    setDate = function(date) {
      .self$date <- date
    },
    setQuery = function(query) {
      .self$query <- query
    },
    setBibPath = function(bibPath) {
      .self$bibPath <- bibPath
    },
    setKeywords = function(keywords) {
      .self$keywords <- keywords
    },

    # Initialize data
    init = function() {

      # Welcome message
      message(" ")
      message(" ")
      message("\n =============================== >")
      message(" == SystematicReview :: init...")
      message(" =============================== >\n")
      message(" ")
      message(" ")
      
      # Paths
      bib_path <- .self$bibPath

      # Convert BibTeX data to dataframe
      .self$data <- tryCatch({
        convert2df(bib_path, dbsource = "scopus", format = "bibtex")
      }, error = function(e) {
        stop("Error: Could not convert BibTeX file to dataframe. ", conditionMessage(e))
      })

    },

    # Check health status
    do_m0_check_health_status = function() {
      # Placeholder for health status check logic
      message(" ")
      message(" ")
      message(" M0 :: Checking health status...")
      message(" ")
      message(" ")
    },

    # Check required columns
    do_m0_check_required_columns = function() {
      # Placeholder for checking required columns
      message(" ")
      message(" ")
      message(" M0 :: Checking required columns...")
      message(" ")
      message(" ")
    },

    # ---------------------------------------------------------------------------- #
    # --  #Module 1: Data Cleaning ----------------------------------------------- #
    # ---------------------------------------------------------------------------- #
    do_m1_cleaning = function() {
      # Placeholder for data cleaning logic
      message(" ")
      message(" ")
      message(" M1 :: Cleaninig data ...")
      message(" ")
      message(" ")

      # Check for missing mandatory tags
      res <- tryCatch({
        missingData(.self$data)
      }, error = function(e) {
        stop("Error: Could not check for missing mandatory tags. ", conditionMessage(e))
      })
    },
    # ---------------------------------------------------------------------------- #

    # ---------------------------------------------------------------------------- #
    # --  #Module 2: Main Information -------------------------------------------- #
    # ---------------------------------------------------------------------------- #
    do_m2_main_information = function() {
      message(" ")
      message(" ")
      message(" M2 :: Analyzing Main Information...")
      message(" ")
      message(" ")

      overview <- fn_m2_main_information(.self$data)

      .self$results$overview <- list(
        main_information = overview$main_information,
        most_cited_papers = overview$most_cited_papers,
        most_prod_countries = overview$most_prod_countries,
        tc_per_country = overview$tc_per_countries,
        most_rel_source = overview$most_rel_sources,
        most_rel_keywords = overview$most_rel_keywords,
        most_prod_authors = overview$most_prod_authors,
        author_prod_over_time = overview$author_prod_over_time,
        bradford_law = overview$bradford_law
      )

      path_dir <- "results/M2_Main_Information";
      path_file <- paste0(path_dir,'/m2_main_information.json')
      if (!dir.exists(path_dir)) {
        dir.create(path_dir, recursive = TRUE)
      }

      # Saving the overview to JSON file
      jsonlite::write_json(
        overview, 
        path = path_file, 
        pretty = TRUE
      )
    },
    # ---------------------------------------------------------------------------- #

    # ---------------------------------------------------------------------------- #
    # --  #Module 2: Annual Production ------------------------------------------- #
    # ---------------------------------------------------------------------------- #
    do_m2_author_prod_over_time_regression = function() {
      message(" ")
      message(" ")
      message(" M2 :: Analyzing Annual Production...")
      message(" ")
      message(" ")

      v_df <- .self$results$overview$author_prod_over_time
      colnames(v_df) <- trimws(colnames(v_df))

      # Convert Year to numeric if it's a factor
      if (is.factor(v_df$Year)) {
        v_df$Year <- as.numeric(as.character(v_df$Year))
      }

      v_df <- v_df %>% filter(Year < 2024)

      m2AnnualProduction <- M2_Annual_Production(
        df = v_df, 
        year_col = "Year", 
        articles_col = "Articles", 
        report_path = "results/M2_Annual_Production"
      );

      m2AnnualProduction$runRegression();
      m2AnnualProduction$runMetrics();
      m2AnnualProduction$runReport();

    },
    # ---------------------------------------------------------------------------- #

    # Module 3: Authors Analysis
    do_m3_authors = function() {
      # Placeholder for authors analysis logic
      message("Analyzing authors...")
    },

    # Module 4: Documents Analysis
    do_m4_documents = function() {
      # Placeholder for documents analysis logic
      message("Analyzing documents...")
    },

    # Module 5: Clusterings
    do_m5_clusterings = function() {
      # Placeholder for clustering logic
      message("Performing cluster analysis...")
    },

    # Module 6: Conceptual Structure
    do_m6_conceptual_structure = function() {
      # Placeholder for conceptual structure logic
      message("Analyzing conceptual structure...")
    },

    # Module 7: Social Structure
    do_m7_social_structure = function() {
      # Placeholder for social structure logic
      message("Analyzing social structure...")
    },

    # Module 8: Create Report
    do_m8_report = function() {
      # Placeholder for report creation logic
      message("Creating report...")
    },

    # Module 9: Save
    do_m9_save = function() {
      # Placeholder for report creation logic
      message("Saving Files...")

      # Save overview_data to JSON
      json_path <- "results/exported_bibliometrics_results.json"
      json_data <- .self$results
      #write_json(json_data, json_path, pretty = TRUE)
    }
    # ---------------------------------------------------------------------------- #
  )
)

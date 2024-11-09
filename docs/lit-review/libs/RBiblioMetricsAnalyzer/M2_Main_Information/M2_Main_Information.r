# ---------------------------------------------------------------------------- #
# -- M2 Main Information  ---------------------------------------------------- #
# ---------------------------------------------------------------------------- #

# Main function to extract and clean main information from bibliometric data
fn_m2_main_information <- function(bib_data) {
  res1 <- biblioAnalysis(bib_data, sep = ";")
  s1 <- summary(res1, pause = FALSE, verbose = FALSE)

  # Extract summary information
  summary_df <- s1$MainInformationDF

  # Extract and clean additional summary information
  most_prod_authors <- clean_whitespace(s1$MostProdAuthors)
  annual_production <- clean_whitespace(s1$AnnualProduction)
  most_cited_papers <- clean_whitespace(s1$MostCitedPapers)
  most_prod_countries <- clean_whitespace(s1$MostProdCountries)
  tc_per_countries <- clean_whitespace(s1$TCperCountries)
  most_rel_sources <- clean_whitespace(s1$MostRelSources)
  most_rel_keywords <- clean_whitespace(s1$MostRelKeywords)

  bradford_law <- bradford(bib_data)
  bradford_law_df <- bradford_law$table

  main_information_data <- list(
    main_information = list(
      timespan = as.character(summary_df[summary_df$Description == "Timespan", "Results"]),
      sources = as.integer(summary_df[summary_df$Description == "Sources (Journals, Books, etc)", "Results"]),
      documents = as.integer(summary_df[summary_df$Description == "Documents", "Results"]),
      annual_growth_rate = as.numeric(summary_df[summary_df$Description == "Annual Growth Rate %", "Results"]),
      document_average_age = as.numeric(summary_df[summary_df$Description == "Document Average Age", "Results"]),
      avg_citations_per_doc = as.numeric(summary_df[summary_df$Description == "Average citations per doc", "Results"]),
      avg_citations_per_year_per_doc = as.numeric(summary_df[summary_df$Description == "Average citations per year per doc", "Results"]),
      references = as.integer(summary_df[summary_df$Description == "References", "Results"]),
      document_types = list(
        article = as.integer(summary_df[summary_df$Description == "article", "Results"]),
        article_article = as.integer(summary_df[summary_df$Description == "article article", "Results"]),
        article_conference_paper = as.integer(summary_df[summary_df$Description == "article conference paper", "Results"]),
        article_review = as.integer(summary_df[summary_df$Description == "article review", "Results"]),
        conference_paper = as.integer(summary_df[summary_df$Description == "conference paper", "Results"]),
        review = as.integer(summary_df[summary_df$Description == "review", "Results"])
      ),
      keywords_plus = as.integer(summary_df[summary_df$Description == "Author Keywords (DE)", "Results"]),
      author_keywords = as.integer(summary_df[summary_df$Description == "Keywords-Plus (ID)", "Results"]),
      authors = as.integer(summary_df[summary_df$Description == "Authors", "Results"]),
      authors_per_doc = as.numeric(summary_df[summary_df$Description == "Authors per Document", "Results"]),
      co_authors_per_doc = as.numeric(summary_df[summary_df$Description == "Co-Authors per Documents", "Results"]),
      international_collaborations = as.numeric(summary_df[summary_df$Description == "International co-authorships %", "Results"]),
      single_author_documents = as.integer(summary_df[summary_df$Description == "Single-authored documents", "Results"]),
      multi_author_documents = as.integer(summary_df[summary_df$Description == "Multi-authored documents", "Results"])
    ),
    most_cited_papers = most_cited_papers,
    most_prod_countries = most_prod_countries,
    tc_per_countries = tc_per_countries,
    most_rel_sources = most_rel_sources,
    most_rel_keywords = most_rel_keywords,
    most_prod_authors = most_prod_authors,
    author_prod_over_time = annual_production,
    bradford_law = bradford_law_df
  )

  return(main_information_data)
}
# Function to clean whitespace from a data frame
clean_whitespace <- function(df) {
  # Trim whitespace from column names
  colnames(df) <- trimws(colnames(df))
  
  # Trim whitespace from each element of the data frame
  df[] <- lapply(df, function(x) {
    if (is.character(x)) {
      # Remove leading and trailing spaces and reduce multiple spaces to a single space
      gsub("\\s+", " ", trimws(x))
    } else {
      x
    }
  })
  return(df)
}
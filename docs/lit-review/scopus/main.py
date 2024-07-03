import fsspec
import pandas as pd
import matplotlib.pyplot as plt
import geopandas as gpd
import numpy as np
from numpy.polynomial.polynomial import Polynomial

# Load CSV files into DataFrames, specifying any extra characters to strip
df_author = pd.read_csv('Scopus-1845-Analyze-Author.csv', skipinitialspace=True)
df_year = pd.read_csv('Scopus-1845-Analyze-Year.csv', skipinitialspace=True)
df_country = pd.read_csv('Scopus-1845-Analyze-Country.csv', skipinitialspace=True)
df_funding = pd.read_csv('Scopus-1845-Analyze-FundingSponsor.csv', skipinitialspace=True)

# Strip extra quotation marks from column names if present
df_author.columns = df_author.columns.str.replace('"', '')
df_year.columns = df_year.columns.str.replace('"', '')
df_country.columns = df_country.columns.str.replace('"', '')
df_funding.columns = df_funding.columns.str.replace('"', '')

# Sort data by count in descending order
df_author = df_author.sort_values(by='Count', ascending=False)
df_year = df_year.sort_values(by='Count', ascending=False)
df_country = df_country.sort_values(by='Count', ascending=False)
df_funding = df_funding.sort_values(by='Count', ascending=False)

# Create a figure and subplots with IEEE style
fig, axs = plt.subplots(2, 2, figsize=(10, 8), constrained_layout=True)

# Set common styles
plt.rcParams.update({'font.size': 10, 'font.family': 'serif', 'axes.titlesize': 12, 'axes.labelsize': 10})

# Polynomial fit function
x_data = df_year['YEAR'].values
y_data = df_year['Count'].values

# Polynomial regression
p = Polynomial.fit(x_data, y_data, 3)

# Plot publication years as scatter plot with polynomial fit
scatter = axs[0, 0].scatter(x_data, y_data, color='b', label='Data')
x_fit = np.linspace(x_data.min(), x_data.max(), 500)
axs[0, 0].plot(x_fit, p(x_fit), 'r-', label=f'Fit: degree=3')
axs[0, 0].set_xlabel('Year')
axs[0, 0].set_ylabel('Number of Publications')
axs[0, 0].set_title('Publication Trend over Years')
axs[0, 0].grid(True)
axs[0, 0].legend()

# Set axis limits based on scatter plot data
axs[0, 0].set_xlim([x_data.min(), x_data.max()])
axs[0, 0].set_ylim([y_data.min(), y_data.max()])

# Load the world shapefile
world = gpd.read_file('ne_110m_admin_0_countries/ne_110m_admin_0_countries.shp')
# Merge the country data with the world shapefile
world = world.merge(df_country, how='left', left_on='ADMIN', right_on='COUNTRY')
# Plot the world map with country counts
world.boundary.plot(ax=axs[0, 1], edgecolor='k')
world.plot(column='Count', ax=axs[0, 1], legend=True, legend_kwds={'shrink': 0.5}, missing_kwds={'color': 'lightgrey'})
axs[0, 1].set_title('Distribution of Publications by Country/Territory')

# Plot top authors
top_authors = df_author.head(10).sort_values(by='Count', ascending=True)  # Adjust as needed and reverse order
axs[1, 0].barh(top_authors['AUTHOR NAME'], top_authors['Count'], color='orange')
axs[1, 0].set_xlabel('Number of Publications')
axs[1, 0].set_ylabel('Authors')
axs[1, 0].set_title('Top Authors on Power Systems Frequency Estimator')

# Handle long text labels for authors
axs[1, 0].set_yticks(range(len(top_authors)))
axs[1, 0].set_yticklabels([text if len(text) <= 15 else text[:15] + '...' for text in top_authors['AUTHOR NAME']])

# Plot funding sponsors
top_funding = df_funding.head(10).sort_values(by='Count', ascending=True)  # Adjust as needed and reverse order
axs[1, 1].barh(top_funding['FUNDING-SPONSORS'], top_funding['Count'], color='purple')
axs[1, 1].set_xlabel('Number of Publications')
axs[1, 1].set_ylabel('Funding Sponsors')
axs[1, 1].set_title('Funding Sponsors on Power Systems Frequency Estimator')

# Handle long text labels for funding sponsors
axs[1, 1].set_yticks(range(len(top_funding)))
axs[1, 1].set_yticklabels([text if len(text) <= 20 else text[:20] + '...' for text in top_funding['FUNDING-SPONSORS']])

# Adjust layout and show plot
plt.show()

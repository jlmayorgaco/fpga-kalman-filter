import fsspec
import pandas as pd
import matplotlib.pyplot as plt
import geopandas as gpd
from numpy.polynomial.polynomial import Polynomial
import numpy as np
import json

title = 'Analysis of Publications on Power Systems Frequency Estimator'

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

# Function to convert text to acronym
def to_acronym(text):
    return ''
    #return ''.join([word[0].upper() for word in text.split()])

# Create a figure and subplots with IEEE style
fig, axs = plt.subplots(2, 2, figsize=(14, 10))

# Set common styles
plt.rcParams.update({'font.size': 10, 'font.family': 'serif', 'axes.titlesize': 12, 'axes.labelsize': 10})

# Polynomial fit function
x_data = df_year['YEAR'].values
y_data = df_year['Count'].values

# Polynomial regression
p = Polynomial.fit(x_data, y_data, 3)

# Plot publication years as scatter plot with polynomial fit
scatter = axs[0, 0].scatter(x_data, y_data, color='g', label='Publications')
x_fit = np.linspace(x_data.min(), x_data.max(), 500)
axs[0, 0].plot(x_fit, p(x_fit), linestyle='--', color='lightgray', label=f'Fit: degree=3')
axs[0, 0].set_xlabel('Year')
axs[0, 0].set_ylabel('Number of Publications')
axs[0, 0].set_title('Publication Trend over Years')
axs[0, 0].grid(True)
axs[0, 0].legend()

# Set axis limits based on scatter plot data
axs[0, 0].set_xlim([x_data.min(), x_data.max() + 1])
axs[0, 0].set_ylim([0, y_data.max() + 2])

# Load the world shapefile
world = gpd.read_file('ne_110m_admin_0_countries/ne_110m_admin_0_countries.shp')
# Merge the country data with the world shapefile
world = world.merge(df_country, how='left', left_on='ADMIN', right_on='COUNTRY')
# Plot the world map with country counts
world.boundary.plot(ax=axs[0, 1], edgecolor='k')
world.plot(column='Count', ax=axs[0, 1], legend=True, legend_kwds={'shrink': 0.5}, missing_kwds={'color': 'lightgrey'})
axs[0, 1].set_title('Publications by Country')

# Plot top authors
top_authors = df_author.head(10).sort_values(by='Count', ascending=True)  # Adjust as needed and reverse order
axs[1, 0].barh(top_authors['AUTHOR NAME'], top_authors['Count'], color='green')
axs[1, 0].set_xlabel('Number of Publications')
#axs[1, 0].set_ylabel('Authors')
axs[1, 0].set_title('Top Authors')

# Handle long text labels for authors
axs[1, 0].set_yticks(range(len(top_authors)))
axs[1, 0].set_yticklabels([text if len(text) <= 15 else text[:15] + '...' for text in top_authors['AUTHOR NAME']])

# Plot funding sponsors
top_funding = df_funding.head(10).sort_values(by='Count', ascending=True)  # Adjust as needed and reverse order
bars = axs[1, 1].barh(top_funding['FUNDING-SPONSORS'], top_funding['Count'], color='green')
axs[1, 1].set_xlabel('Number of Publications')
#axs[1, 1].set_ylabel('Funding Sponsors')
axs[1, 1].set_title('Funding Sponsors')

# Handle long text labels for funding sponsors
axs[1, 1].set_yticks(range(len(top_funding)))
axs[1, 1].set_yticklabels([to_acronym(text) for text in top_funding['FUNDING-SPONSORS']])

# Add custom legend with "Acronym: Full Name"
for bar, full_name, count in zip(bars, top_funding['FUNDING-SPONSORS'], top_funding['Count']):
    w_bar = bar.get_width()
    w_text = 0.5*len(full_name)
    w_bar_and_text = w_bar + w_text
    w_subplot = 1.1*top_funding['Count'].max()
    print(' ')
    print('full_name',full_name)
    print('w_bar',w_bar)
    print('w_text',w_text)
    print('w_bar_and_text',w_bar_and_text)
    print('w_subplot',w_subplot)
    print(' ')
    if w_bar_and_text > w_subplot :
        # Text inside bar with color white
        axs[1, 1].text(
            w_bar - 2*w_text - 0.15*w_text,
            bar.get_y() + bar.get_height()/2,
            f'{full_name}',
            va='center',
            ha='left',
            fontsize=8,
            color='white'
        )
    else :
        axs[1, 1].text(
            bar.get_width() + 1,
            bar.get_y() + bar.get_height()/2,
            f'{full_name}',
            va='center',
            ha='left',
            fontsize=8
        )

# Add overall title
fig.suptitle(title, fontsize=14, fontweight='bold')

# Adjust layout with margins and spacing
plt.subplots_adjust(left=0.1, right=0.95, top=0.9, bottom=0.1, hspace=0.3)

# Save the plot as PNG and SVG files
plt.savefig('publication_trend.png', format='png', dpi=600)
plt.savefig('publication_trend.svg', format='svg')

# Prepare data for JSON serialization
data_for_json = {
    'author': df_author.to_dict(orient='records'),
    'year': df_year.to_dict(orient='records'),
    'country': df_country.to_dict(orient='records'),
    'funding': df_funding.to_dict(orient='records')
}

# Save data to JSON file
with open('publication_data.json', 'w') as json_file:
    json.dump(data_for_json, json_file, indent=4)

# Show plot
plt.show()

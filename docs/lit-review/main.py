
import sys
import os

from libs.BiblioMetricsPlotter.utils import DataLoaderClass
from libs.BiblioMetricsPlotter.boards.Board1BoardClass import Plotter

def main():

    title = 'Analysis of Publications on Power Systems Frequency Estimator'

    data_loader = DataLoaderClass(
        author_file='Scopus-1845-Analyze-Author.csv',
        year_file='Scopus-1845-Analyze-Year.csv',
        country_file='Scopus-1845-Analyze-Country.csv',
        funding_file='Scopus-1845-Analyze-FundingSponsor.csv'
    )
    df_author, df_year, df_country, df_funding = data_loader.load_data()

    plotter = Plotter(title, df_author, df_year, df_country, df_funding)
    plotter.plot_all()

    data_for_json = {
        'author': df_author.to_dict(orient='records'),
        'year': df_year.to_dict(orient='records'),
        'country': df_country.to_dict(orient='records'),
        'funding': df_funding.to_dict(orient='records')
    }

    with open('publication_data.json', 'w') as json_file:
        json.dump(data_for_json, json_file, indent=4)

if __name__ == "__main__":
    main()
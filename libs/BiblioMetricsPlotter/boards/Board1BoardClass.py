import fsspec
import json

import numpy as np
import pandas as pd
import geopandas as gpd
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec

from mpl_toolkits.axes_grid1 import make_axes_locatable
from numpy.polynomial.polynomial import Polynomial

class Plotter:
    def __init__(self, title, df_author, df_year, df_country, df_funding):
        self.title = title
        self.df_author = df_author
        self.df_year = df_year
        self.df_country = df_country
        self.df_funding = df_funding
        self.fig, self.axs = plt.subplots(2, 2, figsize=(14, 10))
        plt.rcParams.update({'font.size': 10, 'font.family': 'serif', 'axes.titlesize': 12, 'axes.labelsize': 10})

    def plot_all(self):
        self.plot_publication_trend()
        self.plot_world_map()
        self.plot_top_authors()
        self.plot_funding_sponsors()
        self.add_overall_title()
        self.adjust_layout()
        self.save_plots()
        plt.show()

    def plot_publication_trend(self):
        x_data = self.df_year['YEAR'].values
        y_data = self.df_year['Count'].values
        p = Polynomial.fit(x_data, y_data, 3)

        self.axs[0, 0].scatter(x_data, y_data, color='g', label='Publications')
        x_fit = np.linspace(x_data.min(), x_data.max(), 500)
        self.axs[0, 0].plot(x_fit, p(x_fit), linestyle='--', color='lightgray', label='Fit: degree=3')
        self.axs[0, 0].set_xlabel('Year')
        self.axs[0, 0].set_ylabel('Number of Publications')
        self.axs[0, 0].set_title('Publication Trend over Years')
        self.axs[0, 0].grid(True)
        self.axs[0, 0].legend()
        self.axs[0, 0].set_xlim([x_data.min(), x_data.max() + 1])
        self.axs[0, 0].set_ylim([0, y_data.max() + 2])

    def plot_world_map(self):
        ax = self.axs[0, 1]

        # Load the world shapefile and exclude Antarctica
        world = gpd.read_file('maps/natural-earth-vector-master/10m_cultural/ne_10m_admin_0_countries_usa.shp')
        world = world[world['ADMIN'] != 'Antarctica']
        world = world.merge(self.df_country, how='left', left_on='ADMIN', right_on='COUNTRY')

        # Plot the world boundaries and the world data
        world.boundary.plot(ax=ax, edgecolor='black', linewidth=0.1)
        world_plot = world.plot(ax=ax, column='Count', legend=False, missing_kwds={'color': 'lightgrey'})

        # Adjust the limits to fit the map into the subplot
        xlim = (world.total_bounds[0], world.total_bounds[2])
        ylim = (world.total_bounds[1], world.total_bounds[3])
        ax.set_xlim(xlim)
        ax.set_ylim(ylim)
        ax.set_aspect('auto')  # Adjust aspect ratio to fill the axes

        # Remove axis
        ax.axis('off')

        # Set title
        ax.set_title('Publications by Country')

        # Add a border around the subplot axes
        for spine in ax.spines.values():
            spine.set_visible(True)
            spine.set_linewidth(5)

        # Create a colorbar
        sm = plt.cm.ScalarMappable(cmap='viridis', norm=plt.Normalize(vmin=world['Count'].min(), vmax=world['Count'].max()))
        sm._A = []  # Required for ScalarMappable
        cbar = self.fig.colorbar(sm, ax=ax, orientation='horizontal', pad=0.05)
        cbar.ax.tick_params(labelsize='small')
        cbar.set_label('Number of Publications', fontsize='medium')

    def plot_top_authors(self):
        top_authors = self.df_author.head(10).sort_values(by='Count', ascending=True)
        self.axs[1, 0].barh(top_authors['AUTHOR NAME'], top_authors['Count'], color='green')
        self.axs[1, 0].set_xlabel('Number of Publications')
        self.axs[1, 0].set_title('Top Authors')

        self.axs[1, 0].set_yticks(range(len(top_authors)))
        self.axs[1, 0].set_yticklabels([self._truncate_text(text) for text in top_authors['AUTHOR NAME']])

    def plot_funding_sponsors(self):
        top_funding = self.df_funding.head(10).sort_values(by='Count', ascending=True)
        bars = self.axs[1, 1].barh(top_funding['FUNDING-SPONSORS'], top_funding['Count'], color='green')
        self.axs[1, 1].set_xlabel('Number of Publications')
        self.axs[1, 1].set_title('Funding Sponsors')

        self.axs[1, 1].set_yticks(range(len(top_funding)))
        self.axs[1, 1].set_yticklabels([self._to_acronym(text) for text in top_funding['FUNDING-SPONSORS']])

        for bar, full_name, count in zip(bars, top_funding['FUNDING-SPONSORS'], top_funding['Count']):
            w_bar = bar.get_width()
            w_text = 0.5 * len(full_name)
            w_bar_and_text = w_bar + w_text
            w_subplot = 1.1 * top_funding['Count'].max()
            if w_bar_and_text > w_subplot:
                self.axs[1, 1].text(
                    w_bar - 2 * w_text - 0.15 * w_text,
                    bar.get_y() + bar.get_height() / 2,
                    f'{full_name}',
                    va='center',
                    ha='left',
                    fontsize=8,
                    color='white'
                )
            else:
                self.axs[1, 1].text(
                    bar.get_width() + 1,
                    bar.get_y() + bar.get_height() / 2,
                    f'{full_name}',
                    va='center',
                    ha='left',
                    fontsize=8
                )

    def add_overall_title(self):
        self.fig.suptitle(self.title, fontsize=14, fontweight='bold')

    def adjust_layout(self):
        plt.subplots_adjust(left=0.1, right=0.95, top=0.9, bottom=0.1, hspace=0.3)

    def save_plots(self):
        plt.savefig('publication_trend.png', format='png', dpi=600)
        plt.savefig('publication_trend.svg', format='svg')

    @staticmethod
    def _truncate_text(text, length=15):
        return text if len(text) <= length else text[:length] + '...'

    @staticmethod
    def _to_acronym(text):
        return ''.join([word[0].upper() for word in text.split()])

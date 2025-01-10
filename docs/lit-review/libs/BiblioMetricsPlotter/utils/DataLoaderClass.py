import fsspec
import json

import numpy as np
import pandas as pd
import geopandas as gpd
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec

from mpl_toolkits.axes_grid1 import make_axes_locatable
from numpy.polynomial.polynomial import Polynomial

class DataLoaderClass:
    def __init__(self, author_file, year_file, country_file, funding_file):
        self.author_file = author_file
        self.year_file = year_file
        self.country_file = country_file
        self.funding_file = funding_file

    def load_data(self):
        df_author = self._load_csv(self.author_file)
        df_year = self._load_csv(self.year_file)
        df_country = self._load_csv(self.country_file)
        df_funding = self._load_csv(self.funding_file)
        return df_author, df_year, df_country, df_funding

    def _load_csv(self, file):
        df = pd.read_csv(file, skipinitialspace=True)
        df.columns = df.columns.str.replace('"', '')
        return df.sort_values(by='Count', ascending=False)

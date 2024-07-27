# BiblioMetricsPlotter/__init__.py

from boards.Board1BoardClass import Plotter
from utils.DataLoaderClass import DataLoaderClass

# Export Path
__path__ = __import__('pkgutil').extend_path(__path__, __name__)

# Version
__version__ = '1.0.0'

# Export symbols
__all__ = ['Plotter', 'DataLoaderClass']
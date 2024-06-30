
import json
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle
from pyDigitalWaveTools.vcd.parser import VcdParser

from typing import List
from typing import Optional


from ..utils.VCDSignalsClass import SignalClass

class ExpResultGraphBoardClass:

    def __init__(self):
        self.bitstreamGraph = None
        self.chartGraph = None

    def setBitStreamGraph(self, graph) -> None:
        self.bitstreamGraph = graph

    def setChartGraph(self, graph) -> None:
        self.chartGraph = graph

    def render(self) -> None:

        # ------------------------------------------------------ #
        # -- Fig and Axes MatplotLib --------------------------- #
        # ------------------------------------------------------ #
        fig, axs = plt.subplots(2, 2, figsize=(12, 10))
        # ------------------------------------------------------ #

        # ------------------------------------------------------ #
        # --  Set Global --------------------------------------- #
        # ------------------------------------------------------ #
        fig.patch.set_linewidth(2)
        fig.patch.set_edgecolor('black')
        fig.tight_layout(pad=1.0)
        # ------------------------------------------------------ #

        # ------------------------------------------------------ #
        # -- Canvas : Blank Space for Schematic ---------------- #
        # ------------------------------------------------------ #
        rect = Rectangle((0, 0), 1, 1, fill=False, edgecolor='gainsboro', linewidth=2,  linestyle='--', transform=axs[0, 0].transAxes)
        axs[0, 0].axis('off')
        axs[0, 0].add_patch(rect)
        # ------------------------------------------------------ #


        # ------------------------------------------------------ #
        # -- Canvas : Chart Graph ------------------------------ #
        # ------------------------------------------------------ #
        self.chartGraph.addAxis(axs[0, 1])
        self.chartGraph.render()
        # ------------------------------------------------------ #


        # ------------------------------------------------------ #
        # -- Canvas : Bitstream Graph -------------------------- #
        # ------------------------------------------------------ #
        axs[1, 0].remove()
        axs[1, 1].remove()
        ax_horizontal = fig.add_subplot(2, 1, 2)
        self.bitstreamGraph.addAxis(ax_horizontal)
        self.bitstreamGraph.render()
        # ------------------------------------------------------ #



        # ------------------------------------------------------ #
        # -- Canvas : Borders ---------------------------------- #
        # ------------------------------------------------------ #
        margin = 1
        outer_border = Rectangle((0, 0), 1, 1, linewidth=1.5, edgecolor='black', facecolor='none', transform=fig.transFigure)
        fig.patches.extend([outer_border])
        outer_border.set_bounds(margin / fig.bbox.width, margin / fig.bbox.height, 1 - 2 * margin / fig.bbox.width, 1 - 2 * margin / fig.bbox.height)
        # ------------------------------------------------------ #


        # ------------------------------------------------------ #
        # -- Save  --------------------------------------------- #
        # ------------------------------------------------------ #
        plt.subplots_adjust(left=0.075, right=0.925, top=0.935, bottom=0.085, wspace=0.25, hspace=0.25)
        plt.savefig('main_wave_plot.svg', format='svg', bbox_inches='tight', pad_inches=0.25)
        plt.savefig('main_wave_plot.png', format='png', bbox_inches='tight', pad_inches=0.25)
        plt.show()
        # ------------------------------------------------------ #
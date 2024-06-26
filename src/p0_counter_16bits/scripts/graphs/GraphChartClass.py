import json
import matplotlib.pyplot as plt

from typing import List
from typing import Optional

from ..utils.VCDSignalsClass import SignalClass

from matplotlib.patches import Rectangle
from pyDigitalWaveTools.vcd.parser import VcdParser


class GraphChartClass:

    def __init__(self):
        self.vcd_data = None
        self.axis = None
        self.title: str = 'Input and Output Signals'
        self.xLabel: str = 'Time (ms)'
        self.yLabel: str = 'Signal Values'
        self.signals: List[SignalClass] = []

    def addSignal(self, signal: SignalClass) -> None:
        self.signals.append(signal)

    def addAxis(self, axis) -> None:
        self.axis = axis
    
    def addTitle(self, title: str) -> None:
        self.title = title

    def addLabelY(self, label: str) -> None:
        self.yLabel = label

    def addLabelX(self, label: str) -> None:
        self.xLabel = label

    def render(self) -> None:
        for signal in self.signals:
            x = signal.interpoled_timestamps
            y = signal.interpoled_values
            label = signal.label
            self.axis.plot(x, y, label=label, linestyle='-', color='green', linewidth=2, drawstyle='steps-post')

        self.axis.set_xlabel(self.xLabel)
        self.axis.set_ylabel(self.yLabel)
        self.axis.set_title(self.title)
        self.axis.legend()
        self.axis.grid(True)

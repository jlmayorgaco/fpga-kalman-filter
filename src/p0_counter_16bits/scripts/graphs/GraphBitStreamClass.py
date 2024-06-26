import json
import matplotlib.pyplot as plt

from typing import List
from typing import Optional

from ..utils.VCDSignalsClass import SignalClass

class GraphBitStreamClass:

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

    def isBit(sefl, signal: SignalClass) -> bool:
        return signal.self.type == 'bit'

    def isInteger(sefl, signal: SignalClass) -> bool:
        return signal.self.type == 'int'

    def isHex(sefl, signal: SignalClass) -> bool:
        return signal.self.type == 'hex'

    def render(self) -> None:
        for k, signal in enumerate(self.signals):

            x = signal.binary_time_milliseconds
            y = signal.binary_values
            label = signal.label

            offset = 1.5*k

            if(self.isBit(signal)):
                int_y = [int(value) + offset for value in y]  # Adjust each signal's y-value
                self.axis.plot(x, int_y, color='green', linewidth=2, drawstyle='steps-post')
                self.axis.fill_between(x, offset, signal, step='post', color='green', alpha=0.3)
                self.axis.text(-0.0095, offset + 0.5, label, va='center', ha='left')
            else:
                print('NOT SINGLE BIT')


        self.axis.set_title(self.title)

        self.axis.set_xlabel(self.xLabel)
        self.axis.set_ylabel(self.yLabel)

        self.axis.set_yticks([])
        self.axis.grid(True, axis='x')
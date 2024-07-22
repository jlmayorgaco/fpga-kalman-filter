import json
import itertools

from typing import List
from typing import Optional

from matplotlib.ticker import FuncFormatter

from ..utils.VCDSignalsClass import SignalClass

TIME_SCALE = 1e6 # 1e3
class GraphChartClass:

    def __init__(self):
        self.vcd_data = None
        self.axis = None
        self.title: str = 'Input and Output Signals'
        self.xLabel: str = 'Time (ns)'
        self.yLabel: str = 'Signal Values'
        self.signals: List[SignalClass] = []

        self.limitX = None

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

    def setLimitX(self, limit: float) -> None:
        self.limitX = limit

    @staticmethod
    def abbreviate_number(y, _):
            if y >= 1_000_000:
                return f'{y / 1_000_000:.0f}M'.rstrip('0').rstrip('.')
            elif y >= 1_000:
                return f'{y / 1_000:.0f}k'.rstrip('0').rstrip('.')
            else:
                return str(int(y))

    def render(self) -> None:

        # Define a list of colors and line styles to cycle through
        colors = ['green', 'yellowgreen', 'gray', 'darkgreen', 'blue', 'red', 'cyan', 'magenta', 'yellow', 'black']
        line_styles = ['-', '--', '-.', ':']

        # Create an iterator that cycles through the colors and line styles
        color_cycle = itertools.cycle(colors)
        line_style_cycle = itertools.cycle(line_styles)

        for signal in self.signals:
            x = [timestamp / TIME_SCALE for timestamp in signal.interpoled_timestamps]
            y = signal.interpoled_values
            label = signal.label

            # Get the next colr and line style from the cycles
            color = next(color_cycle)
            line_style = next(line_style_cycle)

            # Plot the signal with the chosen color and line style
            self.axis.plot(x, y, label=label, linestyle=line_style, color=color, linewidth=2, drawstyle='steps-post')

        #  Last Clock time
        last_x_clock = x[-1]

        # Add a vertical line and label at the last x value
        if last_x_clock is not None:
            self.axis.axvline(x=last_x_clock, color='red', linestyle='--', alpha=0.7)
            #self.axis.text(last_x_clock + 5, -2.65, str(int(last_x_clock)), color='black', va='bottom', ha='right')


        self.axis.set_xlabel(self.xLabel)
        self.axis.set_ylabel(self.yLabel)
        self.axis.set_title(self.title)

        if(self.limitX):
            self.axis.set_xlim([x[0], self.limitX])
        else:
            self.axis.set_xlim([x[0], x[len(x) - 1]])
        self.axis.legend()
        self.axis.grid(True)
        # Set custom formatter for the y-axis
        self.axis.yaxis.set_major_formatter(FuncFormatter(self.abbreviate_number))


import json
import matplotlib.pyplot as plt
from typing import List
from typing import Optional

from ..utils.VCDSignalsClass import SignalClass
TIME_SCALE = 1e6 # 1e3
class GraphBitStreamClass:

    def __init__(self):
        self.vcd_data = None
        self.axis = None
        self.title: str = 'Input and Output Signals'
        self.xLabel: str = 'Time (us)'
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
        return signal.type == 'bit'

    def isInteger(sefl, signal: SignalClass) -> bool:
        return signal.type == 'int'

    def isHex(sefl, signal: SignalClass) -> bool:
        return signal.type == 'hex'

    def render(self) -> None:
        max_plots = 8
        height_increment = 2
        size_signals = len(self.signals[:max_plots]);
        clock_signal = next((item for item in self.signals if item.name == 'clk'), None)


        x_clock = [timestamp / TIME_SCALE for timestamp in clock_signal.interpoled_timestamps]
        for i in range(0, len(x_clock), 2):
            self.axis.axvline(x=x_clock[i], color='darkgrey', linestyle='--', alpha=0.25)


        # Fill in the remaining spaces with zero signals
        for i in range(size_signals, max_plots):
            offset = (max_plots - i) * height_increment
            if self.signals:
                x = [timestamp / TIME_SCALE for timestamp in clock_signal.interpoled_timestamps]
            else:
                x = [0, 1]
            y = [offset] * len(x)
            self.axis.plot(x, y, color='green', linewidth=2, linestyle='--', alpha=0.5)
            self.axis.text(0, offset + 0.5, '', va='center', ha='left')


        for k, signal in enumerate(self.signals[:max_plots]):

            x = [timestamp / TIME_SCALE for timestamp in signal.interpoled_timestamps]  # Convert to microseconds
            y = signal.interpoled_values
            label = signal.label

            offset = height_increment * (max_plots - k)

            if(self.isBit(signal)):
                int_y = [int(value) + offset  for value in y]
                # Here is plotting data in bit stream like _-_---___-_-_
                self.axis.plot(x, int_y, color='green', linewidth=2, drawstyle='steps-post')
                self.axis.fill_between(x, offset, int_y, step='post', color='green', alpha=0.3)
                self.axis.text(-7.5, offset + 0.5, label, va='center', ha='left')

            if(self.isInteger(signal)):
                x = [timestamp / TIME_SCALE for timestamp in signal.binary_timestamps]  # Convert to microseconds
                y = signal.binary_values

                int_y = [int(value) + offset  for value in y]
                text_y = [str(value) for value in y]
                delta = 0.025
                for i in range(len(x) - 1):
                    x_i= [x[i], x[i] + delta, x[i] + 50*delta, x[i+1] - 50*delta, x[i+1] - delta, x[i+1] ]
    
                    top = offset + 0.7 * height_increment
                    middle = offset + 0.35 * height_increment
                    bottom = offset - 0.0 * height_increment

                    y_top_i = [middle, middle, bottom,  bottom, middle, middle]
                    y_bottom_i = [middle, middle, top ,  top, middle, middle]

                    text_i = text_y[i]
                    # Top line
                    self.axis.plot(x_i, y_top_i, color='green', linewidth=2)
                    # Bottom line
                    self.axis.plot(x_i, y_bottom_i, color='green', linewidth=2)
                    # Value text
                    mid_x = (x[i] + x[i+1]) / 2
                    min_y = offset + 0.35 * height_increment
                    self.axis.text(mid_x, min_y, text_i, va='center', ha='center', fontsize=8, bbox=dict(facecolor='white', edgecolor='none', pad=5))
                self.axis.text(-2*len(label) - 2, offset + 0.7, label, va='center', ha='left')

        # Last Clock time
        last_x_clock = x_clock[-1]

        # Add a vertical line and label at the last x value
        if last_x_clock is not None:
            self.axis.axvline(x=last_x_clock, color='red', linestyle='--', alpha=0.7)
            self.axis.text(last_x_clock + 2, -1, str(int(last_x_clock)), color='black', va='bottom', ha='right')

        self.axis.set_title(self.title)
        self.axis.set_xlabel(self.xLabel)
        self.axis.set_ylabel(self.yLabel)

        self.axis.set_yticks([0, max_plots * height_increment])
        self.axis.set_xlim([x_clock[0], x_clock[len(x_clock) - 1]])
        self.axis.set_yticklabels([])

        # Adjust the subplot parameters for this specific axis
        plt.tight_layout()
        plt.subplots_adjust(left=0.3)  # Adjust the left margin for better Y label visibility


        self.axis.grid(True, axis='x')


import json
import matplotlib.pyplot as plt
from typing import List, Optional

from ..utils.VCDSignalsClass import SignalClass

TIME_SCALE = 1e6  # 1e3
TIME_MAX_LIMIT = 60
height_increment = 2


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

    @staticmethod
    def abbreviate_number(number_str: str) -> str:
        number = int(number_str)
        if number >= 1_000_000:
            return f'{number / 1_000_000:.0f}M'
        elif number >= 1_000:
            return f'{number / 1_000:.0f}k'
        else:
            return str(number)

    @staticmethod
    def is_bit(signal: SignalClass) -> bool:
        return signal.type == 'bit'

    @staticmethod
    def is_integer(signal: SignalClass) -> bool:
        return signal.type == 'int'

    @staticmethod
    def is_hex(signal: SignalClass) -> bool:
        return signal.type == 'hex'

    def plot_zero_signals(self, clock_signal: SignalClass, max_plots):
        for i in range(len(self.signals), max_plots):
            offset = (max_plots - i) * height_increment
            x = [timestamp / TIME_SCALE for timestamp in clock_signal.interpoled_timestamps] if self.signals else [0, 1]
            y = [offset] * len(x)
            self.axis.plot(x, y, color='green', linewidth=2, linestyle='--', alpha=0.5)
            self.axis.text(0, offset + 0.5, '', va='center', ha='left')

    def plot_signals(self, clock_signal: SignalClass, max_plots):
        for k, signal in enumerate(self.signals[:max_plots]):
            x = [timestamp / TIME_SCALE for timestamp in signal.interpoled_timestamps][:TIME_MAX_LIMIT]
            y = signal.interpoled_values[:TIME_MAX_LIMIT]
            label = signal.label
            offset = height_increment * (max_plots - k)

            if self.is_bit(signal):
                self.plot_bit_signal(x, y, label, offset)
            elif self.is_integer(signal):
                self.plot_integer_signal(signal, clock_signal, label, offset)

    def plot_bit_signal(self, x, y, label, offset):
        int_y = [int(value) + offset for value in y]
        self.axis.plot(x, int_y, color='green', linewidth=2, drawstyle='steps-post')
        self.axis.fill_between(x, offset, int_y, step='post', color='green', alpha=0.3)
        self.axis.text(-2*len(label) - 10, offset + 0.5, label, va='center', ha='left')

    def plot_integer_signal(self, signal, clock_signal: SignalClass, label, offset):
        x = [timestamp / TIME_SCALE for timestamp in signal.binary_timestamps][:TIME_MAX_LIMIT]
        y = signal.binary_values[:TIME_MAX_LIMIT]
        x_clock = [timestamp / TIME_SCALE for timestamp in clock_signal.interpoled_timestamps]
        x_clock = x_clock[:TIME_MAX_LIMIT]
        x.append(x_clock[-1])
        y.append(y[-1])
        int_y = [int(value) + offset for value in y]
        text_y = [str(value) for value in y]
        delta = 0.025

        for i in range(len(x) - 1):
            x_i = [x[i], x[i] + delta, x[i] + 50*delta, x[i+1] - 50*delta, x[i+1] - delta, x[i+1]]
            top = offset + 0.7 * height_increment
            middle = offset + 0.35 * height_increment
            bottom = offset
            y_top_i = [middle, middle, bottom, bottom, middle, middle]
            y_bottom_i = [middle, middle, top, top, middle, middle]
            text_i = self.abbreviate_number(text_y[i])

            self.axis.plot(x_i, y_top_i, color='green', linewidth=2)
            self.axis.plot(x_i, y_bottom_i, color='green', linewidth=2)
            mid_x = (x[i] + x[i+1]) / 2
            min_y = offset + 0.35 * height_increment
            if(mid_x < x[-1] + 1):
                self.axis.text(mid_x, min_y, text_i, va='center', ha='center', fontsize=8, bbox=dict(facecolor='white', edgecolor='none', pad=5))
        self.axis.text(-2*len(label) - 10, offset + 0.7, label, va='center', ha='left')

    def render(self) -> None:
        max_plots = 8

        clock_signal = next((item for item in self.signals if item.name == 'clk'), None)
        x_clock = [timestamp / TIME_SCALE for timestamp in clock_signal.interpoled_timestamps][:TIME_MAX_LIMIT]

        for i in range(0, len(x_clock), 2):
            self.axis.axvline(x=x_clock[i], color='darkgrey', linestyle='--', alpha=0.25)

        self.plot_zero_signals(clock_signal, max_plots)
        self.plot_signals(clock_signal, max_plots)

        last_x_clock = x_clock[-1]
        if last_x_clock is not None:
            self.axis.axvline(x=last_x_clock, color='red', linestyle='--', alpha=0.7)
            self.axis.text(last_x_clock + 2, -1, str(int(last_x_clock)), color='black', va='bottom', ha='right')

        self.axis.set_title(self.title)
        self.axis.set_xlabel(self.xLabel)
        self.axis.set_ylabel(self.yLabel)
        self.axis.set_yticks([0, max_plots * height_increment])
        self.axis.set_xlim([x_clock[0], x_clock[-1]])
        self.axis.set_yticklabels([])

        plt.subplots_adjust(left=0.3)
        self.axis.grid(True, axis='x')

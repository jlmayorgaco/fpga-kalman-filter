import json
import matplotlib.pyplot as plt

from typing import List
from typing import Optional

from matplotlib.patches import Rectangle
from pyDigitalWaveTools.vcd.parser import VcdParser


class SignalClass:
    def __init__(self):

        self.name = ''
        self.label = ''
        self.type = 'bit'

        self.clk_timestamps = []

        self.binary_time_milliseconds = []
        self.binary_timestamps = []
        self.binary_values = []

        self.interpoled_timestamps = []
        self.interpoled_values = []

    def __repr__(self):

        return f'SignalClass(name={self.name})'

    def setName(self, name):
        self.name = name

    def setType(self, signalType):
        self.type = signalType

    def setLabel(self, label):
        self.label = label

    def setClock(self, clock_signal):
        clock_timestamps = [point[0] for point in clock_signal['data']]
        self.clk_timestamps = clock_timestamps

    def setData(self, data):
        timestamps, time_milliseconds, binary_values = self.getTimestampsAndValues(data)
        self.binary_values = binary_values
        self.binary_timestamps = timestamps
        self.binary_time_milliseconds = time_milliseconds
        y_binary_values_interpolated = self.getInterpolateSignal(self.clk_timestamps, self.binary_timestamps, self.binary_values)
        y_decimal_values = [self.convert_to_int(binary_value) for binary_value in y_binary_values_interpolated]
        self.interpoled_timestamps = self.binary_time_milliseconds
        self.interpoled_values = y_decimal_values

    def getTimestampsAndValues(self, signal_data):
        binary_values = [point[1] for point in signal_data['data']]
        timestamps = [point[0] for point in signal_data['data']]
        time_seconds = [time / 1e12 for time in timestamps]
        time_milliseconds = [time * 1000 for time in time_seconds]
        return timestamps, time_milliseconds, binary_values

    def getInterpolateSignal(self, clk_timestamps, dist_timestamps, dist_binary_values):
        dist_binary_values_interpolated = []
        k = 0
        for i in range(len(clk_timestamps)):
            if k == len(dist_timestamps) - 1 or clk_timestamps[i] <= dist_timestamps[k + 1]:
                dist_binary_values_interpolated.append(dist_binary_values[k])
            else:
                k += 1
                if k < len(dist_timestamps):
                    dist_binary_values_interpolated.append(dist_binary_values[k])
                else:
                    break
        return dist_binary_values_interpolated

    @staticmethod
    def convert_to_int(binary_string):
        if binary_string.startswith('b'):
            binary_string = binary_string[1:]  # Remove the 'b' prefix
        if len(binary_string) == 32:  # Check if it represents a signed integer
            if binary_string[0] == '1':  # If it's negative
                # Compute the two's complement
                binary_string = ''.join(['1' if b == '0' else '0' for b in binary_string])
                return -int(binary_string, 2) - 1
            else:  # If it's positive
                return int(binary_string, 2)
        else:  # If it doesn't represent a signed integer, treat it as positive
            return int(binary_string, 2)

class VCDSignalsClass:

    def __init__(self ):
        #  Input Output
        self.input_file = ''
        self.output_file = ''

        #  Signals
        self.module = ''
        self.signals = []

        #  VCD Data
        self.vcd_data = None

    def setFileVCD(self, file_path) -> None :
        self.input_file = file_path

    def setFileJSON(self, file_path) -> None :
        self.output_file = file_path

    def setModuleName(self, moduleName) -> None :
        self.module = moduleName

    def addSignalByName(self, signalName) -> None :
        signal = SignalClass()
        signal.setName(signalName)
        self.signals.append(signal)

    def getSignalByName(self, signal_name: str) -> Optional[SignalClass]:
        print( self.signals )
        for signal in self.signals:
            if signal.name == signal_name:
                return signal
        return None

    def getSignals(self) -> List[SignalClass]:
        return self.signals

    def parse_vcd_file(self):
        with open(self.input_file) as vcd_file:
            vcd = VcdParser()
            vcd.parse(vcd_file)
            self.vcd_data = vcd.scope.toJson()

    def write_json_output(self):
        json_data = json.dumps(self.vcd_data, indent=4, sort_keys=True)
        with open(self.output_file, 'w') as outfile:
            outfile.write(json_data)

    def extract_signals(self):

        module_name = self.module
        module_signals = next((item for item in self.vcd_data['children'] if item['name'] == module_name), None)
        clock = next((item for item in module_signals['children'] if item['name'] == 'clk'), None)

        signal = SignalClass()
        signal.setName(clock['name'])
        signal.setClock(clock)
        signal.setData(clock)
        self.signals.append(signal)

        for item in module_signals['children']:
            if item['name'] != 'clk' and not item.get('children'):
                signal = SignalClass()
                signal.setName(item['name'])
                signal.setClock(clock)
                signal.setData(item)
                self.signals.append(signal)

    def start(self) -> None:
        self.parse_vcd_file()
        self.extract_signals()


class VCDSignalsClass2:
    SCALE_VALUE = 8192

    def __init__(self, input_file, output_file):
        self.input_file = input_file
        self.output_file = output_file
        self.vcd_data = None
        self.main_tb = None
        self.clk_data = None
        self.rst_data = None
        self.y_data = None

    @staticmethod
    def convert_to_int(binary_string):
        if binary_string.startswith('b'):
            binary_string = binary_string[1:]  # Remove the 'b' prefix
        if len(binary_string) == 32:  # Check if it represents a signed integer
            if binary_string[0] == '1':  # If it's negative
                # Compute the two's complement
                binary_string = ''.join(['1' if b == '0' else '0' for b in binary_string])
                return -int(binary_string, 2) - 1
            else:  # If it's positive
                return int(binary_string, 2)
        else:  # If it doesn't represent a signed integer, treat it as positive
            return int(binary_string, 2)

    def parse_vcd_file(self):
        with open(self.input_file) as vcd_file:
            vcd = VcdParser()
            vcd.parse(vcd_file)
            self.vcd_data = vcd.scope.toJson()

    def write_json_output(self):
        json_data = json.dumps(self.vcd_data, indent=4, sort_keys=True)
        with open(self.output_file, 'w') as outfile:
            outfile.write(json_data)

    def extract_signals(self):
        self.main_tb = next((item for item in self.vcd_data['children'] if item['name'] == 'up_counter_16bit_tb'), None)
        self.clk_data = next((item for item in self.main_tb['children'] if item['name'] == 'clk'), None)
        self.rst_data = next((item for item in self.main_tb['children'] if item['name'] == 'reset'), None)
        self.y_data = next((item for item in self.main_tb['children'] if item['name'] == 'count[15:0]'), None)

    def get_timestamps_and_values(self, signal_data):
        binary_values = [point[1] for point in signal_data['data']]
        timestamps = [point[0] for point in signal_data['data']]
        time_seconds = [time / 1e12 for time in timestamps]
        time_milliseconds = [time * 1000 for time in time_seconds]
        return timestamps, time_milliseconds, binary_values

    def interpolate_signal(self, clk_timestamps, dist_timestamps, dist_binary_values):
        dist_binary_values_interpolated = []
        k = 0

        for i in range(len(clk_timestamps)):
            if k == len(dist_timestamps) - 1 or clk_timestamps[i] <= dist_timestamps[k + 1]:
                dist_binary_values_interpolated.append(dist_binary_values[k])
            else:
                k += 1
                if k < len(dist_timestamps):
                    dist_binary_values_interpolated.append(dist_binary_values[k])
                else:
                    break

        return dist_binary_values_interpolated

    def plot_1_bit_signal(self, ax, offset, time_milliseconds, binary_values, label):
        signal = [int(value) + offset for value in binary_values]  # Adjust each signal's y-value
        ax.plot(time_milliseconds, signal, color='green', linewidth=2, drawstyle='steps-post')
        ax.fill_between(time_milliseconds, offset, signal, step='post', color='green', alpha=0.3)
        ax.text(-0.0095, offset + 0.5, label, va='center', ha='left')

    def plot_signals(self):
        clk_timestamps, clk_time_milliseconds, clk_binary_values = self.get_timestamps_and_values(self.clk_data)
        rst_timestamps, rst_time_milliseconds, rst_binary_values = self.get_timestamps_and_values(self.rst_data)
        y_timestamps, y_time_milliseconds, y_binary_values = self.get_timestamps_and_values(self.y_data)

        y_binary_values_interpolated = self.interpolate_signal(clk_timestamps, y_timestamps, y_binary_values)
        y_decimal_values = [self.convert_to_int(binary_value[1:]) for binary_value in y_binary_values_interpolated]

        fig, axs = plt.subplots(2, 2, figsize=(11, 6))
        fig.patch.set_linewidth(2)
        fig.patch.set_edgecolor('black')

        axs[0, 0].axis('off')
        rect = Rectangle((0, 0), 1, 1, fill=False, edgecolor='black', linewidth=2, transform=axs[0, 0].transAxes)
        axs[0, 0].add_patch(rect)

        axs[0, 1].plot(clk_timestamps, y_decimal_values, label='Filtered Noise Signal (y)', linestyle='-', color='green', linewidth=2, drawstyle='steps-post')
        axs[0, 1].set_xlabel('Time (ms)')
        axs[0, 1].set_ylabel('Value (ADC) 32 Bits')
        axs[0, 1].set_title('Input and Output Signals (First Half)')
        axs[0, 1].legend()
        axs[0, 1].grid(True)

        axs[1, 0].remove()
        axs[1, 1].remove()
        ax_horizontal = fig.add_subplot(2, 1, 2)

        self.plot_1_bit_signal(ax_horizontal, 0, clk_time_milliseconds, clk_binary_values, 'clk')
        self.plot_1_bit_signal(ax_horizontal, 1.5, rst_time_milliseconds, rst_binary_values, 'rst')

        ax_horizontal.set_xlabel('Time (ms)')
        ax_horizontal.set_yticks([])
        ax_horizontal.grid(True, axis='x')

        for i in range(0, len(clk_time_milliseconds), 2):
            ax_horizontal.axvline(x=clk_time_milliseconds[i], color='gray', linestyle='--', alpha=0.5)

        margin = 1
        outer_border = Rectangle((0, 0), 1, 1, linewidth=1.5, edgecolor='black', facecolor='none', transform=fig.transFigure)
        fig.patches.extend([outer_border])
        outer_border.set_bounds(margin / fig.bbox.width, margin / fig.bbox.height, 1 - 2 * margin / fig.bbox.width, 1 - 2 * margin / fig.bbox.height)

        fig.tight_layout(pad=1.0)
        plt.subplots_adjust(left=0.05, right=0.95, top=0.935, bottom=0.085, wspace=0.25, hspace=0.25)
        plt.savefig('main_wave_plot.svg', format='svg', bbox_inches='tight', pad_inches=0.25)
        plt.savefig('main_wave_plot.png', format='png', bbox_inches='tight', pad_inches=0.25)
        plt.show()

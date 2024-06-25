import json
from matplotlib.patches import Rectangle
import matplotlib.pyplot as plt
from pyDigitalWaveTools.vcd.parser import VcdParser

fname = 'p0_counter_16bits_wave.vcd'
output_file = 'output.json'
SCALE_VALUE = 8192

# Define a function to convert signed binary string to integer
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

with open(fname) as vcd_file:
    vcd = VcdParser()
    vcd.parse(vcd_file)
    data = vcd.scope.toJson()

    # Convert data to JSON string
    json_data = json.dumps(data, indent=4, sort_keys=True)

    # Write JSON string to a file
    with open(output_file, 'w') as outfile:
        outfile.write(json_data)

    json_main_tb = next((item for item in data['children'] if item['name'] == 'up_counter_16bit_tb'), None)
    json_main_tb___clk_tb = next((item for item in json_main_tb['children'] if item['name'] == 'clk'), None)
    json_main_tb___rst_tb = next((item for item in json_main_tb['children'] if item['name'] == 'reset'), None)
    json_main_tb___y_tb = next((item for item in json_main_tb['children'] if item['name'] == 'count[15:0]'), None)

    # Extract timestamps and binary values from json_main_tb___y_tb and tb___u_tb
    clk_binary_values = [point[1] for point in json_main_tb___clk_tb['data']]
    clk_timestamps = [point[0] for point in json_main_tb___clk_tb['data']]
    clk_time_seconds = [time / 1e12 for time in clk_timestamps]
    clk_time_milliseconds = [time * 1000 for time in clk_time_seconds]

    y_binary_values = [point[1] for point in json_main_tb___y_tb['data']]

    y_timestamps = [point[0] for point in json_main_tb___y_tb['data']]
    y_time_seconds = [time / 1e12 for time in y_timestamps]

    # Interpolate missing values in u_binary_values to match the length of other arrays
    y_binary_values_interpolated = []

    def interpolate_signal(clk_timestamps, dist_timestamps, dist_binary_values):
        dist_binary_values_interpolated = []

        k = 0
        t_dist_k = dist_timestamps[k]
        y_dist_k = dist_binary_values[k]

        for i in range(len(clk_timestamps)):
            t_clk_i = clk_timestamps[i]
            if k == (len(dist_timestamps) - 1) or t_clk_i <= dist_timestamps[k + 1]:
                dist_binary_values_interpolated.append(y_dist_k)
            else:
                k += 1
                if k < len(dist_timestamps):
                    t_dist_k = dist_timestamps[k]
                    y_dist_k = dist_binary_values[k]
                    dist_binary_values_interpolated.append(y_dist_k)
                else:
                    # Handle the case when k exceeds the length of dist_timestamps
                    # Perhaps break out of the loop or handle the situation accordingly
                    pass

        return dist_binary_values_interpolated

    y_binary_values_interpolated = interpolate_signal(clk_timestamps, y_timestamps, y_binary_values)

    # Parse binary values to decimal integers
    y_decimal_values = [convert_to_int(binary_value[1:]) for binary_value in y_binary_values_interpolated]

    # Plotting
    fig, axs = plt.subplots(2, 2, figsize=(11, 6))  # Create a 2x2 grid of subplots

    fig.patch.set_linewidth(2)
    fig.patch.set_edgecolor('black')

    # Leave the top-left subplot empty
    axs[0, 0].axis('off')
    rect = Rectangle((0, 0), 1, 1, fill=False, edgecolor='black', linewidth=2, transform=axs[0, 0].transAxes)
    axs[0, 0].add_patch(rect)

    # Plot the existing chart in the top-right subplot
    axs[0, 1].plot(clk_timestamps,
                   y_decimal_values,
                   label='Filtered Noise Signal (y)',
                   linestyle='-',
                   color='green',
                   linewidth=2,
                   drawstyle='steps-post')

    axs[0, 1].set_xlabel('Time (ms)')
    axs[0, 1].set_ylabel('Value (ADC) 32 Bits')
    axs[0, 1].set_title('Input and Output Signals (First Half)')
    axs[0, 1].legend()
    axs[0, 1].grid(True)

    # Plot multiple clk signals in the bottom subplot
    axs[1, 0].remove()  # Remove the bottom-left subplot
    axs[1, 1].remove()  # Remove the bottom-right subplot
    ax_horizontal = fig.add_subplot(2, 1, 2)  # Create a new subplot spanning the bottom row

    num_signals = 8
    labels = [f'clk {i}' for i in range(1, num_signals + 1)]
    vertical_space = 0.5  # Adjust this value to control the space between signals

    for i in range(num_signals):
        offset = i * (1 + vertical_space)  # Offset each signal vertically with additional space
        signal = [int(value) + offset for value in clk_binary_values]  # Adjust each signal's y-value
        ax_horizontal.plot(clk_time_milliseconds,
                           signal,
                           color='green',
                           linewidth=2,
                           drawstyle='steps-post')
        ax_horizontal.fill_between(clk_time_milliseconds,
                                   offset,
                                   signal,
                                   step='post',
                                   color='green',
                                   alpha=0.3)
        ax_horizontal.text(-0.0095, offset + 0.5 , labels[i], va='center', ha='left')

    ax_horizontal.set_xlabel('Time (ms)')
    #ax_horizontal.set_ylabel('Clock Signals')
    #ax_horizontal.set_title('Clock Signals (clk)')
    ax_horizontal.set_yticks([])
    ax_horizontal.grid(True, axis='x')

    # Add dotted semi-transparent vertical lines every 2 clock cycles
    for i in range(0, len(clk_time_milliseconds), 2):
        ax_horizontal.axvline(x=clk_time_milliseconds[i],
                              color='gray',
                              linestyle='--',
                              alpha=0.5)

    # Create a rectangle patch for the outer border with a margin of 10px
    margin = 1
    outer_border = Rectangle((0, 0), 1, 1, linewidth=1.5, edgecolor='black', facecolor='none', transform=fig.transFigure)
    fig.patches.extend([outer_border])
    outer_border.set_bounds(margin / fig.bbox.width, margin / fig.bbox.height,
                            1 - 2 * margin / fig.bbox.width, 1 - 2 * margin / fig.bbox.height)

    fig.tight_layout(pad=1.0)  # Adjust layout to prevent overlap
    # Add a margin around the figure with a 1px solid black border
    plt.subplots_adjust(left=0.05, right=0.95, top=0.935, bottom=0.085, wspace=0.25, hspace=0.25)
    plt.savefig('main_wave_plot.svg', format='svg', bbox_inches='tight', pad_inches=0.25)  # Save svg file with tight bounding box
    plt.savefig('main_wave_plot.png', format='png', bbox_inches='tight', pad_inches=0.25)  # Save png file with tight bounding box
    plt.show()

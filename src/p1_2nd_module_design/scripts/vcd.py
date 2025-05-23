import json
import sys
import matplotlib.pyplot as plt
from pyDigitalWaveTools.vcd.parser import VcdParser


fname = 'test/main_wave.vcd'
output_file = 'output.json'  # Specify the output file name here
SCALE_VALUE = 8192

with open(fname) as vcd_file:
    vcd = VcdParser()
    vcd.parse(vcd_file)
    data = vcd.scope.toJson()

    # Convert data to JSON string
    json_data = json.dumps(data, indent=4, sort_keys=True)

    # Write JSON string to a file
    with open(output_file, 'w') as outfile:
        outfile.write(json_data)

    json_main_tb = next((item for item in data['children'] if item['name'] == 'main_tb'), None)
    json_main_tb___clk_tb = next((item for item in json_main_tb['children'] if item['name'] == 'clk_tb'), None)
    json_main_tb___rst_tb = next((item for item in json_main_tb['children'] if item['name'] == 'rst_tb'), None)
    json_main_tb___u_tb = next((item for item in json_main_tb['children'] if item['name'] == 'u_tb'), None)
    json_main_tb___y_tb = next((item for item in json_main_tb['children'] if item['name'] == 'y_tb'), None)

    # Extract timestamps and binary values from json_main_tb___y_tb and tb___u_tb
    clk_binary_values = [point[1] for point in json_main_tb___clk_tb['data']]
    clk_timestamps = [point[0] for point in json_main_tb___clk_tb['data']]
    clk_time_seconds = [time / 1e15 for time in clk_timestamps]
    clk_time_microseconds = [time * 1000000 for time in clk_time_seconds]

    u_binary_values = [point[1] for point in json_main_tb___u_tb['data']]
    u_timestamps = [point[0] for point in json_main_tb___u_tb['data']]
    u_time_seconds = [time / 1e15 for time in u_timestamps]

    y_binary_values = [point[1] for point in json_main_tb___y_tb['data']]
    y_timestamps = [point[0] for point in json_main_tb___y_tb['data']]
    y_time_seconds = [time / 1e15 for time in y_timestamps]

    # Interpolate missing values in u_binary_values to match the length of other arrays
    u_binary_values_interpolated = []
    y_binary_values_interpolated = []
    for i in range(len(clk_binary_values)):

        if i < len(u_binary_values):
            u_binary_values_interpolated.append(u_binary_values[i])
        else:
            u_binary_values_interpolated.append(u_binary_values[-1])

        if i < len(y_binary_values):
            y_binary_values_interpolated.append(y_binary_values[i])
        else:
            y_binary_values_interpolated.append(y_binary_values[-1])


    # Parse binary values to decimal integers
    u_decimal_values = [int(binary_value[1:], 2) for binary_value in u_binary_values_interpolated]
    y_decimal_values = [int(binary_value[1:], 2) for binary_value in y_binary_values_interpolated]

    # Plotting
    fig, axs = plt.subplots(1, 1, figsize=(8, 6))  # Adjusted figure size for better aspect ratio

    # Plotting clk_seconds vs u
    axs.plot(clk_time_microseconds, u_decimal_values, label='Input Signal (u)', linestyle='-', color='blue', linewidth=2, drawstyle='steps-post')

    # Plotting clk_seconds vs y
    axs.plot(clk_time_microseconds, y_decimal_values, label='Output Signal (y)', linestyle='-', color='red', linewidth=2, drawstyle='steps-post')

    axs.set_xlabel('Time ($\mu$s)')  # Using LaTeX for µ symbol
    axs.set_ylabel('Value (ADC)')  # Updated ylabel
    axs.set_title('Input and Output Signals')  # Updated title
    axs.legend()
    axs.grid(True)

    # Set y-axis limits
    axs.set_ylim(0, 10000)

    # Adjust tick labels for better readability
    plt.xticks(fontsize=10)
    plt.yticks(fontsize=10)

    plt.tight_layout()  # Adjust layout to prevent overlap
    plt.savefig('test/main_wave_plot.svg', format='svg')  # Save svg file
    plt.show()

    #json_main_tb = json.children.find(item => item.name == "main_tb")
    #json_main_tb___clk_tb = json_main_tb.children.find(item => item.name == "clk_tb")
    #json_main_tb___rst_tb = json_main_tb.children.find(item => item.name == "rst_tb")
    #json_main_tb___u_tb = json_main_tb.children.find(item => item.name == "u_tb")
    #json_main_tb___y_tb = json_main_tb.children.find(item => item.name == "y_tb")
    #json_main_tb___y_tb model is : { name: "y_tb", type: { name: "integer", width: 32}, data: [ [0, 'b0'], [80000000, 'b11'], .... , [ 5280000000, "b110011010111"] ]}
    
    # I want to plot the time data for u(t) and y(t) in real plot , also I want to plot in a wave graph with clock, rst, u and y in hex like gtkwave

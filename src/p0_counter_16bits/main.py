import matplotlib.pyplot as plt

def get_next_line_after_keyword(file, keyword):
    for line in file:
        if line.startswith(keyword):
            return next(file).strip()  # Return the next line after the keyword

def get_vcd_date(vcd_file):
    with open(vcd_file, 'r') as file:
        return get_next_line_after_keyword(file, '$date')

def get_vcd_version(vcd_file):
    with open(vcd_file, 'r') as file:
        return get_next_line_after_keyword(file, '$version')

def get_vcd_timescale(vcd_file):
    with open(vcd_file, 'r') as file:
        return get_next_line_after_keyword(file, '$timescale')

def get_vcd_signals(vcd_file):

    signal_time = []
    signal_clock = []
    signal_reset = []
    signal_counter = []

    with open(vcd_file, 'r') as file:
        lines = file.readlines()

    k_0 = 0
    for index, line in enumerate(lines):
        if line.startswith('$enddefinitions'):
            k_0 = index + 2
            break

    for line in lines[k_0:]:
        if line.startswith('#'):
            _line = line + ''
            _time_fs = int(_line.strip().lstrip('#'))
            signal_time.append(_time_fs)
        if line.endswith('!'):
            signal_clock.append(line)
        if line.endswith('"'):
            signal_reset.append(line)

        if line.startswith('b') and '#' in line:
            print(' ')

            _line = line + ''
            print(' _line ')
            print(_line)

            binary_str = _line.split()[0][1:]  # Extract the binary string between 'b' and '#'
            print(' binary_str ')
            print(binary_str)

            binary_int = int(binary_str, 2)  # Convert the binary string to an integer
            print(' binary_int ')
            print(binary_int)

            print(' ')
            signal_counter.append(binary_int)

    return signal_time, signal_clock, signal_reset, signal_counter

vcd_file = 'p0_counter_16bits_wave.vcd'

__vcd_date = get_vcd_date(vcd_file)
__vcd_version = get_vcd_version(vcd_file)
__vcd_timescale = get_vcd_timescale(vcd_file)

vcd_file = 'p0_counter_16bits_wave.vcd'
time_fs, clock, reset, counter_integer = get_vcd_signals(vcd_file)

time_seconds = [time / 1e15 for time in time_fs]


new_counter_integer = []
new_counter_integer.append(0)
new_counter_integer.append(0)
new_counter_integer.append(0)

for i in range(len(counter_integer)):
    new_counter_integer.append(counter_integer[i])
    new_counter_integer.append(counter_integer[i])

# Plot the data
plt.plot(time_seconds, new_counter_integer)

# Add labels and title
plt.xlabel('Time (seconds)')
plt.ylabel('Counter Integer Value')
plt.title('Counter Integer Value vs Time')
plt.grid(True)

# Show the plot
plt.show()
print(counter_integer)
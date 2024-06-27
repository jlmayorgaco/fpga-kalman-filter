import numpy as np
import matplotlib.pyplot as plt

# Parameters
sampling_freq = 10000  # Sampling frequency (Hz)
total_time = 0.525  # Total simulation time (seconds)
time = np.linspace(0, total_time, int(total_time * sampling_freq), endpoint=False)

# Function to generate AC signal with variable frequency
def generate_ac_signal(time, base_freq_pattern):
    signal = np.zeros_like(time)
    for i in range(len(time)):
        signal[i] = np.sin(2 * np.pi * base_freq_pattern[i] * time[i])
    return signal

# Function to estimate frequency using zero-crossing detection
def estimate_frequency(t, y, window_size=10):
    def zero_crossings(data):
        """Detect indices where zero-crossing occurs"""
        zero_cross_idx = np.where(np.diff(np.sign(data)))[0]
        return zero_cross_idx

    # List to store frequency estimates
    f_ = []

    # Initialize a sliding window for averaging frequency estimates
    window = []

    for i in range(len(t)):
        # Append current value to the window
        window.append((t[i], y[i]))

        # Ensure the window does not exceed the specified size
        if len(window) > window_size:
            window.pop(0)

        # Extract time and signal values from the window
        t_window = np.array([w[0] for w in window])
        y_window = np.array([w[1] for w in window])

        # Detect zero-crossings within the window
        zero_cross_idx = zero_crossings(y_window)

        if len(zero_cross_idx) > 1:
            # Calculate periods between consecutive zero-crossings
            periods = np.diff(t_window[zero_cross_idx])

            if len(periods) > 0:
                # Average period and calculate frequency
                avg_period = np.mean(periods)
                f_k = 1.0 / avg_period
            else:
                f_k = f_[-1] if f_ else 0.0
        else:
            # Default frequency if not enough zero-crossings are detected
            f_k = f_[-1] if f_ else 0.0

        # Append the estimated frequency
        f_.append(5 * 1000 * f_k / sampling_freq)

    return t , f_

# Base frequency pattern (Hz)
base_freq_pattern = np.zeros_like(time)
fault_time_end = total_time / 3
transition_time_end = 2 * total_time / 3

# Define frequency pattern
base_freq_pattern[0:int(fault_time_end * sampling_freq)] = 50.0
base_freq_pattern[int(fault_time_end * sampling_freq):int(transition_time_end * sampling_freq)] = 55.0
base_freq_pattern[int(transition_time_end * sampling_freq):] = 50.0

# Generate AC signal with variable frequency pattern
ac_signal = generate_ac_signal(time, base_freq_pattern)

# Estimate frequency using zero-crossing detection
freq_time, estimated_freq = estimate_frequency(time, ac_signal, 500)

# Plot AC signal with colored backgrounds for different frequency ranges
plt.figure(figsize=(10, 8))

# Plot AC signal
plt.subplot(2, 1, 1)
plt.plot(time, ac_signal, label="AC Signal with Frequency Change", color='blue')
plt.fill_between(time, -1, 1, where=(base_freq_pattern == 50.0), color='lightgreen', alpha=0.3, label='50 Hz Region')
plt.fill_between(time, -1, 1, where=(base_freq_pattern == 55.0), color='lightcoral', alpha=0.3, label='55 Hz Region')
plt.title('AC Signal with Frequency Change')
plt.xlabel('Time (s)')
plt.ylabel('Amplitude')
plt.grid(True)
plt.legend()

# Plot actual and estimated frequency
plt.subplot(2, 1, 2)
plt.plot(time, base_freq_pattern, '--', label='Actual Frequency', color='green')
plt.plot(freq_time, estimated_freq, color='red', label='Estimated Frequency')
plt.title('Actual vs. Estimated Frequency over Time')
plt.xlabel('Time (s)')
plt.ylabel('Frequency (Hz)')
plt.grid(True)
plt.legend()

plt.tight_layout()
plt.show()

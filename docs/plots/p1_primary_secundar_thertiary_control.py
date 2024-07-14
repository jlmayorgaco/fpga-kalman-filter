import numpy as np
import matplotlib.pyplot as plt

# Parameters for the sine wave
f = 50  # Frequency of the sine wave (Hz)
A = 120  # Amplitude of the sine wave
t = np.linspace(0, 5, 1000)  # Time vector (0 to 5 seconds)

# Generate the sine wave
y = A * np.sin((f / (2 * np.pi)) * t)

# Initialize the simulation array
y_sim = np.zeros_like(t)

# Simulate the sine wave
for k in range(1, len(t)):
    if(t[k] > 1 and t[k] < 2) :
        dt = t[k] - t[k - 1]
        dy_k = (f / (1.5 * np.pi))*A * np.sin( (1.5*f / (2 * np.pi)) * (t[k] - np.pi))
        y_sim[k] = y_sim[k - 1] + dy_k * dt
    else :
        dt = t[k] - t[k - 1]
        dy_k = (f / (2 * np.pi))*A * np.sin( (f / (2 * np.pi)) * (t[k] - np.pi))
        y_sim[k] = y_sim[k - 1] + dy_k * dt

for k in range(1, len(t)):
    y_sim[k] = y_sim[k] - A

# Plotting parameters for IEEE style plot
plt.figure(figsize=(8, 6))
plt.plot(t, y, label='Original Signal', linewidth=2)
plt.plot(t, y_sim, label='Simulation', linestyle='--', color='green')

# Adjusting plot parameters
plt.title('IEEE Style Plot: Sinusoidal Wave Simulation')
plt.xlabel('Time (s)')
plt.ylabel('Amplitude')
plt.grid(True)
plt.legend()
plt.tight_layout()

# Display the plot
plt.show()

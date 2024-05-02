import math
import control
import numpy as np
import matplotlib.pyplot as plt

def get_second_order_params_zeta(tp, ts):
    top = 4*tp
    bottom = math.pow(math.pi, 2) * math.pow(ts, 2) + 16 * math.pow(tp, 2)
    return top/math.sqrt(bottom)

def get_second_order_params_wn(tp, ts):
    top = math.pow(math.pi, 2) * math.pow(ts, 2) + 16 * math.pow(tp, 2)
    bottom = ts*tp
    return math.sqrt(top) / bottom


tp = 1
ts = 2

zeta = get_second_order_params_zeta(tp, ts)
wn = get_second_order_params_wn(tp, ts)

print('zeta:', zeta)
print('wn:', wn)

# Define parameters
scale_factor = 1024  # Scale factor

#wn = int(wn * scale_factor)  # Natural frequency (scaled)
#zeta =  int(zeta * scale_factor)  # Damping ratio (scaled)


print('zeta_d:', zeta)
print('wn_d:', wn)

# Sampling time
Ts = 0.01  # Adjust as needed
dTS = int(1/Ts)

# Simulation time
t = np.arange(0, 10, Ts)

# Initialize state variables (scaled)
x = 0
dxdt = 0

# Input signal (step from 0 to 1 at t=1)
u = np.zeros_like(t)
u[int(1 / Ts):] = scale_factor

# Output signal
y = []

# Simulate the system using Euler's method
for i in range(len(t)):
    # Compute derivatives (scaled)

    print('2 * zeta * wn * dxdt:', 2 * zeta * wn * dxdt)
    print('wn**2 * x:', wn**2 * x)

    d2xdt2 = u[i] - 2 * zeta * wn * dxdt - wn**2 * x
    dxdt = dxdt + (d2xdt2 * Ts)
    x = x + (dxdt * Ts)
    
    # Store output (scaled)
    y.append(x)

# Convert output to actual values
y_actual = np.array(y) / scale_factor

# Plot results
plt.plot(t, y_actual)
plt.xlabel('Time')
plt.ylabel('Output')
plt.title('Step Response of Numerically Simulated Second-Order System (Fixed-Point Arithmetic)')
plt.grid(True)
plt.show()

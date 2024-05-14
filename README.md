# FPGA Kalman Filter Project

Welcome to the FPGA Kalman Filter Project repository! This project aims to explore the implementation of Kalman filtering algorithms on FPGA platforms, along with simulations and comparisons with other platforms such as microcontrollers and Raspberry Pi. The main goal is to investigate the performance of Kalman filters in various applications and compare different architectures.
Table of Contents

    Introduction
    Project Overview
    Repository Structure
    Experiments
        Environment Setup and Basic Counter
        Dynamical System Simulations
        Kalman Filter Simulations
        Capstone Applications
    Paper Writing
    Conference Papers
    Contributing
    License

Introduction

Kalman filtering is a powerful estimation algorithm used in a wide range of applications, including navigation, robotics, and signal processing. By combining measurements from sensors with predictions from a dynamic model, Kalman filters provide accurate estimates of system states even in the presence of noise and uncertainty.

This project explores the implementation of Kalman filters on FPGA platforms, aiming to investigate their performance and suitability for real-time applications. By simulating various dynamical systems and comparing different Kalman filter architectures, we aim to understand their strengths and weaknesses and explore potential applications in areas such as drone navigation and power system estimation.
Project Overview

Setting Up

pip install pyvcd


ghdl -a full_adder.vhd
ghdl -a full_adder_testbench.vhd
ghdl -r full_adder_testbench --vcd=wave.vcd


The project consists of several components, including:

    Setting up the VHDL simulation environment and creating basic counters.
    Simulating the step response of linear dynamical systems and introducing random noise.
    Designing feedback loop controllers using Proportional-Integral-Derivative (PID) algorithms.
    Implementing Kalman filters of different orders and architectures.
    Simulating extended Kalman filters and exploring distributed Kalman filtering approaches.
    Applying Kalman filtering to real-world applications such as drone sensor fusion and power system estimation.

Repository Structure

graphql

fpga-kalman-filter/
│
├── src/                  # VHDL source files
│   ├── counter.vhd       # Basic counter module
│   ├── dynamical_systems/
│   │   ├── step_response.vhd    # Step response simulation
│   │   ├── noise_generator.vhd  # Random noise generator
│   │   ├── pid_controller.vhd   # PID feedback controller
│   │   ├── state_space_model.vhd    # 3rd order state space model
│   │   └── ...
│   ├── kalman_filters/
│   │   ├── kalman_filter_2nd_order.vhd   # 2nd order Kalman filter
│   │   ├── state_space_kalman_filter.vhd # State space Kalman filter
│   │   ├── extended_kalman_filter.vhd    # Extended Kalman filter
│   │   ├── distributed_kalman_filter.vhd # Distributed Kalman filter
│   │   └── ...
│   ├── applications/
│   │   ├── imu_sensor_fusion.vhd    # Drone IMU sensor fusion
│   │   ├── power_system_estimator.vhd   # Power system estimator
│   │   └── ...
│   └── ...
│
├── testbenches/          # Testbench files
│   ├── counter_tb.vhd    # Testbench for counter module
│   ├── dynamical_systems/
│   │   ├── step_response_tb.vhd    # Testbench for step response simulation
│   │   ├── noise_generator_tb.vhd  # Testbench for noise generator
│   │   ├── pid_controller_tb.vhd   # Testbench for PID controller
│   │   ├── state_space_model_tb.vhd    # Testbench for state space model
│   │   └── ...
│   ├── kalman_filters/
│   │   ├── kalman_filter_2nd_order_tb.vhd   # Testbench for 2nd order Kalman filter
│   │   ├── state_space_kalman_filter_tb.vhd # Testbench for state space Kalman filter
│   │   ├── extended_kalman_filter_tb.vhd    # Testbench for Extended Kalman filter
│   │   ├── distributed_kalman_filter_tb.vhd # Testbench for Distributed Kalman filter
│   │   └── ...
│   ├── applications/
│   │   ├── imu_sensor_fusion_tb.vhd    # Testbench for drone IMU sensor fusion
│   │   ├── power_system_estimator_tb.vhd   # Testbench for power system estimator
│   │   └── ...
│   └── ...
│
├── simulations/          # Simulation results and waveform files
│   ├── results/
│   │   ├── step_response/
│   │   ├── kalman_filter_2nd_order/
│   │   ├── extended_kalman_filter/
│   │   └── ...
│   └── waveforms/
│       ├── step_response/
│       ├── kalman_filter_2nd_order/
│       ├── extended_kalman_filter/
│       └── ...
│
├── papers/               # Research paper drafts and conference submissions
│   ├── intro.md          # Introduction section
│   ├── lit_review.md     # Literature review section
│   ├── theory.md         # Theory section
│   ├── methodology.md    # Methodology section
│   ├── comparison.md     # Comparison section
│   ├── conclusions.md    # Conclusions section
│   └── ...
│
└── README.md             # Project overview and documentation

Experiments
Environment Setup and Basic Counter

    Description: Setting up the VHDL simulation environment and creating a basic counter module along with its testbench.
    Source Files: src/counter.vhd, testbenches/counter_tb.vhd

Dynamical System Simulations

    Step Response Simulation
        Description: Simulating the step response of a 2nd-order linear dynamical system.
        Source Files: src/dynamical_systems/step_response.vhd, testbenches/dynamical_systems/step_response_tb.vhd
    Random Noise Generator
        Description: Generating random noise for dynamical system simulations.
        Source Files: src/dynamical_systems/noise_generator.vhd, testbenches/dynamical_systems/noise_generator_tb.vhd
    PID Controller
        Description: Implementing a Proportional-Integral-Derivative (PID) controller for feedback loop control.
        Source Files: src/dynamical_systems/pid_controller.vhd, testbenches/dynamical_systems/pid_controller_tb.vhd
    State Space Model
        Description: Simulating a 3rd-order linear dynamical system in state space.
        Source Files: src/dynamical_systems/state_space_model.vhd, testbenches/dynamical_systems/state_space_model_tb.vhd

Kalman Filter Simulations

    2nd Order Kalman Filter
        Description: Implementing a 2nd-order Kalman filter in VHDL and simulating its performance.
        Source Files: src/kalman_filters/kalman_filter_2nd_order.vhd, testbenches/kalman_filters/kalman_filter_2nd_order_tb.vhd
    State Space Kalman Filter
        Description: Creating a state space Kalman filter with a 3x3 matrix simulation.
        Source Files: src/kalman_filters/state_space_kalman_filter.vhd, testbenches/kalman_filters/state_space_kalman_filter_tb.vhd
    Extended Kalman Filter
        Description: Simulating an extended Kalman filter (EKF).
        Source Files: src/kalman_filters/extended_kalman_filter.vhd, testbenches/kalman_filters/extended_kalman_filter_tb.vhd
    Distributed Kalman Filter
        Description: Exploring the concept of distributed Kalman filtering and simulating its behavior.
        Source Files: src/kalman_filters/distributed_kalman_filter.vhd, testbenches/kalman_filters/distributed_kalman_filter_tb.vhd

Capstone Applications

    Drone IMU Sensor Fusion
        Description: Implementing sensor fusion for a drone's Inertial Measurement Unit (IMU) 9 degrees of freedom (9DOF) I2C sensor fusion for quadcopters.
        Source Files: src/applications/imu_sensor_fusion.vhd, testbenches/applications/imu_sensor_fusion_tb.vhd
    Power System Estimator
        Description: Developing a sensor fusion and estimator/predictor for a power system, using an Extended Kalman Filter (EKF).
        Source Files: src/applications/power_system_estimator.vhd, testbenches/applications/power_system_estimator_tb.vhd

Paper Writing

The project includes the writing of a research paper, divided into the following sections:

    Introduction: Providing an overview of the project objectives and motivation.
    Literature Review: Reviewing existing literature on FPGA-based Kalman filtering and related applications.
    Theory: Explaining the theoretical background of Kalman filtering algorithms and their implementation on FPGA platforms.
    Methodology: Describing the experimental setup and methodologies used in the project.
    Comparison: Presenting the results of experiments and comparisons between different Kalman filter architectures and implementations.
    Conclusions: Summarizing the findings of the project and discussing future work and potential applications.

Conference Papers

The project aims to submit papers to relevant conferences in the field of FPGA design, signal processing, and control systems. Conference papers will be based on the research conducted in this project and will present the results and findings to the academic community.
Contributing

Contributions to the project are welcome! If you're interested in contributing, please fork the repository, make your changes, and submit a pull request. For major changes, please open an issue first to discuss the proposed changes.
License

This project is licensed under the MIT License.

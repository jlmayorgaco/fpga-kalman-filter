# PROJECT files
PROJECT_NAME := p1_2nd_system_step_response

# VHDL files
VHDL_FILES := $(PROJECT_NAME).vhd
VHDL_TEST_BENCH := $(PROJECT_NAME)_testbench.vhd
VHDL_TEST_ENTITY := $(PROJECT_NAME)_tb

# Simulation options
SIM_OPTIONS := --vcd=$(PROJECT_NAME)_wave.vcd

# GHDL commands
GHDL := ghdl
GHDL_FLAGS := -g

# Default target
all: compile simulate

# Compile VHDL files
compile:
	$(GHDL) -a $(GHDL_FLAGS) $(VHDL_FILES) && $(GHDL) -a $(GHDL_FLAGS) $(VHDL_TEST_BENCH)

# Simulate
simulate:
	$(GHDL) -r $(VHDL_TEST_ENTITY) $(SIM_OPTIONS)

# Clean generated files
clean:
	rm -f *.o *.cf wave.vcd

.PHONY: all compile simulate clean

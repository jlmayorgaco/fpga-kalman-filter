# PROJECT files
PROJECT_NAME := p0_counter_16bits

# VHDL files
VHDL_FILES := up_counter_16bit.vhd
VHDL_TEST_BENCH := up_counter_16bit_testbench.vhd
VHDL_TEST_ENTITY := up_counter_16bit_tb

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

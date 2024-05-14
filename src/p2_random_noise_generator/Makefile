# PROJECT files
PROJECT_ENTRY_FILE := main

# VHDL files
VHDL_FILES := src/$(PROJECT_ENTRY_FILE).vhd lib/saturation.vhd lib/noise.vhd lib/filter_low_pass.vhd
VHDL_TEST_BENCH := test/$(PROJECT_ENTRY_FILE)_testbench.vhd
VHDL_TEST_ENTITY := $(PROJECT_ENTRY_FILE)_tb

# Simulation options
SIM_OPTIONS := --vcd=test/$(PROJECT_ENTRY_FILE)_wave.vcd

# GHDL commands
GHDL := ghdl
GHDL_FLAGS := -g --ieee=synopsys 

# Default target
all: compile simulate plot

# Compile VHDL files
compile:
	$(GHDL) -a $(GHDL_FLAGS) $(VHDL_FILES) && $(GHDL) -a $(GHDL_FLAGS) $(VHDL_TEST_BENCH)

# Simulate
simulate:
	$(GHDL) -r $(VHDL_TEST_ENTITY) $(SIM_OPTIONS)

plot:
	python scripts/vcd.py

# Clean generated files
clean:
	rm -f *.o *.cf wave.vcd

.PHONY: all compile simulate clean

# PROJECT files
PROJECT_ENTRY_FILE := main

# VHDL files
VHDL_COMPONENT_FILES := $(shell find lib -name '*.component.vhd')
VHDL_TEST_FILES := $(shell find lib -name '*.testbench.vhd')

# Derive testbench entities from component files
VHDL_TEST_ENTITIES := $(foreach file, $(VHDL_COMPONENT_FILES), $(basename $(notdir $(file)))_Testbench)

# Simulation options
SIM_OPTIONS := --vcd=test/$(PROJECT_ENTRY_FILE)_wave.vcd

# GHDL commands
GHDL := ghdl
GHDL_FLAGS := -g --ieee=synopsys

# Default target
all: compile simulate plot

# Compile VHDL files
compile:
	$(GHDL) -a $(GHDL_FLAGS) $(VHDL_FILES) $(VHDL_FILES_MATH) $(VHDL_FILES_UTITLIES) $(VHDL_FILES_CONTROLLERS) $(VHDL_FILES_PLANTS) && $(GHDL) -a $(GHDL_FLAGS) $(VHDL_TEST_BENCH)

# Simulate
simulate:
	$(GHDL) -r $(VHDL_TEST_ENTITY) $(SIM_OPTIONS)

plot:
	python scripts/vcd.py

# Clean generated files
clean:
	rm -f *.o *.cf test/$(PROJECT_ENTRY_FILE)_wave.vcd

.PHONY: all compile simulate clean

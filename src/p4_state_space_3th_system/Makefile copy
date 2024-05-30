# PROJECT files
PROJECT_ENTRY_FILE := main

# VHDL files
VHDL_COMPONENT_FILES := $(shell find lib -name '*.component.vhd')
VHDL_TEST_FILES := $(shell find lib -name '*.testbench.vhd')

# Function to convert component filename to testbench entity name
define convert_to_testbench_entity
$(shell echo $(1) | sed -e 's/.*\///' -e 's/\.component\.vhd//')
endef

# Derive testbench entities from component files
VHDL_TEST_ENTITIES := $(foreach file, $(VHDL_COMPONENT_FILES), $(call convert_to_testbench_entity,$(file))_Testbench)

# Simulation options
SIM_OPTIONS := --vcd=test/$(PROJECT_ENTRY_FILE)_wave.vcd

# GHDL commands
GHDL := ghdl
GHDL_FLAGS := -g --ieee=synopsys

# Default target
all: compile simulate validate

# Compile VHDL files
compile:
	$(GHDL) -a $(GHDL_FLAGS) $(VHDL_COMPONENT_FILES) $(VHDL_TEST_FILES)

# Simulate each testbench and generate VCD files
simulate: $(VHDL_TEST_ENTITIES)

$(VHDL_TEST_ENTITIES):
	$(GHDL) -r $@ --vcd=test/waves/$@_wave.vcd

validate:

# Clean generated files
clean:
	rm -f *.o *.cf

.PHONY: all compile simulate clean

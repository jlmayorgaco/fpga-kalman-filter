# PROJECT files
PROJECT_ENTRY_FILE := main

# VHDL files
# VHDL_FILES := src/$(PROJECT_ENTRY_FILE).vhd $(shell find ../lib -name '*.vhd')
VHDL_FILES := src/$(PROJECT_ENTRY_FILE).vhd
VHDL_FILES_MATH := lib/math/2x2/matrix_inverse_2x2.vhd lib/math/2x2/matrix_product_2x2.vhd lib/math/2x2/matrix_scale_2x2.vhd lib/math/2x2/matrix_sum_2x2.vhd lib/math/2x2/matrix_vector_product_2x2.vhd lib/math/2x2/vector_sum_2x1.vhd lib/math/2x2/vector_scale_2x1.vhd lib/math/2x2/vector_derivate_2x1.vhd lib/math/2x2/vector_integrator_2x1.vhd
VHDL_FILES_UTITLIES := lib/utilities/saturation.vhd
VHDL_FILES_CONTROLLERS := lib/controllers/pid.vhd
VHDL_FILES_PLANTS := lib/systems/plant_ss.vhd


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

# PROJECT files
PROJECT_ENTRY_FILE := matrix_vector_product_3x3

# VHDL files
VHDL_COMPONENT_FILES := lib/math/3x3/matrix_vector_product_3x3.component.vhd
VHDL_TEST_FILES := lib/math/3x3/matrix_vector_product_3x3.testbench.vhd

# Testbench entity name
VHDL_TEST_ENTITY := MatrixVectorProduct_3x3_Testbench

# Simulation options
SIM_OPTIONS := --vcd=test/$(PROJECT_ENTRY_FILE)_wave.vcd

# GHDL commands
GHDL := ghdl
GHDL_FLAGS := -g --ieee=synopsys

# Default target
all: compile simulate

# Compile VHDL files
compile:
	$(GHDL) -a $(GHDL_FLAGS) $(VHDL_COMPONENT_FILES) $(VHDL_TEST_FILES)

# Simulate the testbench and generate VCD file
simulate: $(VHDL_TEST_ENTITY)

$(VHDL_TEST_ENTITY):
	$(GHDL) -r $@ --vcd=test/waves/$(VHDL_TEST_ENTITY)_wave.vcd

# Clean generated files
clean:
	rm -f *.o *.cf

.PHONY: all compile simulate clean

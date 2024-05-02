# VHDL files
VHDL_FILES := SecondOrderSystem.vhd
VHDL_TEST_BENCH := SecondOrderSystem_tb.vhd
VHDL_TEST_ENTITY := SecondOrderSystem_tb

# Simulation options
SIM_OPTIONS := --vcd=wave.vcd

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

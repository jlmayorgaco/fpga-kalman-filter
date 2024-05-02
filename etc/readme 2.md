ghdl -a full_adder.vhd &&
ghdl -a full_adder_testbench.vhd &&
ghdl -r full_adder_testbench --vcd=wave.vcd
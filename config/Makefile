GHDL=ghdl
GHDLFLAGS=
MODULES=\
	full_adder.o \
	full_adder_testbench

test: $(MODULES)
		./full_adder_testbench --vcd=full_adder_testbench.vcd

# Binary depends on the object file
%: %.o
		$(GHDL) -e $(GHDLFLAGS) $@

# Object file depends on source
%.o: %.vhd
		$(GHDL) -a $(GHDLFLAGS) $<

clean:
		echo "Cleaning up..."
		rm -f *.o *_testbench full_adder work*.cf e*.lst
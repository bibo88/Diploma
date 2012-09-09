###############################################
# NC-verilog simulator build and run rules    #
###############################################
# Compile script generation rules:

ncverilog_dut.scr: rtl $(RTL_VERILOG_SRC) $(RTL_VERILOG_INCLUDES) $(BOOTROM_VERILOG)
	$(Q)echo "+incdir+"$(RTL_VERILOG_INCLUDE_DIR) > $@;
	$(Q)echo "+incdir+"$(RTL_SIM_SRC_DIR) >> $@;
	$(Q)echo "+incdir+"$(BOOTROM_SW_DIR) >> $@;
	$(Q)echo "+incdir+"$(BENCH_VERILOG_INCLUDE_DIR) >> $@;
	$(Q)echo "+libext+.v" >> $@;
	$(Q)for module in $(RTL_VERILOG_MODULES); do if [ -d $(RTL_VERILOG_DIR)/$$module ]; then echo "-y " $(RTL_VERILOG_DIR)/$$module >> $@; echo $(RTL_VERILOG_DIR)/$$module >> files.txt ; fi; done
	$(Q)for module in $(RTL_VERILOG_MODULES); do if [ -d $(RTL_VERILOG_DIR)/$$module ]; then echo  $(RTL_VERILOG_DIR)/$$module/*.v >> $@; echo $(RTL_VERILOG_DIR)/$$module >> files.txt ; fi; done
	$(Q)echo >> $@

ncverilog_bench.scr: $(BENCH_VERILOG_SRC)
	$(Q)echo "+incdir+"$(BENCH_VERILOG_DIR) > $@;
	$(Q)for path in $(BENCH_VERILOG_SRC_SUBDIRS); do echo "+incdir+"$$path >> $@; done
	$(Q)for path in $(BENCH_VERILOG_SRC_SUBDIRS); do echo "-y "$$path >> $@; done
	$(Q)echo "+incdir+"$(RTL_VERILOG_INCLUDE_DIR) >> $@;
	$(Q)echo "+incdir+"$(RTL_SIM_SRC_DIR) >> $@;
	$(Q)echo "+libext+.v" >> $@;
	$(Q)echo "-y" $(RTL_SIM_SRC_DIR) >> $@;
	$(Q)for vsrc in $(BENCH_VERILOG_SRC); do echo $$vsrc >> $@; done
	$(Q)echo >> $@

# Compile DUT into "work" library
worklib: ncverilog_dut.scr #$(RTL_VHDL_SRC)
#	$(Q)if [ ! -e $@ ]; then mkdir -p INCA_libs/$@; fi
#	$(Q)echo; echo "\t### Compiling VHDL design library ###"; echo
#	$(Q)ncvhdl -93 $(QUIET) $(RTL_VHDL_SRC)
#	$(Q)echo; echo "\t### Compiling Verilog design library ###"; echo
#	$(Q)ncverilog $(QUIET) -f $< $(DUT_TOP)
	$(Q)ncverilog +nctimescale+1ns/10ps +ncoverride_timescale -f $< $(DUT_TOP)

# Single compile rule
.PHONY : $(NCVERILOG)
$(NCVERILOG): ncverilog_bench.scr $(TEST_DEFINES_VLG) $(MGC_VPI_LIB) worklib
	$(Q)echo; echo "\t### Compiling testbench ###"; echo
	$(Q)ncverilog -c  $(QUIET) $(BENCH_TOP) -f $<
	$(Q)ncelab $(QUIET) $(RTL_TESTBENCH_TOP) $(VOPT_ARGS) -o tb
	$(Q)echo; echo "\t### Launching simulation ###"; echo
	$(Q)ncsim $(MGC_VSIM_ARGS) tb



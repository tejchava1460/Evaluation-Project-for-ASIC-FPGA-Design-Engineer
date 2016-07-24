x0.txt and x1.txt are the matlab code output files given as input to the RTL code.

checker_log_0.txt &  checker_log_1.txt   are the final output files obtained after the comparisions b/w matlab and RTL o/p's.

awgn_out.txt   contains the x0 and x1 o/p data of verilog.



In order to test the code just copy all the files into the modelsim examples directory.   click on the run_all button.

wait for a moment click on the 'NO' of the popup.

For custom awgn_seed's


1) First change the seed in the 'Taus_generator_for_MATLAB_code' folder's testbench and get the new rand_1.txt and rand_2.txt.
2) Copy these two files into the matlab directory and click on the run button in matlab.
3) Copy the obtained 'x0.txt' & 'x1.txt' into the Verilog_Noise_generator project.
4) Click on the run_all check the checker_log_0.txt &  checker_log_1.txt for results.

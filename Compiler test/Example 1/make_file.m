%% make_file.m
%%
%% This MATLAB script m-file calls the compiler to convert the MATLAB source code files for
%% make_plot_trig to C, link the object files with the MATLAB graphics library, and then produce a
%% stand-alone executable.
%
%Kenneth Beers
%Massachusetts Institute of Technology
%Department of Chemical Engineering
%kbeers@mit.edu
%7/31/2001

mcc -B sgl ... 
make_plot_trig ... 
plot_trig_1 ... 
trig_func_1 ... 
get_input_scalar ... 
assert_scalar
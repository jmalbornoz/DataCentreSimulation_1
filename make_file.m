%% make_file.m
%%
%% This MATLAB script m-file calls the compiler to convert the MATLAB data centre simulator files for
%% sim51 to C, link the object files with the MATLAB graphics library, and then produce a
%% stand-alone executable.
%%
%% Jose Albornoz
%% Fujitsu Laboratories of Europe
%% October 2011
%%

mcc -B sgl ... 
 sim56.m ...
 walk.m ...
 search.m ...
 loss_1.m ...
 loss_2.m
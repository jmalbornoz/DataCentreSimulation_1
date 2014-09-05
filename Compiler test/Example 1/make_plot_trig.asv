%% make_plot_trig.m
%%
%% This MATLAB m-file makes a plot of the general function
%% f(x) = a*sin(x) + b*cos(x)
%% for user-selected values of a and b.
%
% Kenneth Beers
% Massachusetts Institute of Technology
% Department of Chemical Engineering
%kbeers@mit.edu
% 7/31/2001

function iflag_main = make_plot_trig();

iflag_main = 0; %signifies no completion

disp('RUNNING make_plot_trig ...');
disp(' ');
disp('This program produces a plot in [0,2*pi]');
disp('of the function : ');
disp('f(x) = a*sin(x) + b*cos(x)');
disp('for user-input values of the real scalars a and b');
disp(' ');

% The following code asks the user to input values of a and b, and 
% then uses plot_trig to plot trig_func_1 by including the function 
% name as an argument in the list.

prompt = 'Input a : ';

check_real = 1; 
check_sign = 0; 
check_int = 0;

a = get_input_scalar(prompt,check_real,check_sign,check_int);
prompt = 'Input b : ';

check_real = 1; 
check_sign = 0; 
check_int = 0;

b = get_input_scalar(prompt,check_real,check_sign,check_int);

% We now call the routine that produces the plot.
func_name = 'trig_func_1'; 
plot_trig_1(func_name,a,b);

%We now require the user to strike a key before exiting the program.

pause
iflag_main = 1;

return;
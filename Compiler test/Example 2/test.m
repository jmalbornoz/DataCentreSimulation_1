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

function iflag_main = make_plot_trig(param);
close all

iflag_main = 0; %signifies no completion

x = linspace(0,20,100);
y = param*cos(2*pi*x);

figure
plot(x,y)
grid

iflag_main = 1;

return;
function iflag = plot_trig_1(func_name,a,b);

iflag = 0; %signifies no completion

% First, create an x vector from 0 to 2*pi
num_pts = 100; 
x = linspace(0,2*pi,num_pts);

% Next, make a vector of the function values. We evaluate the argument 
% function indirectly using the "feval" command.
f = linspace(0,0,num_pts); 
for i=1:num_pts 
    f(i) = feval(func_name,x(i),a,b); 
end

% Then, we make the plot.

figure;
plot(x,f);
xlabel('Angle (radians)');
ylabel('Function value');

iflag = 1;  % successful completion

return;
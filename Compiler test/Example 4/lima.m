function rc = lima(a,b)

close all

a = str2num(a);
b = str2num(b);

x = linspace(0,20*pi,100);
y = a*sin(x).*exp(-x/b);

figure
plot(x,y)
grid

rc = 0;

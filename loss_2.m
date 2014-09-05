function loss = loss_2(S, idx, red_mode, load, temp)
%% 
%% This function calculates dissipated/consumed power of a temperature-dependent
%% M&E device (chiller)
%%
%% * S = structure containing node information
%% * idx = node number
%% * red_mode = redundancy mode
%% * load = applied load
%% * temp = ambient temperature
%%
%%
%% Jose Albornoz
%% Fujitsu Laboratories of Europe
%% December 2011 
%%

% recovers device & node information
ProvCap = S(idx).ProvCap;  % provisioned capacity
DevCap = S(idx).Cap;       % device capacity
NDev = S(idx).NDev;        % number of devices
fit = S(idx).Fit{1};       % device fit
minT = S(idx).Fit{2};      % minimum temperature in device definition
maxT = S(idx).Fit{3};

% redundancy mode is considered
if(red_mode == 0)                 % active load sharing
    N = NDev;
elseif(red_mode == 1)             % standby
    N = ceil(ProvCap/DevCap);     % number of active devices
    Nstdby = NDev - N;            % number of devices in stand-by (zero load, but may have losses)
end

if minT == 0 && maxT == 1     % it's a temperature-independent device (e.g. cooling tower)
    
    if(red_mode == 0 || (red_mode == 1 && Nstdby == 0))             % active load sharing
        loss = fit(load/(N*DevCap),0.5)*N*DevCap;
    elseif(red_mode == 1 && Nstdby ~= 0)                            % standby
        loss = fit(load/(N*DevCap),0.5)*N*DevCap + fit(0,0.5)*Nstdby*DevCap;
    end
    
else
    
    % computes power consumption using bilinear interpolation fit for the device
    if(red_mode == 0 || (red_mode == 1 && Nstdby == 0))             % active load sharing
        if temp >= minT && temp <= maxT
            loss = fit(load/(N*DevCap),temp)*N*DevCap;
        elseif temp < minT
            loss = fit(load/(N*DevCap),minT)*N*DevCap; 
        elseif temp > maxT
            loss = fit(load/(N*DevCap),maxT)*N*DevCap;
        end
    elseif(red_mode == 1 && Nstdby ~= 0)                            % standby
        if temp >= minT && temp <= maxT
            loss = fit(load/(N*DevCap),temp)*N*DevCap + fit(0,temp)*Nstdby*DevCap;
        elseif temp < minT
            loss = fit(load/(N*DevCap),minT)*N*DevCap + fit(0,minT)*Nstdby*DevCap;
        elseif temp > maxT
            loss = fit(load/(N*DevCap),maxT)*N*DevCap + fit(0,maxT)*Nstdby*DevCap;        
        end
    end
    
end
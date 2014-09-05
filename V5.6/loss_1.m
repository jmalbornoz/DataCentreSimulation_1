function loss = loss_1(S, idx, red_mode, load)
%% 
%% This function calculates dissipated/consumed power of a temperature-independent
%% M&E device
%%
%% * S = structure containing node information
%% * idx = node number
%% * red_mode = redundancy mode
%% * load = applied load
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
fit = S(idx).Fit;          % device fit

% redundancy mode is considered
if(red_mode == 0)                 % active load sharing
    N = NDev;
elseif(red_mode == 1)             % standby
    N = ceil(ProvCap/DevCap);     % number of active devices
    Nstdby = NDev - N;            % number of devices in stand-by (zero load, but may have losses)
end

% computes loss fit for the device
if(red_mode == 0 || (red_mode == 1 && Nstdby == 0))           % active load sharing
    loss = fit(load/(N*DevCap))*N*DevCap;
elseif(red_mode == 1 && Nstdby ~= 0)                          % standby
    loss = fit(load/(N*DevCap))*N*DevCap + fit(0)*Nstdby*DevCap;
end

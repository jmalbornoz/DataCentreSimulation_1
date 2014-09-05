function ndays = days_in_month(month, year)
%% 
%% Returns number of days in a given month
%%
%% Jose Albornoz
%% Fujitsu Laboratories of Europe
%% September 2012 
%%

if month == 4 || month == 6 || month == 9 || month == 11    % 30 days
    ndays = 30;
elseif month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12   % 31 days
    ndays = 31;  
elseif month == 2            % february
    if(mod(year,4) == 0 && mod(year,100) ~= 0) || (mod(year,4) == 0 && mod(year,100) == 0 && mod(year,400) == 0)  % leap year
        ndays = 29;
    else                        % not a leap year
        ndays = 28;        
    end
end

return ndays;
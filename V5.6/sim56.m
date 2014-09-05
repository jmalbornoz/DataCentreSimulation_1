%% Data centre energy simulation
%% v5.6
%%
%% * This version reads device & layout data from the BCS/CT XML files
%% * Heat distributors are incorporated
%% * Takes into account equipment redundancy modes (active load
%% sharing/standby)
%% * Reads IT and other load information from XML file  
%% * Reads climate information from XML file
%% * Computes total, IT, cooling, distribution, and other power
%% * Redefinition of cooling devices
%% * Timestamps in IT & OTHER loads taken into account
%% * Minor bugs corrected
%% * Cubic spline representation of temperature-independent M&E devices
%% * Bilinear interpolation of temperature-dependent M&E devices (e.g. chillers)
%%
%% * Configured as stand-alone executable able to interface with web-based
%%   GUI
%% * Receives Name of simulation as a parameter to read two XML files:
%%      * NAME_scenario.xml
%%      * NAME_layout.xml
%%
%% * Writes simulation results to XML file following established format
%% * Corrections were made in the way simulation/loads/climate dates are handled (10/10/2011) 
%% * Values in load and temperature vectors for not regularly spaced (02/12/2011)
%%
%%
%% * The following files must be included in the compilation script:
%%      * sim51.m
%%      * walk.m
%%      * search.m
%%      * loss_1.m
%%      * loss_2.m
%%
%%      * Simulation results are stored on a daily basis 
%%      * Climate and load data are synchronised with simulation dates
%%
%%      * 2-D device data structure was modified to allow non-regular
%%      temperature or load vectors (5/12/2011)
%%
%%  * Definitions for 2-D ON/OFF cooling devices (7/12/2011)
%%  * 2-D devices handle temperatures beyond their specified range
%%  (7/12/2011)
%%  * Definition of passive heat load node (15/12/2011)
%%
%% Jose Albornoz
%% Fujitsu Laboratories of Europe
%% December 2011 
%%
%function rc = sim55(name)
clear all
%close all
tic
% redundancy mode ( 0 = active load sharing, 1 = standby)
mode = 1;

% name of the data centre file 
name = 'Tatebayashi_test';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reads and parses XML device and layout files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xmlstr = fileread([name '_scenario.xml']);
devices = xml_parseany(xmlstr);

xmlstr = fileread([name '_layout.xml']);
layout = xml_parseany(xmlstr);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reads start date for the simulation
% and determines end date
%
% If any of the load or weather data is outside 
% this range it is ignored
%
% If any load or weather data does not cover the 
% full time the first or last value is repeated 
% to fill the gaps (NOT YET IMPLEMENTED!).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% reads start date for the simulation
start_date = devices.SimulationDate{1}.CONTENT;

% reads number of months in the simulation
num_months = str2double(devices.FullSimulation{1}.SimulationMonths{1}.CONTENT);

start_year = str2double(start_date(1:4));
start_month = str2double(start_date(6:7));

% calculates end date for the simulation
offset = start_month + num_months;
if offset > 12
    end_month = offset - 12;
    end_year = start_year + 1;
else
    end_month = start_month + num_months;
    end_year = start_year;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Builds data structure 'Dev'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Determines number of nodes in DC layout
numNodes =  size(layout.Devices,2);

% Creates structure 'Dev' with name and type of each device node
for i = 1:numNodes
    Dev(i).Name = layout.Devices{i}.Name{1}.CONTENT;
    Dev(i).Type = layout.Devices{i}.Type{1}.CONTENT;
end

% Finds connections between nodes
% An element with no connections is a root node
% Two types of connections: POWER and COOLING
for i = 1:numNodes
    if(isfield(layout.Devices{i},'Connections')) % element has connections
        numCon = size(layout.Devices{i}.Connections,2); % number of connections
        Dev(i).NumConn = numCon;
        for j = 1:numCon
            if(strcmp(layout.Devices{i}.Connections{j}.Type{1}.CONTENT,'POWER') ...
                    || strcmp(layout.Devices{i}.Connections{j}.Type{1}.CONTENT,'Power'))    % POWER connection
                Dev(i).Conn(j) = 1;
                for k = 1:numNodes
                    if(strcmp(layout.Devices{i}.Connections{j}.Target{1}.CONTENT,Dev(k).Name))
                        Dev(i).Target(j) = k;
                        break;
                    end
                end
            elseif(strcmp(layout.Devices{i}.Connections{j}.Type{1}.CONTENT,'COOLING')...
                    || strcmp(layout.Devices{i}.Connections{j}.Type{1}.CONTENT,'Cooling'))  % COOLING connection
                Dev(i).Conn(j) = -1;
                for k = 1:numNodes
                    if(strcmp(layout.Devices{i}.Connections{j}.Target{1}.CONTENT,Dev(k).Name))
                        Dev(i).Target(j) = k;
                        break;
                    end
                end
            end
         
        end
    else    % element has no connections
       Dev(i).NumConn = 0; 
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Performs curve fitting for M&E devices
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Determines number of infrastructure devices
num_InfDev = size(devices.InfrastructureDevices,2);

for i = 1:num_InfDev
         
    % 1-D device 
    if(~isfield(devices.InfrastructureDevices{i}.DeviceDetails{1}.LossGroup{1}.LossGrid{1}.Grid{1},'Grid'))
    
        % reads device information from XML file
        % determines number of points in device loss grid
        nPoints = size(devices.InfrastructureDevices{i}.DeviceDetails{1}.LossGroup{1}.LossGrid{1}.Grid{1}.Line,2);
  
        % node provisioned capacity
        ProvCap = str2double(devices.InfrastructureDevices{i}.Installed{1}.Capacity{1}.CONTENT);        
        % individual capacity of the device
        DevCap = str2double(devices.InfrastructureDevices{i}.DeviceDetails{1}.LossGroup{1}.Capacity{1}.CONTENT);
        % number of devices
        NDev = str2double(devices.InfrastructureDevices{i}.Installed{1}.Number{1}.CONTENT);
  
        % determines coefficients for 3rd order polynomial fit
        x = [];
        y = [];
        for j = 1:nPoints
            x = [x str2double(devices.InfrastructureDevices{i}.DeviceDetails{1}.LossGroup{1}.LossGrid{1}.Grid{1}.Line{j}.Load{1}.CONTENT)];
            y = [y str2double(devices.InfrastructureDevices{i}.DeviceDetails{1}.LossGroup{1}.LossGrid{1}.Grid{1}.Line{j}.Loss{1}.CONTENT)];
        end
        
        % builds fit for device
        if length(x) > 3     % there are enough points in device definition
            fit = @(z)(spline(x,y,z));
        else                 % not enough points - piecewise linear fit
            fit = @(z)(interp1(x,y,z));
        end
    
        % Includes device information in structure 'Dev' 
        for j = 1:numNodes
            if(strcmp(Dev(j).Name,devices.InfrastructureDevices{i}.Name{1}.CONTENT))
                Dev(j).Dim = 1;                 % device dimension = 1
                Dev(j).ProvCap = ProvCap;       % node provisioned capacity
                Dev(j).Cap = DevCap;            % device capacity
                Dev(j).NDev = NDev;             % number of devices
                Dev(j).Fit = fit;               % device fit
                break;
            end
        end
        
    % 2-D device 
    else    
        % Reads device information 
        % Rows correspond to temperatures, columns to loads
      
        % Determines number of temperature and load points
        nTemp = size(devices.InfrastructureDevices{i}.DeviceDetails{1}.LossGroup{1}.LossGrid{1}.Grid{1}.Grid,2);
        n_Load_Points = size(devices.InfrastructureDevices{i}.DeviceDetails{1}.LossGroup{1}.LossGrid{1}.Grid{1}.Grid{1}.Line,2);
   
        % reads temperature points from device data           
        T = [];
        for j = 1:nTemp
            T = [T str2double(devices.InfrastructureDevices{i}.DeviceDetails{1}.LossGroup{1}.LossGrid{1}.Grid{1}.Grid{j}.KeyParameter{1}.CONTENT)];
        end
        minTemp = min(T);
        maxTemp = max(T);
        
        % reads load points from device data
        L = [];
        for j = 1:n_Load_Points
            L = [L str2double(devices.InfrastructureDevices{i}.DeviceDetails{1}.LossGroup{1}.LossGrid{1}.Grid{1}.Grid{1}.Line{j}.Load{1}.CONTENT)];
        end
              
        % Device node provisioned capacity
        ProvCap = str2double(devices.InfrastructureDevices{i}.Installed{1}.Capacity{1}.CONTENT);        
        % Device capacity
        DevCap = str2double(devices.InfrastructureDevices{i}.DeviceDetails{1}.LossGroup{1}.Capacity{1}.CONTENT);
        % Number of devices
        NDev = str2double(devices.InfrastructureDevices{i}.Installed{1}.Number{1}.CONTENT);
        
        % Builds device matrix      
        CM = zeros(nTemp, n_Load_Points);
        for n = 1:nTemp
            for m = 1:n_Load_Points
                CM(n,m) = str2double(devices.InfrastructureDevices{i}.DeviceDetails{1}.LossGroup{1}.LossGrid{1}.Grid{1}.Grid{n}.Line{m}.Loss{1}.CONTENT);
            end
        end  
        
        % builds 2-D device fit
        fit = @(l,t)(interp2(L,T,CM,l,t));
               
        % includes device information in structure 'Dev' 
        for j = 1:numNodes
            if(strcmp(Dev(j).Name,devices.InfrastructureDevices{i}.Name{1}.CONTENT))
                Dev(j).Dim = 2;                 % device dimension = 2
                Dev(j).ProvCap = ProvCap;       % node provisioned capacity
                Dev(j).Cap = DevCap;            % device capacity
                Dev(j).NDev = NDev;             % number of devices
                Dev(j).Fit = {fit minTemp maxTemp};       % device fit, min and max temps
                break;
            end
        end
      
    end
    
end

% Are there any distributors?
if(isfield(devices,'Distributors'))
    
    % Number of distributors
    num_Distrib = size(devices.Distributors,2);
    
    % Finds tap weights for each distributor
    for i = 1:num_Distrib
        flag0 = 0;
        taps = [];
        for j = 1:numNodes      % finds distributor in structure 'Dev'
            if(strcmp(Dev(j).Name,devices.Distributors{i}.Name{1}.CONTENT))
                num_Taps = size(devices.Distributors{i}.Tap,2); % number of taps
                for k = 1:num_Taps
                     for n = 1:num_Taps     % read tap weights
                        if(strcmp(Dev(Dev(j).Target(k)).Name,devices.Distributors{i}.Tap{n}.TapName{1}.CONTENT))
                            taps = [taps str2double(devices.Distributors{i}.Tap{n}.Value{1}.CONTENT)];
                            break
                        end
                     end
                 end
                Dev(j).Fit = taps;  % tap weights are assigned as 'fits' (TO BE ELIMINATED)
                Dev(j).Points = taps;
                flag0 = 1;
            end
            if flag0 == 1
                break
            end
        end
    end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Finds degree of each node 
% Power nodes have positive degrees
% Cooling nodes have negative degrees
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:numNodes
    Dev(i).Degree = 0;
end
for i = 1:numNodes
    if Dev(i).NumConn > 0
        for j = 1:Dev(i).NumConn
            if Dev(i).Conn(j) == 1
                for k = 1:numNodes
                    if Dev(i).Target(j) == k
                        Dev(k).Degree = Dev(k).Degree + 1;
                    end
                end
            elseif Dev(i).Conn(j) == -1
                for k = 1:numNodes
                    if Dev(i).Target(j) == k
                        Dev(k).Degree = Dev(k).Degree - 1;
                    end
                end
            end
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Loads climate data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% number of months in climate data
n_months = size(devices.FullSimulation{1}.Climate{1}.HourData,2);
    
% initial date in climate data
init_date = devices.FullSimulation{1}.Climate{1}.HourData{1}.Date{1}.CONTENT;
init_year = str2double(init_date(1:4));
init_month = str2double(init_date(6:7));
    
% ending date in climate data
fin_date = devices.FullSimulation{1}.Climate{1}.HourData{n_months}.Date{1}.CONTENT;
fin_year = str2double(fin_date(1:4));
fin_month = str2double(fin_date(6:7));    
    
% initialisations
i = 1;
Climate = {};   % cell array with hourly ambient temperature for each month in the simulation  
sim_year = start_year;     % initial simulation date
sim_month = start_month;

while i <= num_months
    
    % simulation date precedes starting date for climate data
    if sim_year < init_year || sim_year == init_year && sim_month < init_month
        
        % first set of climate data is repeated to fill the gaps
        for j = 1:24;
            Climate{i,j} = str2double(devices.FullSimulation{1}.Climate{1}.HourData{1}.Value{j}.CONTENT);
        end
        % advances simulation date
        sim_month = sim_month + 1;
        if sim_month > 12
            sim_month = 1;
            sim_year = sim_year + 1;
        end
        i = i + 1;     % advances simulation months counter
    
    % simulation dates lie within the range of climate data dates
    elseif (sim_year > init_year || sim_year == init_year && sim_month >= init_month) &&...
            (sim_year < fin_year || sim_year == fin_year && sim_month <= fin_month)
        
        % reads climate data corresponding to simulation date
        for k = 1:n_months
            date = devices.FullSimulation{1}.Climate{1}.HourData{k}.Date{1}.CONTENT; % reads time stamp
            year = str2double(date(1:4));
            month = str2double(date(6:7));           
            if sim_year == year && sim_month == month             
                for j = 1:24;
                    Climate{i,j} = str2double(devices.FullSimulation{1}.Climate{1}.HourData{k}.Value{j}.CONTENT);
                end 
            end
        end
        % advances simulation date
        sim_month = sim_month + 1;
        if sim_month > 12
            sim_month = 1;
            sim_year = sim_year + 1;
        end
        i = i + 1;      % advances simulation months counter       
        
    % simulation date later than ending climate data date
    elseif sim_year > init_year || sim_year == init_year && sim_month > init_month
        % last set of climate data is repeated to fill the gaps
        for j = 1:24;
            Climate{i,j} = str2double(devices.FullSimulation{1}.Climate{1}.HourData{n_months}.Value{j}.CONTENT);
        end 
        % advances simulation date
        sim_month = sim_month + 1;
        if sim_month > 12
            sim_month = 1;
            sim_year = sim_year + 1;
        end        
        i = i + 1;      % advances simulation months counter         
    end
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IT and other loads
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Initialises load, power and draw for all devices 
%
% for POWER devices:
% -----> Draw = Load + Pwr <-----
% --> power draw = load + dissipated heat
%
% for COOLING devices:
% -----> Pwr = Load + Draw <-----
% --> heat load for next node = heat load + power draw
%
for i = 1:numNodes
    Dev(i).Load = 0;    % load in watts at node input
    Dev(i).Pwr = 0;     % power dissipated/consumed by the node in watts
    Dev(i).Draw = 0;    % power drawn by the node (i.e. load to next node)
end

% Determines number of power loads (IT + others)
numLoads =  size(devices.PowerLoad,2);

% Finds 'OTHER' loads (such as lighting, heaters, etc.). Assigns hourly load values to
% cell array "Load", which is then assigned to Dev(i).Cap. Assigns
% provisioned capacity to Dev(i).ProvCap 
Other_Loads = [];   % array with numbers associated to OTHER load nodes
num_OL = 0;         % number of 'OTHER' loads
for i = 1:numNodes
    if strcmp(Dev(i).Type,'OTHER')
        for j = 1:numLoads
            if strcmp(Dev(i).Name,devices.PowerLoad{j}.Name{1}.CONTENT) % "OTHER" load
                
                % reads provisioned OTHER load
                Dev(i).ProvCap = str2double(devices.PowerLoad{j}.Provisioned{1}.Points{1}.Value{1}.CONTENT);
                
                % number of months of data for 'OTHER' load
                n_months = size(devices.PowerLoad{j}.WorkLoad{1}.WorkLoad,2);
                
                % initial date in data for 'OTHER' load
                init_date = devices.PowerLoad{j}.WorkLoad{1}.WorkLoad{1}.Date{1}.CONTENT;
                init_year = str2double(init_date(1:4));
                init_month = str2double(init_date(6:7));
                
                % ending date in data for 'OTHER' load
                fin_date = devices.PowerLoad{j}.WorkLoad{1}.WorkLoad{n_months}.Date{1}.CONTENT;
                fin_year = str2double(fin_date(1:4));
                fin_month = str2double(fin_date(6:7));    
                
                % initialisations
                k = 1;
                Load = {};  % cell array with hourly load values for each month in the simulation  
                sim_year = start_year;     % initial simulation date
                sim_month = start_month;
             
                % reads hourly values for OTHER load
                while k <= num_months
                    
                    % simulation date precedes starting date for load data
                    if sim_year < init_year || sim_year == init_year && sim_month < init_month
                
                        % first set of load data is repeated to fill the gaps
                        for m = 1:24;
                            Load{k,m} = str2double(devices.PowerLoad{j}.WorkLoad{1}.WorkLoad{1}.Value{m}.CONTENT);
                        end
                        % advances simulation date
                        sim_month = sim_month + 1;
                        if sim_month > 12
                            sim_month = 1;
                            sim_year = sim_year + 1;
                        end
                        k = k + 1;     % advances simulation months counter
                    
                    % simulation dates lie within the range of load data dates
                    elseif (sim_year > init_year || sim_year == init_year && sim_month >= init_month) &&...
                        (sim_year < fin_year || sim_year == fin_year && sim_month <= fin_month) 
                    
                        % reads load data corresponding to simulation date
                        for p = 1:n_months
                            date = devices.PowerLoad{j}.WorkLoad{1}.WorkLoad{p}.Date{1}.CONTENT;    % reads time stamp
                            year = str2double(date(1:4));
                            month = str2double(date(6:7));           
                            if sim_year == year && sim_month == month             
                                for m = 1:24;
                                    Load{k,m} = str2double(devices.PowerLoad{j}.WorkLoad{1}.WorkLoad{p}.Value{m}.CONTENT);
                                end
                            end
                        end 
                        % advances simulation date
                        sim_month = sim_month + 1;
                        if sim_month > 12
                            sim_month = 1;
                            sim_year = sim_year + 1;
                        end
                        k = k + 1;      % advances simulation months counter      
  
                    % simulation date later than ending climate data date
                    elseif sim_year > init_year || sim_year == init_year && sim_month > init_month
                        % last set of 'OTHER' data is repeated to fill the gaps
                        for m = 1:24;
                            Load{k,m} = str2double(devices.PowerLoad{j}.WorkLoad{1}.WorkLoad{n_months}.Value{m}.CONTENT);
                        end
                        % advances simulation date
                        sim_month = sim_month + 1;
                        if sim_month > 12
                            sim_month = 1;
                            sim_year = sim_year + 1;
                        end
                        k = k + 1;      % advances simulation months counter
                    end                  
                 
                end    
                
                Dev(i).Cap = Load;      
                Other_Loads = [Other_Loads i];
                num_OL = num_OL + 1;
                break;
                
            end
        end 
    end
end

% Finds IT loads and their maximum provisioned value. Assigns hourly values
% to cell array "Load", which is then assigned to Dev(i).Cap. Assigns
% monthly provisioned capacity to Dev(i).ProvCap 
IT_Loads = [];      % array with node numbers associated to IT loads
num_IT = 0;         % number of IT loads
for i = 1:numNodes
    if strcmp(Dev(i).Type,'LOAD')
        for j = 1:numLoads
            if strcmp(Dev(i).Name,devices.PowerLoad{j}.Name{1}.CONTENT)   % IT load
                
                % reads provisioned IT load
                Dev(i).ProvCap = str2double(devices.PowerLoad{j}.Provisioned{1}.Points{1}.Value{1}.CONTENT);
                
                % number of months of data for IT load
                n_months = size(devices.PowerLoad{j}.WorkLoad{1}.WorkLoad,2);
                
                % initial date in data for IT load
                init_date = devices.PowerLoad{j}.WorkLoad{1}.WorkLoad{1}.Date{1}.CONTENT;
                init_year = str2double(init_date(1:4));
                init_month = str2double(init_date(6:7));
                
                % ending date in data for IT load
                fin_date = devices.PowerLoad{j}.WorkLoad{1}.WorkLoad{n_months}.Date{1}.CONTENT;
                fin_year = str2double(fin_date(1:4));
                fin_month = str2double(fin_date(6:7));  
                
                % initialisations
                k = 1;
                Load = {};  % cell array with hourly load values for each month in the simulation  
                sim_year = start_year;     % initial simulation date
                sim_month = start_month;  
                
                % reads hourly values for IT load
                while k <= num_months
                    
                    % simulation date precedes starting date for load data
                    if sim_year < init_year || sim_year == init_year && sim_month < init_month
                
                        % first set of load data is repeated to fill the gaps
                        for m = 1:24;
                            Load{k,m} = str2double(devices.PowerLoad{j}.WorkLoad{1}.WorkLoad{1}.Value{m}.CONTENT);
                        end
                        % advances simulation date
                        sim_month = sim_month + 1;
                        if sim_month > 12
                            sim_month = 1;
                            sim_year = sim_year + 1;
                        end
                        k = k + 1;     % advances simulation months counter
                        
                    % simulation dates lie within the range of IT load data dates
                    elseif (sim_year > init_year || sim_year == init_year && sim_month >= init_month) &&...
                        (sim_year < fin_year || sim_year == fin_year && sim_month <= fin_month) 
                    
                        % reads load data corresponding to simulation date
                        for p = 1:n_months
                            date = devices.PowerLoad{j}.WorkLoad{1}.WorkLoad{p}.Date{1}.CONTENT;    % reads time stamp
                            year = str2double(date(1:4));
                            month = str2double(date(6:7));           
                            if sim_year == year && sim_month == month             
                                for m = 1:24;
                                    Load{k,m} = str2double(devices.PowerLoad{j}.WorkLoad{1}.WorkLoad{p}.Value{m}.CONTENT);
                                end
                            end
                        end 
                        % advances simulation date
                        sim_month = sim_month + 1;
                        if sim_month > 12
                            sim_month = 1;
                            sim_year = sim_year + 1;
                        end
                        k = k + 1;      % advances simulation months counter      
                         
                    % simulation date later than ending climate data date
                    elseif sim_year > init_year || sim_year == init_year && sim_month > init_month
                        % last set of IT load data is repeated to fill the gaps
                        for m = 1:24;
                            Load{k,m} = str2double(devices.PowerLoad{j}.WorkLoad{1}.WorkLoad{n_months}.Value{m}.CONTENT);
                        end
                        % advances simulation date
                        sim_month = sim_month + 1;
                        if sim_month > 12
                            sim_month = 1;
                            sim_year = sim_year + 1;
                        end
                        k = k + 1;      % advances simulation months counter
                    end                  
                 
                end                        
               
                Dev(i).Cap = Load;                         
                IT_Loads = [IT_Loads i];        % array with node numbers associated to IT loads
                num_IT = num_IT + 1;            % number of IT load nodes 
                break;
                
            end
        end 
    end
end

% We now have a structure 'Dev' that has the following fields:
%
% * Name  
% * Type of Device 
% * Number of Connections 
% * Connections 
% * Targets of Connections
% * Node provisioned capacity
% * Device capacity
% * Number of devices
% * Fit
% * Degree of node
% * Load at node
% * Consumed power at node
% * Power required by the node
% * Energy consumed by the node
%
% We also have a cell array "Climate" with weather data for the simulation
% period

% frees memory
clear xmlstr
clear devices
clear layout
clear CM
clear x
clear y
clear fit

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculation
%% The power consumed by each electrical device is the sum of the power its
%% delivers plus the heat dissipated by the device
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% daily average values
Daily_IT = [];
Daily_PUE = [];
Daily_ME = [];

% this array contains monthly average PUE values
mPUE = [];

% these structures are used to calculate daily average load, draw and heat
% values
Dev_Hourly = struct('Name',{},'Type',{},'Load',{},'Pwr',{},'Draw',{});
Dev_Daily = struct('Name',{},'Type',{},'Load',{},'Pwr',{},'Draw',{}); 
for k = 1:numNodes
    Dev_Hourly(k).Name = Dev(k).Name;
    Dev_Hourly(k).Type = Dev(k).Type;
    Dev_Daily(k).Name = Dev(k).Name;
    Dev_Daily(k).Type = Dev(k).Type;
end

% start of simulation cycle
% load and weather data has been synchronised
ndays = 0;                  % number of days in the simulation
month = start_month;
year = start_year;
for i = 1:num_months
        
    % these arrays contain hourly power consumed by segment
    hTotal_P = [];
    hIT_P = [];
    hCooling_P = [];
    hDistrib_P = [];
    hOther_P = [];

    % this array contains hourly average PUE values
    hPUE = [];
    
    % 'Dev_Hourly' structure is reset
    for k = 1:numNodes
        Dev_Hourly(k).Load = 0;
        Dev_Hourly(k).Pwr = 0;
        Dev_Hourly(k).Draw = 0;
    end
    
    % hourly simulation
    for j = 1:24
            
        % average temperature for the hour
        av_temp = Climate{i,j};
   
        % Dev(k).Visit: has the node been visited? (0 = 'no', 1 = 'yes')
        for k = 1:numNodes
            Dev(k).Visit = 0;
        end
     
        % Assigns other loads (e.g. lighting) for the corresponding month and time of
        % day
        for k = 1:num_OL
            Dev(Other_Loads(k)).Load = Dev(Other_Loads(k)).Cap{i,j}; 
        end
        
        % Assigns IT loads for the corresponding month and time of day
        for k = 1:num_IT
            Dev(IT_Loads(k)).Load = Dev(IT_Loads(k)).Cap{i,j};
        end
            
        % Calculates consumed power
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        tmp = walk(Dev, numNodes, IT_Loads, av_temp, mode);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % hourly Load, power, and draw are accumulated for all nodes
        for k = 1:numNodes
            Dev_Hourly(k).Load = Dev_Hourly(k).Load + tmp(k).Load/1e3;
            Dev_Hourly(k).Pwr = Dev_Hourly(k).Pwr + tmp(k).Pwr/1e3;
            Dev_Hourly(k).Draw = Dev_Hourly(k).Draw + tmp(k).Draw/1e3;
        end        
   
        % these variables will contain power consumed during the hour
        Total_pwr = 0;
        IT_pwr = 0;
        Cooling_pwr = 0;
        Distrib_pwr = 0;
        Other_pwr = 0;
            
        % finds total power used by the data centre
        for k = 1:numNodes
            if tmp(k).NumConn == 0                      % a root node
                Total_pwr = Total_pwr + tmp(k).Draw;     % total power consumption
            end
        end
            
        % finds dissipated, IT, cooling and other powers
        for k = 1:numNodes
            if strcmp(Dev(k).Type,'POWER')                    
                Distrib_pwr = Distrib_pwr + tmp(k).Pwr;  % power distribution dissipation 
            elseif strcmp(Dev(k).Type,'LOAD')
                IT_pwr = IT_pwr + tmp(k).Pwr;            % IT consumption
            elseif strcmp(Dev(k).Type,'COOLING')
                Cooling_pwr = Cooling_pwr + tmp(k).Draw;  % Cooling equipment consumption
            elseif strcmp(Dev(k).Type,'OTHER')
                Other_pwr = Other_pwr + tmp(k).Draw;      % 'Other' consumption
            end
        end
            
        % hourly PUE
        if(IT_pwr == 0)
            IT_pwr = 100;
        end
        hPUE = [hPUE Total_pwr/IT_pwr];
            
        % hourly consumed power
        hTotal_P = [hTotal_P Total_pwr];       
        hIT_P = [hIT_P IT_pwr];
        hCooling_P = [hCooling_P Cooling_pwr];
        hDistrib_P = [hDistrib_P Distrib_pwr];
        hOther_P = [hOther_P Other_pwr];
     
    end     % end of hourly simulation cycle
    
    % structure "Dev_Hourly" contains accumulated hourly values
    % here DAILY averages for load, power and draw of each node are
    % calculated
    for k = 1:numNodes
        Dev_Hourly(k).Load = Dev_Hourly(k).Load/24;
        Dev_Hourly(k).Pwr = Dev_Hourly(k).Pwr/24;
        Dev_Hourly(k).Draw = Dev_Hourly(k).Draw/24;
    end   
    
    % calculates DAILY average values for IT and M&E powers as well as PUE
    mean_PUE = mean(hPUE);
    mean_IT = mean(hIT_P)/1e3;
    mean_ME = mean(hCooling_P + hDistrib_P)/1e3;
    
    % repeats simulation data for number of days in each month
    if month == 4 || month == 6 || month == 9 || month == 11    % 30 days
        for m = 1:30
            for k = 1:numNodes
                Dev_Daily(k).Load = [Dev_Daily(k).Load Dev_Hourly(k).Load];
                Dev_Daily(k).Pwr = [Dev_Daily(k).Pwr Dev_Hourly(k).Pwr];
                Dev_Daily(k).Draw = [Dev_Daily(k).Draw Dev_Hourly(k).Draw];
            end  
            Daily_IT = [Daily_IT mean_IT];
            Daily_PUE = [Daily_PUE mean_PUE];
            Daily_ME = [Daily_ME mean_ME];                 
        end
        ndays = ndays + 30;     % accumulates number of days
    elseif month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12   % 31 days
        for m = 1:31
            for k = 1:numNodes
                Dev_Daily(k).Load = [Dev_Daily(k).Load Dev_Hourly(k).Load];
                Dev_Daily(k).Pwr = [Dev_Daily(k).Pwr Dev_Hourly(k).Pwr];
                Dev_Daily(k).Draw = [Dev_Daily(k).Draw Dev_Hourly(k).Draw];
            end   
            Daily_IT = [Daily_IT mean_IT];
            Daily_PUE = [Daily_PUE mean_PUE];
            Daily_ME = [Daily_ME mean_ME];           
        end   
        ndays = ndays + 31;     % accumulates number of days    
    elseif month ==2            % february
        if (mod(year,4) == 0 && mod(year,100) ~= 0) || (mod(year,4) == 0 && mod(year,100) == 0 && mod(year,400) == 0)  % leap year
            for m = 1:29
                for k = 1:numNodes
                    Dev_Daily(k).Load = [Dev_Daily(k).Load Dev_Hourly(k).Load];
                    Dev_Daily(k).Pwr = [Dev_Daily(k).Pwr Dev_Hourly(k).Pwr];
                    Dev_Daily(k).Draw = [Dev_Daily(k).Draw Dev_Hourly(k).Draw];
                end   
                Daily_IT = [Daily_IT mean_IT];
                Daily_PUE = [Daily_PUE mean_PUE];
                Daily_ME = [Daily_ME mean_ME];                     
            end 
            ndays = ndays + 29;     % accumulates number of days            
        else                        % not a leap year
            for m = 1:28
                for k = 1:numNodes
                    Dev_Daily(k).Load = [Dev_Daily(k).Load Dev_Hourly(k).Load];
                    Dev_Daily(k).Pwr = [Dev_Daily(k).Pwr Dev_Hourly(k).Pwr];
                    Dev_Daily(k).Draw = [Dev_Daily(k).Draw Dev_Hourly(k).Draw];
                end  
                Daily_IT = [Daily_IT mean_IT];
                Daily_PUE = [Daily_PUE mean_PUE];
                Daily_ME = [Daily_ME mean_ME];                  
            end  
            ndays = ndays + 28;     % accumulates number of days                       
        end
    end
    
    month = month + 1;
    if month > 12
        month = 1;
        year = year + 1;
    end
end

%% results are written in a file called
%% NAME_results.xml

out{1}.Name = name;

out{2}.Results.Name = 'Data Centre';
out{2}.Results.Label = 'Daily Average PUE';
out{2}.Results.SummaryLabel = 'Simulation Average';
out{2}.Results.SummaryValue = mean(Daily_PUE);
for i = 1:ndays
    out{2}.Results.Results.Data(i) = Daily_PUE(i);
end

out{3}.Results.Name = 'Data Centre';
out{3}.Results.Label = 'Daily average IT load (kW)';
out{3}.Results.SummaryLabel = 'Simulation Average (kW';
out{3}.Results.SummaryValue = mean(Daily_IT);
for i = 1:ndays
    out{3}.Results.Results.Data(i) = Daily_IT(i);
end

out{4}.Results.Name = 'Data Centre';
out{4}.Results.Label = 'Daily average M&E draw (kW)';
out{4}.Results.SummaryLabel = 'Simulation Average (kW';
out{4}.Results.SummaryValue = mean(Daily_ME);
for i = 1:ndays
    out{4}.Results.Results.Data(i) = Daily_ME(i);
end

% writes result information for each data centre node
i = 1;
count = 5;
while i <= numNodes
    
    switch Dev_Daily(i).Type
        case 'POWER'
            out{count}.Results.Name = Dev_Daily(i).Name;
            out{count}.Results.Label = 'Daily average draw (kW)';
            out{count}.Results.SummaryLabel = 'Simulation Average (kW)';
            out{count}.Results.SummaryValue = mean(Dev_Daily(i).Draw);
            for j = 1:ndays
                out{count}.Results.Results.Data(j) = Dev_Daily(i).Draw(j);
            end
            count = count + 1;
        case 'OTHER'
            out{count}.Results.Name = Dev_Daily(i).Name;
            out{count}.Results.Label = 'Daily average load (kW)';
            out{count}.Results.SummaryLabel = 'Simulation Average (kW)';
            out{count}.Results.SummaryValue = mean(Dev_Daily(i).Load);
            for j = 1:ndays
                out{count}.Results.Results.Data(j) = Dev_Daily(i).Load(j);
            end  
            count = count + 1;
        case 'COOLING' 
            % node draw
            out{count}.Results.Name = Dev_Daily(i).Name;
            out{count}.Results.Label = 'Daily average draw (kW)';
            out{count}.Results.SummaryLabel = 'Simulation Average (kW)';
            out{count}.Results.SummaryValue = mean(Dev_Daily(i).Draw);
            for j = 1:ndays
                out{count}.Results.Results.Data(j) = Dev_Daily(i).Draw(j);
            end  
            count = count + 1;
            
            % node heat
            out{count}.Results.Name = Dev_Daily(i).Name;
            out{count}.Results.Label = 'Daily average heat (kW)';
            out{count}.Results.SummaryLabel = 'Simulation Average (kW)';
            out{count}.Results.SummaryValue = mean(Dev_Daily(i).Load);
            for j = 1:ndays
                out{count}.Results.Results.Data(j) = Dev_Daily(i).Load(j);
            end  
            count = count + 1;       
        case 'LOAD'
            out{count}.Results.Name = Dev_Daily(i).Name;
            out{count}.Results.Label = 'Daily average load (kW)';
            out{count}.Results.SummaryLabel = 'Simulation Average (kW)';
            out{count}.Results.SummaryValue = mean(Dev_Daily(i).Load);
            for j = 1:ndays
                out{count}.Results.Results.Data(j) = Dev_Daily(i).Load(j);
            end  
            count = count + 1;            
    end
            
    i = i + 1;
    
end

% includes dates for the simulation
year = start_year;
month = start_month;
i = 1;
while i <= ndays
    
    % determines number of days for month
    if month == 4 || month == 6 || month == 9 || month == 11    % 30 days
        top = 30;
    elseif month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12   % 31 days
        top = 31;
    elseif month == 2    % february
        if (mod(year,4) == 0 && mod(year,100) ~= 0) || (mod(year,4) == 0 && mod(year,100) == 0 && mod(year,400) == 0)
            top = 29;    % leap year
        else
            top = 28;
        end       
    end
    
    for j = 1:top
       if month < 10 && j < 10
          out{count}.Times{i} = strcat(num2str(year),'-','0',num2str(month),'-','0',num2str(j));
       elseif month < 10 && j >= 10
          out{count}.Times{i} = strcat(num2str(year),'-','0',num2str(month),'-',num2str(j));           
       elseif month >= 10 && j < 10
          out{count}.Times{i} = strcat(num2str(year),'-',num2str(month),'-','0',num2str(j));                  
       elseif month >= 10 && j >= 10
          out{count}.Times{i} = strcat(num2str(year),'-',num2str(month),'-',num2str(j));        
       end
       i = i + 1;
    end 
    
    month = month + 1;
    if month > 12
        year = year + 1;
        month = 1;
    end
    
end
 
% converts output structure to xml string
xmlstr = xml_format(out,'off','SimulationResultsElement');

%%
% string manipulation: this is necessary in order to format the xml file
% appropriately

% searches for string '<item>' and deletes it"
a = strfind(xmlstr,'<item>');
b = a + 6;
num = length(a);
c = strfind(xmlstr,'<Times>');
for i = num:-1:1
    for j = a(i):-1:1
        if xmlstr(j) == char(10)     % searches for blank space
            lower = j;
            break;
        end
    end
    if lower < c     % deletes string '<item>' if it is not within <Times></Times>
        xmlstr = [xmlstr(1:lower) xmlstr(b(i) + 1:length(xmlstr))];
    end
end

% searches for string '</item>' and deletes it"
a = strfind(xmlstr,'</item>');
b = a + 7;
num = length(a);
c = strfind(xmlstr,'<Times>');
d = strfind(xmlstr,'</Times>');
for i = num:-1:1
    for j = a(i):-1:1
        if xmlstr(j) == char(10)     % finds a \newline
            lower = j;
            break;
        end
    end
    if lower < c || lower > d 
        xmlstr = [xmlstr(1:lower) xmlstr(b(i) + 1:length(xmlstr))];
    end
end

% formats data fields
a = strfind(xmlstr,'<Data>');
b = strfind(xmlstr,'</Data>');
num1 = length(a);
for i = num1:-1:1
    c = strfind(xmlstr(a(i):b(i)),char(32)); 
    c = c + a(i) - 1;
    num2 = length(c);
    for j = num2:-1:1
        xmlstr = [xmlstr(1:c(j)-1) '</Data>' char(10) '        <Data>' xmlstr(c(j)+1:length(xmlstr))];
    end
end

% gives date fields proper format
a = strfind(xmlstr,'<item>');
xmlstr = strrep(xmlstr,'<item>','<Data>');
b = strfind(xmlstr,'</item>');
xmlstr = strrep(xmlstr,'</item>','</Data>');

%%

% saves resulting XML output file
name = strcat(name,'_results.xml');
heading = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>';
sal = fopen(name,'w+');
fprintf(sal,'%s',heading);
fprintf(sal,'\n%s',xmlstr);

fclose('all');

rc = 0;

toc
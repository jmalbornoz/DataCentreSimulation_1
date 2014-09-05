% TR_1D_model1_SS\get_input_scalar.m
%
% function value = get_input_scalar(prompt, ...
% check_real,check_sign,check_int);
%
% This MATLAB m-file gets from the user an
% input scalar value of the appropriate type.
% It asks for input over and over again
% until a correctly typed input value
% is entered.
%
% Kenneth Beers
% Massachusetts Institute of Technology
% Department of Chemical Engineering
% 7/2/2001
%
% Version as of 7/25/2001

function value = get_input_scalar(prompt,check_real,check_sign,check_int);
func_name = 'get_input_scalar'; 
name = 'trial_value';

input_OK = 0;

while (input_OK ~= 1) 
    
    trial_value = input(prompt); 
    [iflag_assert,message] = ...
    assert_scalar(0,trial_value,name,func_name,check_real,check_sign,check_int);

    if(iflag_assert == 1) 
        input_OK = 1; 
        value = trial_value;
    else
        disp(message);
    end
    
end

return;
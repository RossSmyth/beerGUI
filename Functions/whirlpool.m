function IOStruct = whirlpool(IOStruct)
%whirlpool(IOStruct) - Calculates whirlpool inputs and outputs
%
%   Inputs:
%       1 - IOStruct = The Input Output struct from the main script
%
%   Outputs:
%       1 - IOStruct = The new Input Output struct from the main script

    trubOut = IOStruct.whirl.in.wort(2) + IOStruct.whirl.in.wort(3) / 16; % Pounds
    
    IOStruct.whirl.out.trub = trubOut;
    IOStruct.whirl.out.wort = IOStruct.whirl.in.wort(1);
end




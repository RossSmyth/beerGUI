function IOStruct = mashing(IOStruct)
%mashing(IOStruct) - Calculates the water needed to input and the wort
%                    outputted by mashing
%
%   Inputs:
%       1 - IOStruct = The Input Output struct from the main script
%
%   Outputs:
%       1 - IOStruct = The new Input Output struct from the main script
    IOStruct.mash.in.grain = IOStruct.mill.out.grain;

    wortWater                = IOStruct.mash.in.water; % Gallons
    wortGrain                = IOStruct.mash.in.grain; % Pounds
    IOStruct.mash.out.wort   = [wortWater, wortGrain]; % [Gallons, Pounds]
end


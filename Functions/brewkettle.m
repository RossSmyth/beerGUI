function IOStruct = brewkettle(IOStruct)
%brewkettle(IOStruct) - Calculates the brewkettle inputs and outputs
%
%   Inputs:
%       1 - IOStruct = The Input Output struct from the main script
%
%   Outputs:
%       1 - IOStruct = The new Input Output struct from the main script
    
    %For the conversion and ease of use
    waterIn = IOStruct.brew.in.water;
    wortIn  = IOStruct.brew.in.wort;
    hopsIn  = IOStruct.brew.in.hops;
    
    waterOut   = (wortIn(1) + waterIn) * (0.0625 / 0.75); % Gallons
    waterDelta = waterIn - waterOut; % Gallons delta
    
    wortOut = [wortIn(1) + waterDelta, wortIn(2), hopsIn]; % [Water (Gallons), Grain (Pounds), Hops (Ounces)]
    
    IOStruct.brew.out.wort = wortOut; % [Water (Gallons), Grain (Pounds), Hops (Ounces)]
end


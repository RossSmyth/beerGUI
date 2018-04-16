%{
Copyright 2018 Christopher Smyth

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0
   
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
%}

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


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
function IOStruct = lauter(IOStruct)
%lauter(IOStruct) - Calculates inputs and outputs of Lauter Tun given wort in
%
%   Inputs:
%       1 - IOStruct = The Input Output struct from the main script
%
%   Outputs:
%       1 - IOStruct = The new Input Output struct from the main script
    
    %Just to ease typing a bunch each time
    wortIn  = IOStruct.mash.out.wort;
    waterIn = IOStruct.lauter.in.water;
    
    grainOut = 0.2 * wortIn(2); % Pounds from slideshow
    
    waterOut = 0.1 * wortIn(1); % Gallons from slideshow
    
    wortOut  = wortIn + [waterIn - waterOut, -grainOut]; % [Water (gallons), Grain (Pounds)]
    
    %Puts all the stuff in the struct
    IOStruct.lauter.in.wort  = wortIn;
    
    IOStruct.lauter.out.water = waterOut;
    IOStruct.lauter.out.grain = grainOut;
    IOStruct.lauter.out.wort  = wortOut;
    
end


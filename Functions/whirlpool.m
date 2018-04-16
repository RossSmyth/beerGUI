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




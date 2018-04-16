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

function [yeast, glucose, ethanol, co2, time] = fermentation(grainAmount)
%fermentation(grainAmount) - Calculates fermentation process amounts and
%                            how they change 
%
%   Inputs:
%       1 - grainAmount = Grain inputted in Pounds
%
%   Outputs:
%       1 - yeast   = Array of Pounds / Gallon of yeast during fermentation
%       2 - glucose = Array of Pounds / Gallon of glucose during fermentation
%       3 - ethanol = Array of Pounds / Gallon of ethanol alcohol during fermentation
%       4 - co2     = Array of Pounds / Gallon of CO2 during fermentation
%       5 - time    = Array of hours passed to each data point
    
    Umax    = 0.07; % Max time constant
    SatConc = 1.2; % Pound / Gallon
    
    yeastYield   = 0.163; % I don't even know what these are
    ethanolYield = 0.388; % Pretty sure they are dimensionless constants
    co2Yield     = 0.44; 
    
    intiGlucose = 0.7 * grainAmount; % Pounds / Gallon
    intiYeast   = grainAmount * 0.013 / 8; % Pound / Gallon
    
    dt = .0001;
    
    % Initial values
    yeast   = intiYeast;  % Pounds / Gallon 
    ethanol = 0; % Pounds / Gallon same
    glucose = intiGlucose; % Pounds / Gallon 
    co2     = 0; % Pounds / Gallon same 
    
    while glucose(end) >= 0
        % Big ugly differential equation for changes. Let's ignore that
        % MATLAB has a builtin diff eq solver
        yeastChange   = Umax * ( yeastYield * intiGlucose + intiYeast - yeast(end)) * yeast(end) / (SatConc * yeastYield + yeastYield * intiGlucose + intiYeast - yeast(end));
        glucoseChange = -yeastChange / yeastYield;
        ethanolChange = -glucoseChange * ethanolYield;
        co2Change     = -glucoseChange * co2Yield;
        
        %Now to apply these changes
        yeast(end + 1)   = yeast(end) + yeastChange * dt;
        ethanol(end + 1) = ethanol(end) + ethanolChange * dt;
        glucose(end + 1) = glucose(end) + glucoseChange * dt;
        co2(end + 1)     = co2(end) + co2Change * dt;
    end
    
    % I can almost guarentee that it didn't run perfectly so let's remove
    % the negative sugar values and all data associated
    if glucose(end) < 0
        glucose(end) = [];
        yeast(end)   = [];
        ethanol(end) = [];
        co2(end)     = [];
    end
    
    %These graphs level off, but the sugar is always above zero for the
    %domain, for some reason MATLAB makes it look like that isn't true
    %though
    
    time = 0:dt:((dt * length(glucose)) - dt); % Hours Time vector for plotting
end

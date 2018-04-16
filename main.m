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

%Clears and adds the folders to path
clear, clc
addpath Functions Objects

%Struct to store all the I/O so I don't need 1 billion variables
breweryInOut = struct();

%% ------------------------------Milling----------------------------------

%Input dialog
inputs   = {'Grain input (Pounds)'};
dlgTitle = 'Mill Grain input';
rawInput = inputdlg(inputs, dlgTitle);

breweryInOut.mill.in.grain  = str2double(rawInput(1)); % Pounds
breweryInOut.mill.out.grain = breweryInOut.mill.in.grain;

%Confirmation Dialog
conStr = sprintf('The Mill got input %g pounds of grain\nand output %g pounds of grain', ...
                  breweryInOut.mill.in.grain, ...
                  breweryInOut.mill.out.grain);
confirmation(conStr)

%% -----------------------------------Mashing------------------------------

%Input dialog
inputs   = {'Water input (Gallons)'};
dlgTitle = 'Mash Water input';
rawInput = inputdlg(inputs, dlgTitle);

breweryInOut.mash.in.water = str2double(rawInput(1)); %Gallons

%Gets the wort
breweryInOut = mashing(breweryInOut);

conStr = sprintf(['Mashing had inputs of:\n%g Gallons of water\n%g Pounds ' ...
                 'of grain\n\nIt had outputs of:\n%g Gallons of wort'], ...
                 breweryInOut.mash.in.water, breweryInOut.mash.in.grain, ...
                 breweryInOut.mash.out.wort(1));
confirmation(conStr)

%% ------------------------------Lauter------------------------------------

%Input dialog
inputs   = {'Water input (Gallons)'};
dlgTitle = 'Lauter Water input';
rawInput = inputdlg(inputs, dlgTitle);

breweryInOut.lauter.in.water = str2double(rawInput(1)); %Gallons

%Calculates I/O
breweryInOut = lauter(breweryInOut);

conStr = sprintf(['Lautering had inputs of:\n%g Gallons of wort\n'...
                  '%g Gallons of water\n\nIt had outputs of:\n%g Gallons'...
                  ' of wort\n%g Gallons of water\n%g Pounds of grain'], ...
                  breweryInOut.lauter.in.wort(1), breweryInOut.lauter.in.water, ...
                  breweryInOut.lauter.out.wort(1), breweryInOut.lauter.out.water, ...
                  breweryInOut.lauter.out.grain);
confirmation(conStr)

%% --------------------------Brewkettle------------------------------------
breweryInOut.brew.in.wort = breweryInOut.lauter.out.wort; %[Gal, Pounds]

%Input dialog
inputs   = {'Adjustment Water input (Gallons)'};
dlgTitle = 'Brew Water input';
rawInput = inputdlg(inputs, dlgTitle);

breweryInOut.brew.in.water = str2double(rawInput(1)); %Gallons

%Intializes the selection menu
hopsSelection = hopsSelector(breweryInOut.brew.in.wort(1) + breweryInOut.brew.in.water);

%Runs the selector
drawnow
while hopsSelection.running
    drawnow
end

%Gets selection
breweryInOut.brew.in.hops = hopsSelection.weight; %Hops in ounces
beerIBU                   = hopsSelection.IBU; %IBU

%Deletes the selector figure
hopsSelection.delete()

breweryInOut = brewkettle(breweryInOut);


conStr = sprintf(['The Brewkettle had inputs of:\n%g Gallons of wort\n'...
                  '%g Gallons of adjustment water\n%g Ounces of hops\n\n'...
                  'It had outputs of:\n%g Gallons of wort\n'], ...
                  breweryInOut.brew.in.wort(1), breweryInOut.brew.in.water, ...
                  breweryInOut.brew.in.hops, breweryInOut.brew.out.wort(1));
confirmation(conStr)

%% ----------------------------Whirlpool-----------------------------------
breweryInOut.whirl.in.wort = breweryInOut.brew.out.wort; %[Water, Grain, Hops]

breweryInOut = whirlpool(breweryInOut);

conStr = sprintf(['The Whirlpool had inputs of:\n%g Gallons of wort\n\n'...
                  'It had outputs of:\n%g Gallons of wort\n%g Pounds of trub'], ...
                  breweryInOut.whirl.in.wort(1), breweryInOut.whirl.out.wort, ...
                  breweryInOut.whirl.out.trub);
confirmation(conStr)

%% ---------------------------Heat Exchange--------------------------------
breweryInOut.heat.in.wort  = breweryInOut.whirl.out.wort; % Gallons
breweryInOut.heat.out.wort = breweryInOut.heat.in.wort; % Gallons

conStr = sprintf(['The Heat Exchanger had inputs of:\n%g Gallons of wort\n\n'...
                  'It had outputs of:\n%g Gallons of cool wort'], ...
                  breweryInOut.heat.in.wort, breweryInOut.heat.out.wort);
confirmation(conStr)

%% -------------------------------Fermentation-----------------------------

FGrainIn = breweryInOut.whirl.in.wort(2); %The last time grain existed

%Fermentation simulation
[FyeastOut, FglucoseOut, FethanolOut, Fco2Out, Ftime] = fermentation(FGrainIn);

fermentationSim = fermentationApp(FyeastOut, FglucoseOut, FethanolOut, Fco2Out, Ftime);
drawnow

%Runs the simulation figure till it is closed
while fermentationSim.running
    drawnow
end
fermentationSim.delete()

breweryInOut.ferment.in.wort    = breweryInOut.heat.out.wort;
breweryInOut.ferment.in.yeast   = FyeastOut(1);
breweryInOut.ferment.in.glucose = FglucoseOut(1);

breweryInOut.ferment.out.yeast   = FyeastOut(end);
breweryInOut.ferment.out.ethanol = FethanolOut(end);
breweryInOut.ferment.out.co2     = Fco2Out(end);
breweryInOut.ferment.out.beer    = breweryInOut.ferment.in.wort;

ethanolVol = breweryInOut.ferment.out.ethanol / 6.58; %Gallons
beerABV    = ethanolVol / breweryInOut.ferment.in.wort;

conStr = sprintf(['The fermenter had inputs of:\n%g Gallons of wort\n'...
                  '%g Pounds of yeast\n%g Pounds of Sugar\n\n'...
                  'It had outputs of\n%g Pounds of yeast\n'...
                  '%g Gal of alcohol\n%g Pounds of CO_2\n%g Gallons of beer'], ...
                  breweryInOut.ferment.in.wort, breweryInOut.ferment.in.yeast, ...
                  breweryInOut.ferment.in.glucose, breweryInOut.ferment.out.yeast, ...
                  ethanolVol, breweryInOut.ferment.out.co2, breweryInOut.ferment.out.beer);
confirmation(conStr)

%% -------------------------Cold Storage-----------------------------------

breweryInOut.storage.in.beer  = breweryInOut.ferment.out.beer; % Gallons

conStr = sprintf('%g Gallons of beer went into Cold storage', ...
                  breweryInOut.storage.in.beer);
confirmation(conStr)

%% ----------------------------Table---------------------------------------
save('IOStruct.mat', 'breweryInOut')
drawnow
tableMenu = outputTables(beerIBU, beerABV);

















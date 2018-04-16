function confirmation(confirmString)
%confirmation(confirmString) Ask the user for confirmation of inputs
%
%   Inputs:
%       confirmString = String displayed
questdlg(confirmString, 'Confirmation', 'Ok', 'Ok');
end


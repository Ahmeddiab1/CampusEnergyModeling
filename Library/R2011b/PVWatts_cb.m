%% Function: Implements callbacks for 'PVWatts' block
% This function implements the mask callbacks for the 'PVWatts' block in
% the NREL Campus Modeling Simulink block library. It is designed to be
% called from the block mask.
%
% SYNTAX:
%   varargout = PVWatts_cb(block, callback, varargin)
%
% INPUTS:
%   block =     Simulink block path
%   callback =  String specifying the callback to perform; see code
%   varargin =  Inputs which vary depending on the callback; see code
%
% OUTPUTS:
%   varargout = Outputs which vary depending on the callback
%
% COMMENTS:
% 1. This function is not intended for use outside of the NREL Campus
%    Modeling Simulink library; therefore the error checking and
%    documentation are minimal. View the code to see what is going on.

function varargout = PVWatts_cb(block, callback, varargin)
    %% Setup
    % Default output = none
    varargout = {};

    %% Callbacks
    % Select and execute desired callback
    switch callback
        % Initialization
        case 'init'
            PVWatts_cb_init(block, varargin{:});
            
        case 'redraw_mask'
            PVWatts_cb_redraw_mask(block);
            
        case 'use_lat_tilt'
            PVWatts_cb_use_lat_tilt(block);
           
        case 'track_mode'
            PVWatts_cb_track_mode(block);
            
        case 'use_cell_data'
            PVWatts_cb_use_cell_data(block);
            
        otherwise
            warning([block ':unimplementedCallback'], ...
                ['Callback ''' callback ''' not implemented.']);
        
    end
end

%% Subfunctions
% Initialization
function PVWatts_cb_init(block)
    % Nothing happens here
end

% Redraw mask
function PVWatts_cb_redraw_mask(block)
    % Block label, image, input ports
    lf = char(10);
    maskdisplay = [ ...
        '% This mask display is automatically generated by PVWatts_cb()' lf ...
        'image(imread(''pvwatts_light.png''))' lf ...
        'disp(''PVWatts\nCosimulation'')' lf ...
        lf ...
        '% Label input ports' lf ...
        'port_label(''input'', 1, ''Beam''); % Beam irradiance (W/m^2)' lf ...
        'port_label(''input'', 2, ''Diffuse''); % Diffuse irradiance (W/m^2)' lf ...
        'port_label(''input'', 3, ''Temp''); % Ambient temperature (deg C)' lf ...
        'port_label(''input'', 4, ''Wind''); % Wind speed (m/s)' lf ...
        lf ...
        '% Label output ports' lf ...
        ];
    
    % Block output ports
    i = 1;
    if strcmp( get_param(block, 'output_dc'), 'on' )
        port = sprintf('%i', i);
        lab = 'DC power';
        desc = 'DC output power (W)';
        maskdisplay = [ maskdisplay ...
            'port_label(''output'', ' port ', ''' lab '''); % ' desc lf ...
            ];
        i = i + 1;
    end
    if strcmp( get_param(block, 'output_celltemp'), 'on' )
        port = sprintf('%i', i);
        lab = 'Cell Temp';
        desc = 'Cell Temperature (deg C)';
        maskdisplay = [ maskdisplay ...
            'port_label(''output'', ' port ', ''' lab '''); % ' desc lf ...
            ];
        i = i + 1;
    end
    if strcmp( get_param(block, 'output_poa'), 'on' )
        port = sprintf('%i', i);
        lab = 'POA Irradiance';
        desc = '% Point of array irradiance';
        maskdisplay = [ maskdisplay ...
            'port_label(''output'', ' port ', ''' lab '''); % ' desc lf ...
            ];
    end
    
    % Write the display
    set_param(block, 'MaskDisplay', maskdisplay);
end

% Modify mask dialog - use latitude tilt
function PVWatts_cb_use_lat_tilt(block)
    % Automatically fills the tilt angle with the latitude value if the
    % user has opted to use a latitude tilt angle
    
    % Get enables
    enab = get_param(block, 'MaskEnables');
    
    % Define the indices for parameters in the mask
    xTILT = 9;
    
    % Set parameters and enables based on checkbox
    if strcmp( get_param(block, 'use_lat_tilt'), 'on' )
        tilt = strrep(get_param(block, 'lat'), '-', '');
        set_param(block, 'tilt', tilt);
        enab{xTILT} = 'off';
    else
        enab{xTILT} = 'on';
    end
    set_param(block, 'MaskEnables', enab);
end

% Modify mask dialog - tracking mode
function PVWatts_cb_track_mode(block)
    % Automatically hides the tracking limits if a fixed array is selected
    
    % Get visibilities
    vis = get_param(block, 'MaskVisibilities');
    
    % Define the indices for parameters in the mask
    xROTLIM = 12;
    
    % Set dialog visibility based on checkbox
    if strcmp( get_param(block, 'track_mode'), 'Fixed' )
        vis{xROTLIM} = 'off';
    else
        vis{xROTLIM} = 'on';
    end
    set_param(block, 'MaskVisibilities', vis);
end

% Modify mask dialog - customized PV cell data
function PVWatts_cb_use_cell_data(block)
    % Enables or disables the extra cell data input fields based on whether
    % the appropriate checkbox is checked
    
    % Get enables
    enab = get_param(block, 'MaskEnables');
    
    % Define the indices for parameters in the mask
    xTREF =     14;
    xTNOCT =    15;
    xGAMMA =    16;
    xIREF =     17;
    xPOACUTIN = 18;
    
    % Set parameters and enables based on checkbox
    if strcmp( get_param(block, 'use_cell_data'), 'off' )
        % Values
        set_param(block, 't_ref', '25')
        set_param(block, 't_noct', '45')
        set_param(block, 'gamma', '-0.5')
        set_param(block, 'i_ref', '1000')
        set_param(block, 'poa_cutin', '0')
        
        % Enables
        enab{xTREF} =       'off';
        enab{xTNOCT} =      'off';
        enab{xGAMMA} =      'off';
        enab{xIREF} =       'off';
        enab{xPOACUTIN} =   'off';
    else
        % Enables
        enab{xTREF} =       'on';
        enab{xTNOCT} =      'on';
        enab{xGAMMA} =      'on';
        enab{xIREF} =       'on';
        enab{xPOACUTIN} =   'on';
    end
    set_param(block, 'MaskEnables', enab);
end
%%% plot_electrode %%%
% Generates coordinates of an electrode structure consisting of active 
% material and carbon black particles for export to 3d modelling software.
% In Inventor or Solidworks use 'sketch driven pattern' after constructing
% one sphere on one of the points to duplicate on all points.

clear
clc

%% Parameters

load_parameters = 0;

if load_parameters == 1
    load default_parameters.mat             % Allows loading of parameters from a .mat file
else
    % Structure
    layers_total = 1;                       % Number of different AM layers ('grad' for graded)
    grad_dist = [1 0.8 0.6 0.4 0.2 0];      % Ratio of AM1 to AM2 per graded layer
    grad_bins = length(grad_dist);

    % Dimensions [x y z] and volume fraction
    dim = [90 90 40];                       % [x y z] dimensions
    max_vol_fraction = 0.7;                 % Volume fraction of AM spheres
    attempts = 400000;                      % How many attempts to generate a sphere in the volume

    % Size of AM spheres, allowable distance
    r_am = 5.5;                             % Radius of AM particles (default: 4.6)
    minDist = r_am * 1.75;                  % def: r_am * 1.75

    % Carbon black
    cb_gen = 1;                             % 0 = off, 1 = normal, 2 = graded
    cb_location = [1 0 1];                  % [1 0 1] = cb in layer 1 and layer 3 (only used in layered electrodes)
    n_cb_dist = [8 7 6 5 4 3];              % Number of cb on each descretised layer
    cb_grad_bins = length(n_cb_dist);       % Graded: Number of discrete layers of cb

    r_cb = r_am / 6;                        % Radius of carbon particles (default: r_am / 6)
    n_cb = floor(8 * r_am / 5.5);           % Number of carbon particles on AM surface (default: floor(8 * r_am / 5.5);)
    cb_distance = (r_am-(r_cb*0.5))/r_am;   % Percentage distance of cb from centre of AM
                                            % where 1 is where the surfaces are
                                            % tangential (default: (r_am-(r_cb*0.5))/r_am))

    % Plot settings
    plot_am = 1;
    plot_cb = 1;                            %(WARNING: Very slow if lots of CB (i.e. over 1000))

    % Inventor settings
    units = {'mm'};                         % Required for files imported into Inventor
end

%% Timer

% Start timer
tTotal = tic;

%% Generate AM coords

timer_start_am = tic;

% Generate AM coords
[am_cent, V, v] = generate_am(dim, max_vol_fraction, attempts, r_am, minDist);

% Output
am_time = toc(timer_start_am);
disp([num2str(height(am_cent)), ' AM particles generated in ', num2str(am_time), 's'])

fig_A = scatter3( am_cent.x, am_cent.y, am_cent.z );
grid on;
hold on

%% Filter AM coords by layer or gradient & export

if isnumeric(layers_total) && layers_total == 1
    layer = 1;
    filename = 'points_AM.xlsx';
    writecell(units,filename)
    writetable(am_cent,filename,'Sheet',1,'Range','A2')
    disp('Exported AM points file')
elseif isnumeric(layers_total) && layers_total > 1
    layer = generate_layers(am_cent, layers_total, dim(3), units);
end

if strcmp(layers_total,'grad')
    layer = generate_grad_am(am_cent, grad_bins, grad_dist, units);
end

%% Plot AM spheres

[X,Y,Z] = sphere;

% Generate active sphere size
am_surf_x = X * r_am;
am_surf_y = Y * r_am;
am_surf_z = Z * r_am;

for i = 1:height(am_cent)
    if plot_am == 1
        % Plot active spheres at AM center coords
        surf(   am_surf_x + am_cent.x(i),...
                am_surf_y + am_cent.y(i),...
                am_surf_z + am_cent.z(i)    );
    end
end

%% Generate CB coords and plot CB spheres

if cb_gen == 1
    cb_cent = generate_cb(am_cent, r_am, r_cb, cb_distance, layers_total, cb_location, layer, n_cb, plot_cb);
elseif cb_gen == 2
    cb_cent = generate_grad_cb(am_cent, r_cb, cb_grad_bins, n_cb_dist, r_am, cb_distance, plot_cb);
end

hold off

%% Final calculations for export

vol_fraction = v/V;                 % Rough estimate as some volume will be overlapping
d_am = r_am * 2;

% Export CB points and perform volume fraction calculations
if cb_gen > 0 
    v_with_cb = v + height(cb_cent)*(4/3 * pi * r_cb^3);
    d_cb = r_cb * 2;
    vol_fraction_with_cb = v_with_cb/V; % Rough estimate as some volume will be overlapping
    filename = 'points_CB.xlsx';
    writecell(units,filename)
    writetable(cb_cent,filename,'Sheet',1,'Range','A2')
    disp('Exported CB points file')
end
tTotalEnd = toc(tTotal);

disp(['Finished in: ',num2str(tTotalEnd),'s'])

clearvars -except layer cb_cent vol_fraction d_am d_cb r_combined vol_fraction_with_cb n_cb am_cent




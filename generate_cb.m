function cb_cent = generate_cb(am_cent, r_am, r_cb, cb_distance, layers_total, cb_location, layer, n_cb, plot_cb)
% randomly generates CB particles of a particular size on the surface
% of previously generated AM particles

% --------------
% Function start
% --------------

timer_start_cb = tic;

[X,Y,Z] = sphere;

% Generate carbon sphere
cb_surf_x = X * r_cb;
cb_surf_y = Y * r_cb;
cb_surf_z = Z * r_cb;

% Filter AM layers that have CB
if (isnumeric(layers_total) && layers_total == 1) || strcmp(layers_total,'grad')
    am_cent_with_cb = am_cent;
elseif isnumeric(layers_total) && layers_total > 1
    for i = 1:layers_total
        if cb_location(i) == 1
            if exist('am_cent_with_cb','var') == 0
                am_cent_with_cb = layer(i).points;
            else
                am_cent_with_cb = [am_cent_with_cb; layer(i).points];
            end
        end
    end
end

% Array for cb centers
cb_total = height(am_cent_with_cb) * n_cb;

% Generate cb on AM
for i = 1:height(am_cent_with_cb)
    % Radius of active sphere + radius of carbon
    r_combined = (r_am + r_cb)*cb_distance;
    
    % Random spherical coords
    TH = 2*pi*rand(1,n_cb);
    PH = asin(-1+2*rand(1,n_cb));
    
    % Generate cartesian coords for center of each carbon particle on
    % surface of sphere of radius 'r_combined'
    [ cb_cent_temp(:,1), cb_cent_temp(:,2), cb_cent_temp(:,3) ] = sph2cart(TH,PH,r_combined);
    
    % Adjust cb coords relative to AM center
    cb_cent_temp = cb_cent_temp + table2array(am_cent_with_cb(i,:));
    
    % Save cb_cent to array for export
    lb = 1 + i * n_cb - n_cb;   % lower bound for iteration
    ub = i * n_cb;              % upper bound for iteration
    cb_cent( lb : ub, : ) = cb_cent_temp;
    
    % Plot cb particles
    if plot_cb == 1
        for count = 1 : n_cb
            surf(   cb_surf_x + cb_cent_temp( count, 1 ),...
                cb_surf_y + cb_cent_temp( count, 2 ),...
                cb_surf_z + cb_cent_temp( count, 3 )     );
        end
    end
    
    % Output
    remainder = rem(height(am_cent_with_cb),10);
    len = height(am_cent_with_cb) + (10-remainder);
    if floor(i/(len/10)) == i/(len/10)
        cb_time = toc(timer_start_cb);
        disp([num2str(i*n_cb), '/', num2str(cb_total), ' CB particles generated in ', num2str(cb_time), 's'])
    end
    
end

% Create table
cb_cent = array2table(cb_cent,'VariableNames',{'x','y','z'});

end


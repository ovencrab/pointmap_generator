function cb_cent = generate_grad_cb(am_cent, r_cb, cb_grad_bins, n_cb_dist, r_am, cb_distance, plot_cb)
% generate_grad_am - filters AM into distribution in z dimension

% --------------
% Function start
% --------------

timer_start_cb = tic;

% Coords
[X,Y,Z] = sphere;

% Generate carbon sphere
cb_surf_x = X * r_cb;
cb_surf_y = Y * r_cb;
cb_surf_z = Z * r_cb;

% Discretize AM coords into bins
[bin,~] = discretize(am_cent.z, cb_grad_bins);

cb_total = 0;
% Find am index for coords in each bin
for L = cb_grad_bins:-1:1
    cb_grad_layer(L).idx = find(bin == L);
    cb_layer(L).points = am_cent(cb_grad_layer(L).idx,:);
    
    cb_total_temp = n_cb_dist(L)*height(cb_layer(L).points);
    cb_total = cb_total + cb_total_temp;
end

cb_cent = [];

for L = cb_grad_bins:-1:1
    for i = 1:height(cb_layer(L).points)
        if n_cb_dist(L) == 0
        else
            % CB center distance from r_am center
            r_combined = (r_am + r_cb)*cb_distance;
            
            % Random spherical coords
            TH = 2*pi*rand(1,n_cb_dist(L));
            PH = asin(-1+2*rand(1,n_cb_dist(L)));
            
            % Generate cartesian coords for center of each carbon particle on
            % surface of sphere of radius 'r_combined'
            [ cb_cent_temp(:,1), cb_cent_temp(:,2), cb_cent_temp(:,3) ] = sph2cart(TH,PH,r_combined);
            
            % Adjust cb coords relative to AM center
            cb_cent_temp = cb_cent_temp + table2array(cb_layer(L).points(i,:));
            
            % Concatenate arrays
            cb_cent = [cb_cent; cb_cent_temp];
            
            % Plot cb particles
            if plot_cb == 1
                for count = 1 : n_cb_dist(L)
                    surf(   cb_surf_x + cb_cent_temp( count, 1 ),...
                        cb_surf_y + cb_cent_temp( count, 2 ),...
                        cb_surf_z + cb_cent_temp( count, 3 )     );
                end
            end
        end
    end
    
    clear cb_cent_temp
    
    if exist('cb_cent','var') ~= 0
        cb_time = toc(timer_start_cb);
        disp([num2str(length(cb_cent)), '/', num2str(cb_total), ' CB particles generated in ', num2str(cb_time), 's'])
    end
end

% Create table
cb_cent = array2table(cb_cent,'VariableNames',{'x','y','z'});

end


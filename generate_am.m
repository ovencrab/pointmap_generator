function [am_cent, V, v] = generate_am(dim, max_vol_fraction, attempts, r_am, minDist)
% randomly generates AM particles of a particular size in a defined volume
% nearing to a target max volume fraction

% --------------
% Function start
% --------------

V = dim(1)*dim(2)*dim(3);

% Generate random coords in the volume
x = rand(1, attempts)*dim(1);
y = rand(1, attempts)*dim(2);
z = rand(1, attempts)*dim(3);

% Initialize first point and create AM volume (v)
am_cent = [ x(1) y(1) z(1) ];
v = 4/3 * pi * r_am^3;

% Try placing more coords
counter = 2;

for k = 2 : attempts
    if v < V*max_vol_fraction
        % Get a trial coord
        trial_x = x(k);
        trial_y = y(k);
        trial_z = z(k);
        % Check how far it is away from existing coords
        distances = sqrt( ( trial_x - am_cent( :, 1 ) ).^2 +...
            ( trial_y - am_cent( :, 2 ) ).^2 +...
            ( trial_z - am_cent( :, 3 ) ).^2      );
        minDistance = min(distances);
        if minDistance >= minDist
            am_cent(counter,:) = [ trial_x, trial_y, trial_z ];
            counter = counter + 1;
            % Add to volume occupied by AM
            v = v + 4/3 * pi * r_am^3;
        end
        
        if floor(k/floor(attempts/10)) == k/floor(attempts/10)
            disp(['Attempt: ',num2str(k),'~~~~~~ Volume fraction:',num2str(v/V)])
        end
    end
end

% Create table
am_cent = array2table(am_cent,'VariableNames',{'x','y','z'});

end


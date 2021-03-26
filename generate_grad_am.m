function layer = generate_grad_am(am_cent, grad_bins, grad_dist, units)
% generate_grad_am - filters AM into distribution in z dimension

% --------------
% Function start
% --------------

% Discretize AM coords into bins
[bin,~] = discretize(am_cent.z,grad_bins);

% Find size of array for AM 1
sample_num = zeros(1,grad_bins);
for L = grad_bins:-1:1
    grad_layer(L).idx = find(bin == L);
    sample_num(L) = floor(length(grad_layer(L).idx)*grad_dist(L));
    grad_layer(L).sample = sample_num(L);
end

%rows = zeros(1,am_count); % should pre-allocate for best performance
rows = [];
for b = 1:grad_bins
    idx_samp = randsample(grad_layer(b).idx,grad_layer(b).sample);
    rows = [rows; idx_samp];
end

layer(1).points = am_cent(rows,:);
coords = (1:height(am_cent))';
rows2 = setdiff(coords, rows);
layer(2).points = am_cent(rows2,:);

for i = 1:2
    filename = ['points_AM_',num2str(i),'_of_2.xlsx'];
    writecell(units,filename)
    writetable(layer(i).points,filename,'Sheet',1,'Range','A2')
    disp(['Exported AM points file ',num2str(i),' of 2'])
end

end


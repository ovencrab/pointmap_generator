function layer = generate_layers(am_cent, layers_total, dim_z, units)
% generate_layers - filters AM evenly into layers in z dimension

% --------------
% Function start
% --------------

layer_thickness = dim_z/layers_total;

for i = 1:layers_total
    rows = (am_cent.z > layer_thickness*(i-1) & am_cent.z <= layer_thickness*i);
    layer(i).points = am_cent(rows,:);
    filename = ['points_AM_',num2str(i),'_of_',num2str(layers_total),'.xlsx'];
    writecell(units,filename)
    writetable(layer(i).points,filename,'Sheet',1,'Range','A2')
    disp(['Exported AM points file ',num2str(i),' of ',num2str(layers_total)])
end

end


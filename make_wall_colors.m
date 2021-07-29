function wallColors = make_wall_colors(meshData, colorData)
% Create the color values for a fill3 surface of quad or tria elements, based on
% the color values for the grid points
% Inputs:
%       meshData : n X 4 matrix for quad elements or n X 3 matrix for tria
%                           elements containing node numbers with nodes
%                           numbered 1 to m
%       colorData : m X 1 color values for m nodes
% Outputs:
%       wallColors : n X 1 color values for elements

wallColors = zeros([1 size(meshData, 1)]);
element_size = size(meshData, 2);
for n1 = 1:size(meshData,1)
    for n2 = 1:element_size
        wallColors(n1) = wallColors(n1) + colorData(meshData(n1,n2));
    end
end

wallColors = wallColors/element_size;

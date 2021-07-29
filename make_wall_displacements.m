function wallGrid = make_wall_displacements(gridData, meshData)
% creates a surface for fill3 based on grid and mesh data
% Input:
%       gridData : m X 3 matrix of grid points
%       meshData : n X 3 matrix for tria elements or n X 4 matrix for quad
%                           elements with grid point numbers from 1 to m
%Output:
%       wallGrid  : n X 3 matrix for tria elements or n X 4 matrix for quad
%                           elements with grid point coordinates
wallGrid = zeros([fliplr(size(meshData)) 3]);
element_size = size(meshData, 2);

for n1 = 1:size(meshData,1)
    for n2 = 1:3
        for n3 = 1:element_size
            wallGrid(n3,n1,n2) = gridData(meshData(n1,n3),n2);
        end
    end
end
    

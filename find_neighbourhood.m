function neighbourInds = find_neighbourhood(xo, gridPts)
% Return indices of the 50 closest points in the grid to the given point
% Inputs:
%              xo : 1D array with coordinates [x, y, z] of the point
%              gridPts : 2D array of size nPts, 3 with all the points on
%              the grid
% Outputs:
%               neighbourInds : Indices (row numbers) of 50 closest grid points to xo 

    Dists = (gridPts(:,1)-xo(1)).^2 +  (gridPts(:,2)-xo(2)).^2 + (gridPts(:,3)-xo(3)).^2; 
    [~,neighbourInds] = sort(Dists);
    neighbourInds = neighbourInds(1:50);
end
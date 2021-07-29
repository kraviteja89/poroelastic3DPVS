function Vq = fast_griddata(xq, gridPts, v)
% Faster way to interpolate the values using a 3D grid for vector
% quantities
    Neighbour_inds = find_neighbourhood(xq, gridPts);
    Vq = zeros(1,3);
    for n = 1:3
            Vq(n) = griddata(gridPts(Neighbour_inds,1), gridPts(Neighbour_inds,2), gridPts(Neighbour_inds,3), v(Neighbour_inds,n), xq(1), xq(2), xq(3));
    end
end
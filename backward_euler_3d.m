function [Xc, Xp] = backward_euler_3d(Xo,gridPts,umData,xcdotData, tStep)
% calculate trajectories in the ALE coordinates (Xc) and Physical
% coordinates (Xp) 
% Inputs:
%       Xo          : Initial fluid particle positions in ALE coordinates
%       gridPts    : The grid point position (n X 3 matrix) in ALE coordinates, where the
%                           displacement and velocity values are known
%       umData   : displacement data (n x nFrames)
%       xcdotData: velocity data (n x nFrames)
%       dt           : Time step size for COMSOL results

nFrames = size(umData,3);
Xp = nan(nFrames,3);
Xc = nan(nFrames,3);

Xc(1,:) = Xo;
Xp(1,:) = Xc(1,:) + fast_griddata(Xo, gridPts, squeeze(umData(:,:,1)));

% Iteration parameters for backward Euler
tol = 1e-4;
max_iter = 25;

% Backward Euler time integration
X1 = Xo;
for n = 1:nFrames-1
    iter = 1;
    err = 1;
    while err>tol
        Xo = X1;
        X1 = Xc(n,:) + tStep*fast_griddata(Xo, gridPts, squeeze(xcdotData(:,:,n)));
        err = sqrt(sum((Xo-X1).^2));
        iter = iter+1;
        if iter>max_iter
            X1 = 0.5*(X1+Xo);
            break
        end
    end
    Xc(n+1,:) = X1;
    if isnan(Xc(n+1,1))
        return
    end
    Xp(n+1,:) = Xc(n+1,:) + fast_griddata(Xc(n+1,:), gridPts, squeeze(umData(:,:,n+1)));
end
end
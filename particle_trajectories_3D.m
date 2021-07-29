function particle_trajectories_3D(pathName, caseName, reps, dt)
% calculates 3D fluid particle trajectories in ALE and physical coordinates
% for poroelastic model with two domains  
% Inputs:
%       pathName : pathName containing the grid and mesh files, 
%                               along with the velocity and displacement
%                               data from COMSOL for all cases
%       caseName : Folder containing the  velocity and displacement
%                               data from COMSOL for the case of interest
%       reps          : the number of times the COMSOl data is repeated for
%                               particle tracking

% The particle tracking results are saved into a .mat file
%% Load the fluid velocity and mesh displacement data
velScale = 1e6; %convert m/s to um/s
pvsVel = dir([pathName 'ParticleTracking/' caseName 'xcdot1*.txt']);
pvsDisp = dir([pathName 'ParticleTracking/' caseName 'us1*.txt']);

tissueVel = dir([pathName 'ParticleTracking/' caseName 'xcdot2*.txt']);
tissueDisp = dir([pathName 'ParticleTracking/' caseName 'us2*.txt']);

numParts = length(pvsVel); % for simulations where the comsol results are exported to more than one file
pvsVelData = []; tissueVelData = [];
pvsDispData = []; tissueDispData = [];

for n = 1:numParts
    vel_data1 = dlmread([pvsVel(n).folder '/' pvsVel(n).name]);
    disp_data1 = dlmread([pvsDisp(n).folder '/' pvsDisp(n).name]);
    
    vel_data2 = dlmread([tissueVel(n).folder '/' tissueVel(n).name]);
    disp_data2 = dlmread([tissueDisp(n).folder '/' tissueDisp(n).name]);
    
    pvsVelData = [pvsVelData vel_data1(:,4:end)];
    pvsDispData = [pvsDispData disp_data1(:,4:end)];
    
    tissueVelData = [tissueVelData vel_data2(:,4:end)];
    tissueDispData = [tissueDispData disp_data2(:,4:end)];
end

% repeat the data
pvsVelData = [repmat(pvsVelData(:,1:end-3), 1,reps) pvsVelData(:,end-2:end)];
pvsDispData = [repmat(pvsDispData(:,1:end-3), 1,reps) pvsDispData(:, end-2:end)];
tissueVelData = [repmat(tissueVelData(:,1:end-3), 1,reps) tissueVelData(:, end-2:end)];
tissueDispData = [repmat(tissueDispData(:,1:end-3), 1,reps) tissueDispData(:, end-2:end)];
nFrames =  size(pvsVelData, 2)/3;

% collect the grid data
pvsGridPts = vel_data1(:,1:3);
tissueGridPts = vel_data2(:,1:3);
pvsGridSize = size(pvsVelData, 1);
tissueGridSize = size(tissueVelData, 1);

pvsVelData = reshape(pvsVelData, pvsGridSize, 3, nFrames);
pvsDispData = reshape(pvsDispData, pvsGridSize, 3, nFrames);
tissueVelData = reshape(tissueVelData, tissueGridSize, 3, nFrames);
tissueDispData = reshape(tissueDispData, tissueGridSize, 3, nFrames);

velData = [pvsVelData; tissueVelData];
dispData = [pvsDispData; tissueDispData];
gridPts = [pvsGridPts; tissueGridPts];
%% Calculate particle trajectories in pvs
pvsParticles = dlmread([pathName 'Mesh/PVS_particle_grid.txt']);

numPvs = size(pvsParticles,1);
traj_pvs_lag = zeros(nFrames,3,numPvs);
traj_pvs_eul = zeros(nFrames,3,numPvs);

parfor n=1:numPvs
    [traj_pvs_lag(:,:,n), traj_pvs_eul(:,:,n)]  = backward_euler_3d(pvsParticles(n,:),gridPts,dispData,velData*velScale,dt);
end

save([pathName caseName(1:end-1) '_reps'  num2str(reps) '.mat'], 'traj_pvs_eul', 'traj_pvs_lag', '-v7.3')
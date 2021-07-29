function exchangePercent = end_exchange_percentage(pathName, caseName, reps, sasThresh)
% calculate the pvs fluid exchange percentage from precalculated particle
% trajectories, for the last frame
% Inputs:
%           pathName : location of the exported data folders from COMSOL
%                             along with the grids and meshes for postprocessing
%           caseName : The folder name for the particular simulation
%           reps          : number of times the result of the COMSOL model are
%                             repeated for the particle tracking
%                             simulation
%           sasThresh  : The z value splitting the fluid domain into PVS
%                              and SAS
% Outputs:
%           exchangeFractions : Exchange percentage for PVS fluid for all
%                                         time points
pvsBoundaries.vertices = dlmread([pathName 'Mesh/'  'PVS_boundaries_grid.txt']);
pvsBoundaries.faces = int16(dlmread([pathName 'Mesh/'  'PVS_boundaries_mesh.txt']));

caseData = load([pathName caseName  '_reps'  num2str(reps) '.mat']);
[nFrames, ~, numPVS] = size(caseData.traj_pvs_lag);

exchangePercent = zeros(1, 3);
for n = nFrames
    particlePositions = squeeze(caseData.traj_pvs_lag(n, :, :));
    
    % remove particles in the SAS
    particlesInSas = sum(isnan(particlePositions(1,:))) + sum(particlePositions(3,:) >= sasThresh);
    particlePositions = particlePositions(:, ~isnan(particlePositions(1,:)));
    particlePositions = particlePositions(:, particlePositions(3,:) < sasThresh);
    
    % Find the particles remaining in the PVS
    in1 = inpolyhedron(pvsBoundaries, particlePositions', 'flipnormals', true);
    particlesInPVS = sum(in1);
    
    particlesInBrain = length(in1) - particlesInPVS;
    particleFractions = [particlesInPVS, particlesInSas, particlesInBrain]/numPVS;
    exchangePercent = 100*particleFractions;
end
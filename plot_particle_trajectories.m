function plot_particle_trajectories(pathName, caseName, caption, dt, reps, figName)
% plot particle trajectories in the lagrangian (undeformed solid) frame
% Inputs:
%           pathName  : location of the exported data folders from COMSOL
%                             along with the grids and meshes for postprocessing
%           caseName  : The folder name for the particular simulation
%           caption      : The title for the plots
%           dt              : Size of the timestep for4 particle tracking
%           reps          : number of times the result of the COMSOL model are
%                             repeated for the particle tracking
%                             simulation
%           figName   : file name of the figure with the trajectories 
%% Load the wall data and create the walls
vesselMesh = dlmread([pathName 'Mesh/Vessel_wall_mesh.txt']);
interfaceMesh = dlmread([pathName 'Mesh/Interface_mesh.txt']);
tissueMesh = dlmread([pathName 'Mesh/Tissue_wall_mesh.txt']);
sasMesh = dlmread([pathName 'Mesh/SAS_wall_mesh.txt']);

vesselGrid = dlmread([pathName 'Mesh/Vessel_wall_grid.txt']);
interfaceGrid = dlmread([pathName 'Mesh/Interface_grid.txt']);
tissueGrid = dlmread([pathName 'Mesh/Tissue_wall_grid.txt']);
sasGrid = dlmread([pathName 'Mesh/SAS_wall_grid.txt']);

vesselWall = make_wall_displacements(vesselGrid , vesselMesh);
interfaceWall = make_wall_displacements(interfaceGrid, interfaceMesh);
tissueWall = make_wall_displacements(tissueGrid, tissueMesh);
sasWall = make_wall_displacements(sasGrid, sasMesh);
%% Plot lagrangian particle trajectories
load([pathName caseName  '_reps'  num2str(reps) '.mat']);
[nFrames, ~, nParticles] = size(traj_pvs_lag);

fig = figure();
set(fig, 'Position', [10 50 1200 925])
set(fig, 'Color','w')
minZ = min(vesselGrid(:,3));

fill3(sasWall(:,:,1), sasWall(:,:,2), sasWall(:,:,3), 'c', 'LineStyle', 'none', 'FaceAlpha', 0.1);
hold on

% plot particle trajectories and end points
for n = 1:nParticles
    plot3(traj_pvs_lag(:,1,n), traj_pvs_lag(:,2,n), traj_pvs_lag(:,3,n), 'Color',   [0 0.6 0] , 'LineWidth', 1)
    scatter3(squeeze(traj_pvs_lag(end,1,n)), squeeze(traj_pvs_lag(end,2,n)), squeeze(traj_pvs_lag(end,3,n)), 'MarkerFaceColor', [0 0.6 0], 'MarkerEdgeColor', [0 0.4 0])
end

% plot the walls
fill3(vesselWall(:,:,1), vesselWall(:,:,2), vesselWall(:,:,3), 'r', 'LineStyle', 'none', 'FaceAlpha', 0.1);
fill3(interfaceWall(:,:,1), interfaceWall(:,:,2), interfaceWall(:,:,3), 'g', 'LineStyle', 'none', 'FaceAlpha', 0.1);
fill3(tissueWall(:,:,1), tissueWall(:,:,2), tissueWall(:,:,3), 'm', 'LineStyle', 'none', 'FaceAlpha', 0.1);
        
title([caption ': t='  num2str((nFrames-1)*dt, '%.1f') 's'], 'FontSize', 25)
axis equal
axis off
view(-69, 25)
xlim([-5 85])
ylim([-100 100])
zlim([minZ-10 300])
hold off

view(-29,25)
saveas(fig, [pathName figName '.png'])
saveas(fig, [pathName figName '.fig'])

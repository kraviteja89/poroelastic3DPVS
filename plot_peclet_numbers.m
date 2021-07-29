function  maxPecletRadial =  plot_peclet_numbers(pathName, caseName, pecletLimit, caption, figName)
% calculate and plot the time averaged Peclet number from exported COMSOL
% data
% Inputs:
%           pathName : location of the exported data folders from COMSOL
%                             along with the grids and meshes for postprocessing
%           caseName : The folder name for the particular simulation
% Optional inputs - skip these if you don't want plots
%           pecletLimit : Maximum value of Peclet number in the colormap 
%           caption      : The title for the plots
 %          figName    : file name of the figure with the trajectories 

% Outputs:
%           maxPecletRadial : Maximum time averaged Peclet number
%% Load the data
pecletNumberData = dlmread([pathName 'ParticleTracking/' caseName '/Peclet_numbers.txt']);
pecletMesh = dlmread([pathName 'Mesh/Peclet_wall_mesh.txt']);
pecletGrid = pecletNumberData(:,1:3);
pecletNumberData = pecletNumberData(:, 4:end);
%% Calculate the time averaged peclet number
meanPecletRadial = make_wall_colors(pecletMesh, mean(pecletNumberData, 2));
maxPecletRadial = max(meanPecletRadial);
%% Check if plots are required
if nargin < 3
    return
end    
%% Load the wall data for making plots
vesselMesh = dlmread([pathName 'Mesh/Vessel_wall_mesh.txt']);
interfaceMesh = dlmread([pathName 'Mesh/Interface_mesh.txt']);
tissueMesh = dlmread([pathName 'Mesh/Tissue_wall_mesh.txt']);
sasMesh = dlmread([pathName 'Mesh/SAS_wall_mesh.txt']);

vesselGrid = dlmread([pathName 'Mesh/Vessel_wall_grid.txt']);
interfaceGrid = dlmread([pathName 'Mesh/Interface_grid.txt']);
tissueGrid = dlmread([pathName 'Mesh/Tissue_wall_grid.txt']);
sasGrid = dlmread([pathName 'Mesh/SAS_wall_grid.txt']);
%% Make the walls for the geometry and for plotting the Peclet Numbers
vesselWall = make_wall_displacements(vesselGrid , vesselMesh);
interfaceWall = make_wall_displacements(interfaceGrid, interfaceMesh);
tissueWall = make_wall_displacements(tissueGrid, tissueMesh);
sasWall = make_wall_displacements(sasGrid, sasMesh);

pecletWall = make_wall_displacements(pecletGrid, pecletMesh);
%% Plot peclet numbers
fig = figure();
set(fig, 'Position', [-100 -100 3000 1100])
set(gcf, 'Color','w')

fill3(vesselWall(:,:,1), vesselWall(:,:,2), vesselWall(:,:,3), 'r', 'LineStyle', 'none', 'FaceAlpha', 0.2);
hold on
fill3(interfaceWall(:,:,1), interfaceWall(:,:,2), interfaceWall(:,:,3), 'g', 'LineStyle', 'none', 'FaceAlpha', 0.1);
fill3(tissueWall(:,:,1), tissueWall(:,:,2), tissueWall(:,:,3), 'm', 'LineStyle', 'none', 'FaceAlpha', 0.1);
fill3(sasWall(:,:,1), sasWall(:,:,2), sasWall(:,:,3), 'c', 'LineStyle', 'none', 'FaceAlpha', 0.1);
fill3(pecletWall(:,:,1), pecletWall(:,:,2), pecletWall(:,:,3),  meanPecletRadial, 'LineStyle', 'none', 'FaceAlpha', 1)
colorbar('southoutside')
caxis([0 pecletLimit])
axis equal
axis off
title(['Time averaged Peclet Number-' caption])
view(-69, 25)
xlim([-5 85])
ylim([-100 100])
zlim([70 300])
%% Save the Peclet Number Plots
saveas(fig, [pathName figName '.png'])
saveas(fig, [pathName figName '.fig'])
